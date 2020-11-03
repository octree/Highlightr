import Foundation
import JavaScriptCore

enum TokenValue: Decodable {
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
        } else {
            self = .node(try TokenNode(from: decoder))
        }
    }
    case string(String)
    case node(TokenNode)
}

struct TokenNode: Decodable {
    public var kind: String?
    public var children: [TokenValue]
}

public struct Attributes {
    public var length: Int
    public var attributes: [NSAttributedString.Key: Any]
}

open class Highlightr {
    private var hljs: JSValue!
    public private(set) var theme: Theme!
    open var themeDidChanged: ((Theme) -> Void)?
    @inline(__always) private var defaultBundle: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: Highlightr.self)
        #endif
    }

    public init?(jsPath: String? = nil, theme: String? = nil) {
        guard let path = jsPath ?? defaultBundle.path(forResource: "highlight", ofType: "js"),
              let js = try? String(contentsOfFile: path) else {
            return nil
        }
        let context = JSContext()
        let window = JSValue(newObjectIn: context)
        context?.setObject(window, forKeyedSubscript: "window" as NSString)
        context?.evaluateScript(js)
        guard let hljs = window?.objectForKeyedSubscript("hljs") else {
            return nil
        }
        self.hljs = hljs
        guard setTheme(to: theme ?? "dracula") else {
            return nil
        }
    }

    open func setTheme(to name: String, bundle: Bundle? = nil) -> Bool {
        guard let theme = theme(for: name, bundle: bundle ?? defaultBundle) else {
            return false
        }
        self.theme = theme
        themeDidChanged?(theme)
        return true
    }

    open func supportedLanguages() -> [String] {
        let res = hljs.invokeMethod("listLanguages", withArguments: [])
        return res!.toArray() as! [String]
    }

    open func highlight(_ code: String, as language: String?) -> [Attributes] {
        let ret = hljs.invokeMethod("highlight", withArguments: [language ?? "plain", code])
        guard let json = ret?.objectForKeyedSubscript("value"),
              let data = json.toString()?.data(using: .utf8) else {
            return []
        }
        do {
            let tokenTree = try JSONDecoder().decode(TokenNode.self, from: data)
            return tokens(for: tokenTree)
        } catch {
        }
        return []
    }

    private func theme(for name: String, bundle: Bundle) -> Theme? {
        guard let path = bundle.path(forResource: name + ".min", ofType: "css") else {
            return nil
        }
        let themeString = try! String.init(contentsOfFile: path)
        return Theme(themeString: themeString)
    }

    private func tokens(for tree: TokenNode) -> [Attributes] {
        var result = [Attributes]()
        let kind = tree.children.count == 1 ? tree.kind : nil
        let styles = kind.map { ["hljs", "hljs-" + $0] } ?? ["hljs"]
        for elt in tree.children {
            switch elt {
            case let .string(string):
                let attrs = theme.styles(for: styles)
                result.append(Attributes(length: string.utf16.count, attributes: attrs))
            case let .node(node):
                result.append(contentsOf: tokens(for: node))
            }
        }
        return result
    }
}

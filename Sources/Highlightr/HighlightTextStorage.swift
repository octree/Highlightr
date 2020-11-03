import Foundation
#if os(OSX)
import AppKit
#elseif os(iOS)
import UIKit
#endif

open class HighlightTextStorage: NSTextStorage {
    public let highlightr: Highlightr
    open var language: String?
    let stringStorage = NSTextStorage()
    public init(highlightr: Highlightr) {
        self.highlightr = highlightr
        super.init()
        commitInit()
    }

    required public init?(coder: NSCoder) {
        self.highlightr = Highlightr()!
        super.init(coder: coder)
        commitInit()
    }

    #if os(OSX)
    required public init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        self.highlightr = Highlightr()!
        super.init(pasteboardPropertyList: propertyList, ofType: type)
        commitInit()
    }
    #endif

    private func commitInit() {
        highlightr.themeDidChanged = { [weak self] theme in
            guard let self = self else {
                return
            }
            self.highlight(in: NSRange(location: 0, length: self.stringStorage.length))
        }
    }

    open override func processEditing() {
        super.processEditing()
        if language != nil {
            if self.editedMask.contains(.editedCharacters) {
                let string = (self.string as NSString)
                let range = string.paragraphRange(for: editedRange)
                highlight(in: range)
            }
        }
    }

    private func highlight(in range: NSRange) {
        guard let language = language else {
            return
        }
        DispatchQueue.global().async {
            let string = (self.string as NSString)
            let paragraph = string.substring(with: range)
            let start = range.location
            let attrs = self.highlightr.highlight(paragraph as String, as: language)
            DispatchQueue.main.async {
                guard self.stringStorage.length >= range.location + range.length
                    && self.stringStorage.attributedSubstring(from: range).string == paragraph else {
                    return
                }
                var location = start
                self.beginEditing()
                for elt in attrs {
                    self.addAttributes(elt.attributes, range: NSRange(location: location, length: elt.length))
                    location += elt.length
                }
                self.edited(.editedAttributes, range: range, changeInLength: 0)
                self.endEditing()
            }
        }
    }

    open override var string: String {
        stringStorage.string
    }
    open override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key: Any] {
        return stringStorage.attributes(at: location, effectiveRange: range)
    }

    open override func replaceCharacters(in range: NSRange, with str: String) {
        stringStorage.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
    }

    open override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        stringStorage.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
}

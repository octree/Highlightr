//
//  ViewController.swift
//  Example
//
//  Created by Octree on 2020/11/3.
//

import UIKit
import Highlightr


class ViewController: UIViewController {
    private var higlightr: Highlightr = Highlightr(theme: "atom-one-dark")!
    private lazy var textView: UITextView = {
        let textStorage = HighlightTextStorage(highlightr: higlightr)
        textStorage.language = "swift"
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let container = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(container)
        let textView = UITextView(frame: CGRect(x: 20, y: 100, width: 400, height: 600), textContainer: container)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartQuotesType = .no
        textView.backgroundColor = textStorage.highlightr.theme.themeBackgroundColor
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


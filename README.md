# Highlightr

[![Version](https://img.shields.io/cocoapods/v/Highlightr.svg?style=flat)](http://cocoapods.org/pods/Highlightr)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/cocoapods/l/Highlightr.svg?style=flat)](http://cocoapods.org/pods/Highlightr)
[![Platform](https://img.shields.io/cocoapods/p/Highlightr.svg?style=flat)](http://cocoapods.org/pods/Highlightr)

Highlightr is an iOS & macOS syntax highlighter built with Swift. It uses [highlight.js](https://highlightjs.org/) as it core, supports [185 languages and comes with 89 styles](https://highlightjs.org/static/demo/).

Takes your lame string with code and returns a NSAttributtedString with proper syntax highlighting.

![Sample Demo](./coding.gif)

## Installation
### Requirements
- iOS 10.0+
- macOS 10.10+

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Highlightr into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target '<Your Target Name>' do
    pod 'Highlightr'
end
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager


The [Swift Package Manager](https://swift.org/package-manager/) automates the distribution of Swift code. To use `Highlightr` with SPM, add a dependency to your `Package.swift` file:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/octree/Highlightr.git", ...)
    ]
)
```

## Usage
Highlightr provides two main classes:

### Highlightr

```Swift
	let highlightr = Highlightr()
	highlightr.setTheme(to: "dracula")
	let code = "let a = 1"
	// You can omit the second parameter to use automatic language detection.
	let highlightedCode = highlightr.highlight(code, as: "swift") 
	
```
### HighlightTextStorage

A subclass of NSTextStorage, you can use it to highlight text on real time.
```Swift
	let textStorage = HighlightTextStorage()
	textStorage.language = "Swift"
	let layoutManager = NSLayoutManager()
	textStorage.addLayoutManager(layoutManager)

	let textContainer = NSTextContainer(size: view.bounds.size)
	layoutManager.addTextContainer(textContainer)

	let textView = UITextView(frame: yourFrame, textContainer: textContainer)
```

## JavaScript?

Yes, Highlightr relies on iOS & macOS [JavaScriptCore](https://developer.apple.com/library/ios/documentation/Carbon/Reference/WebKit_JavaScriptCore_Ref/index.html#//apple_ref/doc/uid/TP40004754) to parse the code using highlight.js. This is actually quite fast!

## Performance

It will never be as fast as a native solution, but it's fast enough to be used on a real time editor.

It's taking around of 7.4ms on my iPhone  iPhone Xs Max for processing 100 lines of swift code.



## License

Highlightr is available under the MIT license. See the LICENSE file for more info.

Highlight.js is available under the BSD license. You can find the [license file here](https://github.com/isagalaev/highlight.js/blob/master/LICENSE).

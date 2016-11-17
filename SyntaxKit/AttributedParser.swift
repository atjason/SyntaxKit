//
//  AttributedParser.swift
//  SyntaxKit
//
//  Created by Sam Soffes on 9/24/14.
//  Copyright © 2014-2015 Sam Soffes. All rights reserved.
//

public class AttributedParser: Parser {

	// MARK: - Types

	public typealias AttributedCallback = (_ scope: String, _ range: NSRange, _ attributes: Attributes?) -> Void


	// MARK: - Properties

	public let theme: Theme


	// MARK: - Initializers

	public required init(language: Language, theme: Theme) {
		self.theme = theme
		super.init(language: language)
	}


	// MARK: - Parsing

	public func parse(string: String, match callback: @escaping AttributedCallback) {
		parse(string: string) { scope, range in
			callback(scope, range, self.attributesForScope(scope: scope))
		}
	}

	public func attributedStringForString(string: String, baseAttributes: Attributes? = nil) -> NSAttributedString {
		let output = NSMutableAttributedString(string: string, attributes: baseAttributes)
		parse(string: string) { _, range, attributes in
			if let attributes = attributes {
				output.addAttributes(attributes, range: range)
			}
		}
		return output
	}


	// MARK: - Private

	private func attributesForScope(scope: String) -> Attributes? {
		let components = scope.components(separatedBy: ".") as NSArray
		let count = components.count
		if count == 0 {
			return nil
		}

		var attributes = Attributes()
		for i in 0..<components.count {
			let key = (components.subarray(with: NSMakeRange(0, count - 1 - i)) as NSArray).componentsJoined(by: ".")
			if let attrs = theme.attributes[key] {
				for (k, v) in attrs {
					attributes[k] = v
				}
			}
		}

		if attributes.isEmpty {
			return nil
		}

		return attributes
	}
}

//
//  Language.swift
//  SyntaxKit
//
//  Created by Sam Soffes on 9/18/14.
//  Copyright © 2014-2015 Sam Soffes. All rights reserved.
//

import Foundation

public struct Language {

	// MARK: - Properties

	public let UUID: String
	public let name: String
	public let scopeName: String
	let patterns: [Pattern]


	// MARK: - Initializers

	public init?(dictionary: [String: AnyObject]) {
		guard let UUID = dictionary["uuid"] as? String,
			let name = dictionary["name"] as? String,
			let scopeName = dictionary["scopeName"] as? String
			else { return nil }

		self.UUID = UUID
		self.name = name
		self.scopeName = scopeName

		var repository = [String: Pattern]()
		if let repo = dictionary["repository"] as? [String: [String: AnyObject]] {
			for (key, value) in repo {
				if let pattern = Pattern(dictionary: value) {
					repository[key] = pattern
				}
			}
		}

		var patterns = [Pattern]()
		if let array = dictionary["patterns"] as? [[String: AnyObject]] {
			for value in array {
				if let include = value["include"] as? String {          
					let key = include.substring(from: include.index(after: include.startIndex))
					if let pattern = repository[key] {
						patterns.append(pattern)
						continue
					}
				}

				if let pattern = Pattern(dictionary: value) {
					patterns.append(pattern)
				}
			}
		}
		self.patterns = patterns
	}
}

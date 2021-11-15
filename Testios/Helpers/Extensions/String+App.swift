//
//  String+App.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation

extension String {
    // Removes whitespace from the both sides of a string
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var nonEmpty: String? {
        return self.trimmed.isEmpty ? nil : self
    }
}

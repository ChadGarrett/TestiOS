//
//  Array+App.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation

extension Array {
    func isIndexValid(_ index: Int) -> Bool {
        return index >= 0 && index < count
    }

    /// Safe index operator. Returns the item at the index if it doesn't exceed the array's range.
    func item(at index: Int) -> Element? {
        guard isIndexValid(index) else { return nil }
        return self[index]
    }
}

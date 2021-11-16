//
//  ProviderQueryOptions.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/16.
//  Copyright © 2021 Personal. All rights reserved.
//

struct ProviderQueryOptions: OptionSet {
    let rawValue: Int

    /// Do not filter data by the output's `filter` predicate.
    static let notFiltered = ProviderQueryOptions(rawValue: 1 << 0)

    /// Do not sort data by the output's `sort` descriptors.
    static let notSorted = ProviderQueryOptions(rawValue: 1 << 1)

    /// Do not limit the data (particularly the count) by the output's `limit` value.
    static let notLimited = ProviderQueryOptions(rawValue: 1 << 2)
}

extension ProviderQueryOptions {
    /// By default, all options are enabled, so none are disabled.
    static let `default`: ProviderQueryOptions = []
}

extension ProviderQueryOptions {
    var isFiltered: Bool {
        return !self.contains(.notFiltered)
    }

    var isSorted: Bool {
        return !self.contains(.notSorted)
    }

    var isLimited: Bool {
        return !self.contains(.notLimited)
    }
}

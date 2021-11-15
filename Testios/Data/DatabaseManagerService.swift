//
//  DatabaseManagerService.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import RealmSwift

/// Base class for interacting with realm
/// To add different objects, inherit from this with custom CRUD implementations
class DatabaseManagerService {

    internal var database: Realm

    internal init() {
        database = try! Realm()
    }

    /// Resets/clears the database
    func deleteAllFromDatabase() {
        try? self.database.write {
            database.deleteAll()
        }
    }
}

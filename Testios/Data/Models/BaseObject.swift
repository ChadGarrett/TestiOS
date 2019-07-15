//
//  BaseObject.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import RealmSwift

/// Base object that all objects which are going to be stored in realm should inherit from
class BaseObject: Object {
    @objc dynamic var id: String = ""
    
    override internal static func primaryKey() -> String? {
        return "id"
    }
}

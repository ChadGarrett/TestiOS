//
//  BaseObject.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/16.
//  Copyright © 2021 Personal. All rights reserved.
//

import RealmSwift

public class BaseObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
}

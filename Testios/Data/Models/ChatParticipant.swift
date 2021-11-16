//
//  ChatParticipant.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/16.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation

final class ChatParticipant {
    let key: UUID
    let name: String

    init(name: String) {
        self.key = UUID()
        self.name = name
    }
}

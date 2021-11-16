//
//  ChatMessage.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/16.
//  Copyright © 2021 Personal. All rights reserved.
//

import RealmSwift
import SZMentionsSwift

final class ChatMessage: BaseObject {
    @Persisted() var senderName: String
    @Persisted() var textContent: String
    @Persisted() var timestamp: Date

    // TODO: To store mentions we're going to need to break them down into a simpler form
}

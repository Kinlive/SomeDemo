//
//  FakeMsgFactory.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/7.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import Foundation

class FakeMsgFactory {

}

func fakeMsg(id: Int, userName: String, message: String, type: Int = 0, messages: String = "", lastMessageID: Int = 0) -> [String: Any] {
  return [
    MsgKeys.id.key       : id,
    MsgKeys.type.key     : type,
    MsgKeys.userName.key : userName,
    MsgKeys.message.key  : message,
    MsgKeys.messages.key : messages
  ]
}

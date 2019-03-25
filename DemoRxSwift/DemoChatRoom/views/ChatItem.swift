//
//  ChatItem.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/7.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit

enum ChatType {
  case `self`
  case other
}

class ChatItem {
  var text: String?
  var image: UIImage?
  var chatType: ChatType

  init(text: String?, image: UIImage?, chatType: ChatType) {
    self.text = text
    self.image = image
    self.chatType = chatType
  }
}

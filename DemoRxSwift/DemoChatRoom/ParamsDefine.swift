//
//  ParamsDefine.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/7.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit


/** ChatView layout's setup params
 ```
 case yPadding: bubbleView的間隔距離為 20
 ```
 */
enum ChatViewParams {
  case yPadding
}

extension ChatViewParams {
  var value: CGFloat {
    switch self {
    case .yPadding: return 20.0
    }
  }
}

/** ChatBubbleView layout's setup params.
 ```
 case sidePaddingRate     0.02
 case maxBubbleWidthRate  0.7
 case contentMargin       10.0
 case bubbleTaleWidth     10.0
 case textFontSize        16.0
```
 */
enum ChatBubbleViewParams {
  case sidePaddingRate
  case maxBubbleWidthRate
  case contentMargin
  case bubbleTaleWidth
  case textFontSize
}

extension ChatBubbleViewParams {
  var value: CGFloat {
    switch self {
    case .sidePaddingRate:    return 0.02
    case .maxBubbleWidthRate: return 0.7
    case .contentMargin:      return 10.0
    case .bubbleTaleWidth:    return 10.0
    case .textFontSize:       return 16.0
    }
  }
}

/** All about message's key
 ```
 case id
 case type
 case userName
 case message
 case messages
 case deviceToken
 case groupName
 case lastMessageID
 case data
 case result
 case errorCode
```
 */
enum MsgKeys {
  case id
  case type
  case userName
  case message
  case messages
  case deviceToken
  case groupName
  case lastMessageID
  case data
  case result
  case errorCode
}

extension MsgKeys {
  var key: String  {
    switch self {
    case .id:             return "id"
    case .type:           return "Type"
    case .userName:       return "UserName"
    case .message:        return "Message"
    case .messages:       return "Messages"
    case .deviceToken:    return "DeviceToken"
    case .groupName:      return "GroupName"
    case .lastMessageID:  return "LastMessageID"
    case .data:           return "data"
    case .result:         return "result"
    case .errorCode:      return "errorCode"
    }
  }
}

//
//  ChatView.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/7.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit

class ChatView: UIScrollView {

  private var allItems: [ChatItem] = []

  private var lastBubbleViewY: CGFloat = 0

  private var lastBubbleView: ChatBubbleView!

  func addChat(item: ChatItem) {

    let bubbleView = ChatBubbleView(item: item, offsetY: lastBubbleViewY + ChatViewParams.yPadding.value)

    addSubview(bubbleView)

    lastBubbleView = bubbleView
    lastBubbleViewY = bubbleView.frame.maxY
    contentSize = CGSize(width: frame.size.width, height: lastBubbleViewY)

    /** scroll to bottom and display chatBubbleView
     let leftBottomRect = CGRect(x: 0, y: lastBubbleViewY - 1, width: 1, height: 1)
     scrollRectToVisible(leftBottomRect, animated: true)
     */
    scrollRectToVisible(bubbleView.frame, animated: true)

    // keep item.
    allItems.append(item)

  }

  func scrollToVisible() {
    guard lastBubbleView != nil else { return }
    scrollRectToVisible(lastBubbleView.frame, animated: true)
  }

  func reloadAllItems() {

    subviews.forEach { $0.removeFromSuperview() }

    var previousItems: [ChatItem] = []
    allItems.forEach { previousItems.append($0) }
    allItems.removeAll()
    lastBubbleViewY = 0

    previousItems.forEach { addChat(item: $0) }
  }
}

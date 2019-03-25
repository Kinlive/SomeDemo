//
//  ChatBubbleView.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/7.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit

class ChatBubbleView: UIView {

  var currentY: CGFloat = 0
  var photoImageView: UIImageView!
  var textLabel: UILabel!
  var backgroundImageView: UIImageView!

  convenience init(item: ChatItem, offsetY: CGFloat) {
    self.init()
    self.frame = calculateBasicFrameWith(item.chatType, offsetY)

    if let image = item.image {
      calculateWith(image, item.chatType)
    }

    if let text = item.text {
      calculateWith(text, item.chatType)
    }

    calculateFinalSizeWith(item.chatType)
    prepareBackgroundImageWith(item.chatType)

  }

  init() {
    super.init(frame: .zero)

  }

  required init?(coder aDecoder: NSCoder) {
   super.init(coder: aDecoder)

  }

  // Calculate basic frame
  private func calculateBasicFrameWith(_ type: ChatType, _ offsetY: CGFloat) -> CGRect {
    let screenWidth = UIScreen.main.bounds.size.width
    let sidePadding = screenWidth * ChatBubbleViewParams.sidePaddingRate.value
    let maxWidth = screenWidth * ChatBubbleViewParams.maxBubbleWidthRate.value
    var offsetX: CGFloat

    switch type {
    case .self:
      offsetX = screenWidth - sidePadding - maxWidth
    case .other:
      offsetX = sidePadding
    }
    return CGRect(x: offsetX, y: offsetY, width: maxWidth, height: 1)
  }

  // calculateWith image
  private func calculateWith(_ image: UIImage, _ type: ChatType) {
    var x = ChatBubbleViewParams.contentMargin.value
    let y = ChatBubbleViewParams.contentMargin.value

    if type == .other {
      x += ChatBubbleViewParams.bubbleTaleWidth.value
    }

    // calculate display size.
    let gap = 2 * ChatBubbleViewParams.contentMargin.value - ChatBubbleViewParams.bubbleTaleWidth.value
    let displayWidth = min(image.size.width, frame.size.width - gap)
    let displayRatio = displayWidth / image.size.width
    let displayHeight = image.size.height * displayRatio
    let displayFrame = CGRect(x: x, y: y, width: displayWidth, height: displayHeight)

    //prepare photo imageView.
    photoImageView = UIImageView(frame: displayFrame)
    photoImageView.image = image
    photoImageView.layer.cornerRadius = 5.0
    photoImageView.layer.masksToBounds = true

    addSubview(photoImageView)

    currentY = displayFrame.maxY
  }

  // calculate text
  private func calculateWith(_ text: String,_ type: ChatType) {
    var x = ChatBubbleViewParams.contentMargin.value
    let y = ChatBubbleViewParams.contentMargin.value + ChatBubbleViewParams.textFontSize.value / 2

    if type == .other {
      x += ChatBubbleViewParams.bubbleTaleWidth.value
    }

    // calculate display size
    let gap = 2 * ChatBubbleViewParams.contentMargin.value - ChatBubbleViewParams.bubbleTaleWidth.value
    let displayWidth = frame.size.width - gap
    let displayHeight = ChatBubbleViewParams.textFontSize.value
    let displayFrame = CGRect(x: x, y: y, width: displayWidth, height: displayHeight)

    // prepare textLabel
    textLabel = UILabel(frame: displayFrame)
    textLabel.font = UIFont.systemFont(ofSize: ChatBubbleViewParams.textFontSize.value)
    textLabel.text = text
    textLabel.numberOfLines = 0
    textLabel.sizeToFit()
    addSubview(textLabel)

    // update currentY
    currentY = textLabel.frame.maxY
  }

  // final chatBubbleView size
  private func calculateFinalSizeWith(_ type: ChatType) {
    var finalWidth: CGFloat = 0
    let finalHeight = currentY + ChatBubbleViewParams.contentMargin.value

    // image
    if let imageView = photoImageView {
      finalWidth = imageView.frame.maxX + ChatBubbleViewParams.contentMargin.value
      finalWidth += (type == .self) ? ChatBubbleViewParams.bubbleTaleWidth.value : 0
    }

    // text
    if let label = textLabel {
      var labelWidth: CGFloat = label.frame.maxX + ChatBubbleViewParams.contentMargin.value
      labelWidth += (type == .self) ? ChatBubbleViewParams.bubbleTaleWidth.value : 0
      finalWidth = max(labelWidth, finalWidth)
    }

    // final adjustment
    if type == .self && photoImageView == nil {
      frame.origin.x += frame.size.width - finalWidth
    }

    // update frame
    frame.size = CGSize(width: finalWidth, height: finalHeight)
  }

  // background image
  private func prepareBackgroundImageWith(_ type: ChatType) {
    let bgFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    backgroundImageView = UIImageView(frame: bgFrame)
    if type == .self {
      let image = UIImage(named: "fromMe")?.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 14, bottom: 17, right: 28))
      backgroundImageView.image = image
    } else {
      let image = UIImage(named: "fromOthers")?.resizableImage(withCapInsets: UIEdgeInsets(top: 14, left: 22, bottom: 17, right: 20))
      backgroundImageView.image = image
    }
    addSubview(backgroundImageView)
    sendSubviewToBack(backgroundImageView)

  }

}

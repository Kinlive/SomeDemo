//
//  ChatRoomViewController.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/7.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let MyName = "Kin"

class ChatRoomViewController: UIViewController {

  @IBOutlet weak var chatView: ChatView!
  @IBOutlet weak var inputTextField: UITextField!
  @IBOutlet weak var moreOptionBtn: UIButton!
  @IBOutlet weak var passMessageBtn: UIButton!
  @IBOutlet weak var addMessagesBtn: UIButton!
  @IBOutlet weak var inputBaseView: UIView!

  @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!

  private var incommingMessages: [[String: Any]] = []
  private var reloadLock: NSLock = NSLock()
  private var shouldReloadAgain: Bool = false

  let disposeBag = DisposeBag()

  let fakeMessage: [[String: Any]] = [
    fakeMsg(id: 1, userName: "Tom", message: "安安安"),
    fakeMsg(id: 2, userName: "Nini", message: "吃飯沒"),
    fakeMsg(id: 3, userName: "Jobs", message: "我活過來拉!!!!!"),
    fakeMsg(id: 3, userName: "Jobs", message: "大家有想念我嗎??"),
    fakeMsg(id: 2, userName: "Nini", message: "Jobs被氣到又爬起來了...."),
    fakeMsg(id: 1, userName: "Tom", message: "我的天啊....")
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    passMessageBtn.rx.tap.subscribe({ [unowned self] _ in
      if self.inputTextField.text?.count == 0 {
        self.resignFirstResponder()
        return
      }
      self.resignFirstResponder()
      self.incommingMessages.append(fakeMsg(id: 1, userName: MyName, message: self.inputTextField.text!))
      self.handleIncommingMsg()
      self.inputTextField.text = ""
    }).disposed(by: disposeBag)

    moreOptionBtn.rx.tap.subscribe({ [unowned self] _ in
      self.resignFirstResponder()
      let random = Int(arc4random_uniform(UInt32(self.fakeMessage.count)))
      self.incommingMessages.append(self.fakeMessage[random])
      self.handleIncommingMsg()
    }).disposed(by: disposeBag)

    addMessagesBtn.rx.tap.subscribe({ [unowned self] _ in
      self.incommingMessages.append(contentsOf: self.fakeMessage)
      self.handleIncommingMsg()
    }).disposed(by: disposeBag)

    closeWhenTapBackground()
    handleIncommingMsg()

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    // Do any additional setup after loading the view.
  }

  @objc
  private func keyboardWillChange(_ notification: Notification) {
    guard let payload = KeyboardInfo(notification) else { return }
    let keyboardFrame = payload.frameEnd

    if notification.name == UIResponder.keyboardWillShowNotification {
      inputBottomConstraint.constant = -keyboardFrame.height + 30
      UIView.animate(withDuration: payload.animationDuration) {
        self.view.layoutIfNeeded()
        self.chatView.scrollToVisible()
      }
    } else {
      inputBottomConstraint.constant = 0

      UIView.animate(withDuration: payload.animationDuration, animations: {
        self.view.layoutIfNeeded()
      }) { (end) in
        self.chatView.layoutIfNeeded() // unuse
      }
    }
  }

  private func closeWhenTapBackground() {
    // finish keyboard on input
    let tapBackground = UITapGestureRecognizer()
    tapBackground.rx.event
      .subscribe(onNext: { [unowned self] _ in
        self.view.endEditing(true)
      })
      .disposed(by: disposeBag)

    chatView.addGestureRecognizer(tapBackground)
  }

  private func doUnlock() {
    reloadLock.unlock()
    if shouldReloadAgain {
      shouldReloadAgain = false
      // do reload job
    }

  }

  private func handleIncommingMsg() {

    if incommingMessages.count == 0 {
      doUnlock()
      return
    }

    let tempMsg = incommingMessages.first
    incommingMessages.removeFirst()

    guard
      let messageId = tempMsg?[MsgKeys.id.key] as? Int,
      let messageType = tempMsg?[MsgKeys.type.key] as? Int,
      let sender = tempMsg?[MsgKeys.userName.key] as? String,
      let message = tempMsg?[MsgKeys.message.key] as? String else {
        handleIncommingMsg()
        return
    }

    let displayMessage = "\(sender): \(message) (\(messageId))"

    // check who pass the message
    let type: ChatType = (sender == MyName) ? .self : .other
    if messageType == 0 {
      let item = ChatItem(text: displayMessage, image: nil, chatType: type)
      chatView.addChat(item: item)
      handleIncommingMsg()
    } else { print("Message with image type") }

  }

  /**
   //------->==70== ChatView.h
   }
   //每run一次處理一則訊息,直到沒有訊息,遞迴處理
   -(void ) handleIncomingMessages{

   // Photo message
   //Download image if necessary. ----> ==44== CommManager.m
   //==61== LogManager loadImage...
   UIImage *cachedImage = [logManager loadImageWithName:message];
   if (cachedImage != nil) {
   item.image = cachedImage;
   [_chatView addChatItem:item];
   [self handleIncomingMessages];

   return; /////Important
   // ------->==62==logManager.h
   }
   //...==45==  when cachedImage is nil , lets download it from server
   [comm downloadPhotoWithFilename:message completion:^(NSError *error, id result) {
   if (error == nil & result != nil) {
   UIImage *image = [UIImage imageWithData:result];
   item.image = image;
   //==60== Save Photo to LogManager
   [logManager saveImageWithName:message data:result];
   }
   [_chatView addChatItem:item];
   //--->Appdelegate.m ==46==
   [self handleIncomingMessages];
   }];
   }
   //----->==28== new file ChatItem .h
   }

   */


}

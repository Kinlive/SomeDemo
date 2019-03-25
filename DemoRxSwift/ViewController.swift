//
//  ViewController.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/1/31.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var testLoginBtn: UIButton!
  var testDriverText: UILabel!

  @IBOutlet weak var testTableBtn: UIButton!

  private let testRegisterBtn: UIButton! = {
    let btn = UIButton()
    btn.backgroundColor = .lightGray
    btn.titleLabel?.text  = "測試註冊"
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    btn.titleLabel?.textColor = .red
    return btn
  }()


  var testMoyaBtn: UIButton! = {
    let btn = UIButton()
    btn.setTitle("TestMoya", for: .normal)
    btn.backgroundColor = .lightGray
    btn.setTitleColor(.blue, for: .normal)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    return btn
  }()

  var testChatRoomBtn: UIButton! = {
    let btn = UIButton()
    btn.setTitle("Demo Chat room", for: .normal)
    btn.backgroundColor = .lightGray
    btn.setTitleColor(.red, for: .normal)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
    return btn
  }()

  var nextVC: LoginViewController!

  var tableVC: TestTableViewController = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestTableViewController") as! TestTableViewController
    return vc
  }()

  var musicVC: MusicListViewController = {
    let vc = MusicListViewController()
    return vc
  }()

  var chatRoomVC: ChatRoomViewController = {
    let vc = UIStoryboard(name: "ChatRoomStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
    return vc
  }()

  let disposeBag = DisposeBag()

  let testNumbers: Observable<Int> = Observable.create { (observa) -> Disposable in
    observa.onNext(0)
    observa.onNext(1)
    observa.onNext(2)
    observa.onNext(3)
    observa.onNext(4)
    observa.onNext(5)
    observa.onNext(6)
    observa.onNext(7)
    observa.onCompleted()
TestTableViewController.default
    return Disposables.create()
  }

  typealias JSON = Any

  /**
  let json: Observable<JSON> = Observable.create { (observer) -> Disposable in
    let url = URL(string: "www.google.com")!
    let task = URLSession.shared.dataTask(with: url) {
      data, response, err in
      guard err == nil else {
        observer.onError(err!)
        return
      }
      guard
        let data = data,
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
          observer.onError(<#Error#>)
          return
      }
      observer.onNext(jsonObject)
      // 當產生序列元素完成時 就on complete
      observer.onCompleted()
    }
    task.resume()

    // 當綁定被取消訂閱時要做的事情 交給disposables create() 內
    return Disposables.create { task.cancel() }
  }
 */


  // MARK: - try single
  func getRepo(_ repo: String) -> Single<[String: Any]> {
    // 從 XXXX.create起手式
    return Single.create { single -> Disposable in
      let url = URL(string: "www.google.com/\(repo)")!
      let task = URLSession.shared.dataTask(with: url) {
        data, response, err in

        if let error = err {
          single(.error(error))
          return
        }
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
              let result = json as? [String : Any]
          else {
            single(.error(err!))
            return
        }
        single(.success(result))

      }
      task.resume()
      return Disposables.create { task.cancel() }
    }
  }

  // MARK: - try completable
  func cacheLocally() -> Completable {
    return Completable.create(subscribe: { completable -> Disposable in
      // store some data locally
      // ...

//      guard success else {
//
//      }

      completable(.completed)
      return Disposables.create()
    })
  }


  // try driver
//  let results =

  let main = UIStoryboard(name: "Main", bundle: nil)

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

//    nextVC = LoginViewController.rx.init(<#T##base: LoginViewController##LoginViewController#>)


    testLoginBtn.rx.tap
      .subscribe(onNext: { [unowned self] in
      if let nextVC = self.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
        self.present(nextVC, animated: true, completion: nil)
      }})
      .disposed(by: disposeBag)

    testTableBtn.rx.tap
      .subscribe {
      self.present(self.tableVC, animated: true, completion: nil)
    }
      .disposed(by: disposeBag)

    setupRegisterBtn()

    testRegisterBtn.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        let nextVc = RegisterViewController()
        self.navigationController?.present(nextVc, animated: true, completion: nil)
    }).disposed(by: disposeBag)

    testMoyaBtn.rx.tap.subscribe(onNext: {[unowned self] _ in
      self.navigationController?.present(self.musicVC, animated: true, completion: nil)
    }).disposed(by: disposeBag)

    testChatRoomBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.navigationController?.present(self.chatRoomVC, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    /**
    // try observable
    json.subscribe(onNext: { jsonObject in
      print("Json object:\(jsonObject)")
    }, onError: { err in
      print("print err: \(err)")
    }, onCompleted: {
      print("取得Json 任務完成:")
    })
      .disposed(by: disposeBag)

    // try single
    getRepo("Pokemon GoGo")
      .subscribe(onSuccess: { json in
        print("Print Json: \(json)")
      }, onError: { err in
        print("Error:\(err)")
      })
      .dispose()

    // try completable
    cacheLocally().subscribe(onCompleted: {
      print("Completed here..")
    }, onError: { err in
      print("Print err: \(err.localizedDescription)")
    })
      .disposed(by: disposeBag)


    //try driver
    testDriverText.rx.text
  */

  }//


  func setupRegisterBtn() {

    view.addSubview(testRegisterBtn)
    testRegisterBtn.translatesAutoresizingMaskIntoConstraints = false

    let top = NSLayoutConstraint(item: testRegisterBtn, attribute: .top, relatedBy: .equal, toItem: testTableBtn, attribute: .bottom, multiplier: 1.0, constant: 20)
    let midX = NSLayoutConstraint(item: testRegisterBtn, attribute: .centerX, relatedBy: .equal, toItem: testTableBtn, attribute: .centerX, multiplier: 1.0, constant: 0)
    let width = NSLayoutConstraint(item: testRegisterBtn, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
    let height = NSLayoutConstraint(item: testRegisterBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40)
    NSLayoutConstraint.activate([top, midX, width, height])

    view.addSubview(testMoyaBtn)
    testMoyaBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: testMoyaBtn, attribute: .top, relatedBy: .equal, toItem: testRegisterBtn, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: testMoyaBtn, attribute: .leading, relatedBy: .equal, toItem: testRegisterBtn, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: testMoyaBtn, attribute: .trailing, relatedBy: .equal, toItem: testRegisterBtn, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: testMoyaBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).isActive = true

    view.addSubview(testChatRoomBtn)
    testChatRoomBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: testChatRoomBtn, attribute: .top, relatedBy: .equal, toItem: testMoyaBtn, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: testChatRoomBtn, attribute: .leading, relatedBy: .equal, toItem: testMoyaBtn, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: testChatRoomBtn, attribute: .trailing, relatedBy: .equal, toItem: testMoyaBtn, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: testChatRoomBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 35).isActive = true

  }



}







/// Oberservable 可被監聽的序列 (ex: 溫度變化的數值

/// Observer 觀察者 (ex: 溫度達到後響應開啟空調

/// subscribe 訂閱
///  ex: subject.subscribe{訂閱對象}.disposeBag
/// ex: onNext(產生Element)

// MARK: - Operator 操作符
/// filter 過濾
/// map 轉換
/// zip 配對 6*a, 8b -> 6*(a+b)
// ex:  Observable.zip(a,b).subscribe(onNext: { (a, b) in   print("將\(a)與\(b)結合") })

/// DisposeBag() ex: var disposeBag = DisposeBag() 定義一個全域的清除包 來搜集接下來任何訂閱時產生的對象
/// 當前頁面要消失時 可以在 viewWillDisapear內下 self.disposeBag = DisposeBag() 清除


// MARK: - 線程管理 Scheduler
/// subscribeOn: 需要獲取數據時的動作 藉由 .subscribeOn()切到背景執行,
/// observeOn: 有數據了需要對UI刷新時, 切回MainSchedule執行

/// Scheduler 種類:
/// MainScheduler 代表主线程。如果你需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler 运行。
/// SerialDispatchQueueScheduler 抽象了串行 DispatchQueue。如果你需要执行一些串行任务，可以切换到这个 Scheduler 运行。
/// ConcurrentDispatchQueueScheduler 抽象了并行 DispatchQueue。如果你需要执行一些并发任务，可以切换到这个 Scheduler 运行。
/// OperationQueueScheduler 抽象了 NSOperationQueue。
/// 它具备 NSOperationQueue 的一些特点，例如，你可以通过设置 maxConcurrentOperationCount，来控制同时执行并发任务的最大数量。

// MARK: - Error handling.
/// retry(3) : 重試3次後沒接收到 onCompleted就會發出error
/// retryWhen(5) : 在5秒後重試
/// catchError: 可以在错误产生时，用一个备用元素或者一组备用元素将错误替换掉
/// ex1: .catchErrorJustReturn([]), 當錯誤產生時 返回空陣列給當前的對象, 內容型別[]按照使用對象更換
/// ex2:
// 先从网络获取数据，如果获取失败了，就从本地缓存获取数据
/*
let rxData: Observable<Data> = ...      // 网络请求的数据
let cahcedData: Observable<Data> = ...  // 之前本地缓存的数据

  rxData
    .catchError { _ in cahcedData }
    .subscribe(onNext: { date in
      print("获取数据成功: \(date.count)")
    })
    .disposed(by: disposeBag)
*/
/// Result 當只想給使用者提示錯誤訊息時
// 自定义一个枚举类型 Result
//public enum Result<T> {
//  case success(T)
//  case failure(Swift.Error)
//}
/**
 updateUserInfoButton.rx.tap
 .withLatestFrom(rxUserInfo)
 .flatMapLatest { userInfo -> Observable<Result<Void>> in  // 替換成有Result
 return update(userInfo)
 .map(Result.success)  // 转换成 Result
 // 將錯誤包成 Result.failure(Error), 就不會中止整個序列運行, 再度點擊按鈕一樣可以再發出請求
 .catchError { error in Observable.just(Result.failure(error)) }
 }
 .observeOn(MainScheduler.instance)
 .subscribe(onNext: { result in
 switch result {           // 处理 Result
 case .success:
 print("用户信息更新成功")
 case .failure(let error):
 print("用户信息更新失败： \(error.localizedDescription)")
 }
 })
 .disposed(by: disposeBag)
 */


// MARK: - questions :
/// shared(reply: Int )用意
// 我们用 usernameValid 来控制用户名提示语是否隐藏以及密码输入框是否可用。shareReplay 就是让他们共享这一个源，而不是为他们单独创建新的源。这样可以减少不必要的开支。
/// disposed(by: disposeBag) 是用来做什么的？
//和我们所熟悉的对象一样，每一个绑定也是有生命周期的。并且这个绑定是可以被清除的。disposed(by: disposeBag)就是将绑定的生命周期交给 disposeBag 来管理。当 disposeBag 被释放的时候，那么里面尚未清除的绑定也就被清除了。这就相当于是在用 ARC 来管理绑定的生命周期。 这个内容会在 Disposable 章节详细介绍。

// ans: shareReplay 操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
/// userInfo -> Observable<Result<Void>> in



// [weak self, weak reactor] indexPath in
// guard let `self` = self else { return }

/**   Difference between unowned and weak
The difference between unowned and weak is that weak is declared as an Optional while unowned is not. By declaring it weak you get to handle the case that it might be nil inside the closure at some point. If you try to access an unowned variable that happens to be nil, it will crash the whole program. So only use unowned when you are positive that variable will always be around while the closure is around
 */

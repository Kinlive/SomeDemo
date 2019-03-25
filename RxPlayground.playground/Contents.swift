import UIKit
import RxSwift
import RxCocoa

var str = "Hello, playground"
let name = BehaviorRelay(value: ["Jack"]) // BehaviorRelay 在訂閱的同時發出上一次的event
name.asObservable()
  .subscribe(onNext: { value in
    print(value)
  })

name.accept(["Bob"])

//////////////////////

let disposeBag = DisposeBag()

let subject = PublishSubject<String>()

subject.onNext("JJJJ")

subject.subscribe(onNext: { value in
  print("第一次訂閱: \(value)")
}, onCompleted: {
  print("第一次訂閱完成...")
}).disposed(by: disposeBag)

subject.onNext("KKKKK")

subject.subscribe(onNext: { value in
  print("第二次訂閱: \(value)")
}, onCompleted: {
  print("第二次訂閱完成....")
}).disposed(by: disposeBag)

subject.onNext("CCCCCCC")
subject.onCompleted()
subject.onNext("ZZZZZZZ")


subject.subscribe(onNext: { value in
  print("第三次訂閱: \(value)")
}, onCompleted: {
  print("第三次訂閱完成.........")
}).disposed(by: disposeBag)


subject.onNext("9999999")


let subject2 = BehaviorSubject(value: "MustInitWithValue")


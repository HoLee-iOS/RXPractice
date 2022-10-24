//
//  ViewController.swift
//  RXPractice
//
//  Created by 이현호 on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exampleNever()
        exampleEmpty()
        exmpleJust()
        exmpleOf()
        exampleFrom()
        exampleRange()
        exmpleRepeatElement()
        exampleCreate()
        exampleGenerate()
        exampleDeffered()
        exampleDoOn()
    }
    
    //Never: 절대 실행되지 않음
    func exampleNever() {
        let neverSequence = Observable<String>.never()
        let neverSequenceSubscribe = neverSequence
            .subscribe { value in
                print(value)
            }
        neverSequenceSubscribe.disposed(by: disposeBag)
    }
    
    //Empty: observable이 비었을 경우 실행
    //아래는 지금 observable의 object에 아무것도 없으므로 조건을 충족하여 실행
    func exampleEmpty() {
        Observable<Int>.empty()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }

    //Just: observable의 object를 한번만 Emit함(하나의 object만 담기 가능)
    func exmpleJust() {
        Observable.just([1,2,3,4,5])
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }
    
    //Of: observable의 object들을 모두 Emit함(여러개의 object 담기 가능)
    func exmpleOf() {
        Observable.of("💩","👻","👾","🤖","🤡")
            .subscribe { element in
                print(element)
            }
            .disposed(by: disposeBag)
    }
    
    //from: 배열만 받을 수 있고 배열의 원소의 개수마다 emit함
    func exampleFrom() {
        Observable.from([1,2,3,4,5])
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
    
    //range: start부터 count 크기 만큼의 observable로 각각 방출된 요소에 대해서 값을 Double로 변환 후 출력함
    func exampleRange() {
        Observable.range(start: 1, count: 10)
            .subscribe { value in
                print(Double(value))
            }
            .disposed(by: disposeBag)
    }
    
    //repeatElement: .take(i) i번 만큼 observable로 방출된 요소를 출력함
    func exmpleRepeatElement() {
        Observable.repeatElement("🔴")
            .take(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //create: 커스텀한 observable 시퀀스를 생성해주며 하나의 element만 담을 수 있고 한번만 emit한 후에 출력함
    func exampleCreate() {
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
            
        myJust("🔴")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    //generate: initialState - 초기값 설정, condition - 조건 부여, iterate - 시퀀스마다 어떻게 반복할지
    func exampleGenerate() {
        Observable.generate(
                initialState: 0,
                condition: { $0 < 3 },
                iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //deffered: 각각의 시퀀스마다 다른 subscriber을 지정해줄 수 있는 커스텀한 observable 생성 후 emit
    func exampleDeffered() {
        var count = 1
        
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    func exampleError() {
//        Observable<Int>.error()
//            .subscribe { print($0) }
//            .disposed(by: disposeBag)
//    }
    
    //doOn:
    func exampleDoOn() {
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) }, afterNext: { print("Intercepted after:", $0) }, onError: { print("Intercepted error:", $0) }, afterError: { print("Intercepted after error:", $0) }, onCompleted: { print("Completed")  }, afterCompleted: { print("After completed")  })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}


//: Please build the scheme 'RxSwiftPlayground' first

/*:
 Copyright (c) 2014-2016 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

example(of: "PublishSubject") {
    
    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")
    
    let subscriptionOne = subject
        .subscribe(onNext: { string in
            print("1)", string)
        })

    subject.onNext("1")  // Equiv. subject.on(.next("1"))

    let subscriptionTwo = subject
        .subscribe { event in
            print("2)", event.element ?? event)
    }
    
    subject.onNext("2")
    
    subscriptionOne.dispose()
    
    subject.onNext("3")
    
    subject.onCompleted()

    subject.onNext("4")

    subscriptionTwo.dispose()
    
    let disposeBag = DisposeBag()
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
        }
        .addDisposableTo(disposeBag)
 
    subject.onNext("?")
}


enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject(value: "Initial value")
    let disposeBag = DisposeBag()

    subject.onNext("X")

    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .addDisposableTo(disposeBag)
    
    subject.onError(MyError.anError)
    
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .addDisposableTo(disposeBag)
}


example(of: "ReplaySubject") {

    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()

    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .addDisposableTo(disposeBag)

    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .addDisposableTo(disposeBag)
    
    subject.onNext("4")
    subject.onError(MyError.anError)
    subject.dispose()
    
    subject
        .subscribe {
            print(label: "3)", event: $0)
        }
        .addDisposableTo(disposeBag)
}

example(of: "Variable") {
    
    var variable = Variable("Initial value")
    let disposeBag = DisposeBag()
    
    variable.value = "New initial value"

    variable.asObservable()
        .subscribe {
            print(label: "1)", event: $0)
        }
        .addDisposableTo(disposeBag)
    
    variable.value = "1"
    
    variable.asObservable()
        .subscribe {
            print(label: "2)", event: $0)
        }
        .addDisposableTo(disposeBag)

    variable.value = "2"
}
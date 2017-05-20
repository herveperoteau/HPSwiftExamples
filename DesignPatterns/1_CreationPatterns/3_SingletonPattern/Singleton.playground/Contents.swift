//: Playground - noun: a place where people can play

import UIKit

//https://krakendev.io/blog/the-right-way-to-write-a-singleton
final class TheOneAndOnlyKraken {
  static let sharedInstance = TheOneAndOnlyKraken()
  private init() {} //This prevents others from using the default '()' initializer for this class.
  func work() {
    print("work")
  }
}

TheOneAndOnlyKraken.sharedInstance.work()

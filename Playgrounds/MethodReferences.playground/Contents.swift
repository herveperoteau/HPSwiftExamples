//: Playground - Method Reference

import Foundation

class Printer {
  func printMessage(_ message: String) {
    print(message)
  }
}

let printerObject = Printer()
printerObject.printMessage("Hello")
// equiv to
Printer.printMessage(printerObject)("Hello")
// USED IN COMMAND PATTERN !!!


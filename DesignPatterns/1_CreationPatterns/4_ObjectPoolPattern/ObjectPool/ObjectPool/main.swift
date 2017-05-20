import Foundation

var queue = DispatchQueue(label: "workQ", attributes: DispatchQueue.Attributes.concurrent)
var group = DispatchGroup()

print("Starting...")

for i in 1 ... 20 {
  queue.async(group: group) {
    if let book = Library.checkoutBook(reader: "reader#\(i)") {
      Thread.sleep(forTimeInterval: Double(arc4random() % 2))
      Library.returnBook(book: book)
    }
  }
}

_ = group.wait(timeout: DispatchTime.distantFuture)

print("All blocks complete")

Library.printReport()

import Foundation

var queue = DispatchQueue(label: "workQ", attributes: DispatchQueue.Attributes.concurrent)
var group = DispatchGroup()

print("Starting...")

for i in 1 ... 35 {
  queue.async(group: group) {
    if let book = Library.checkoutBook(reader: "reader#\(i)") {
      Thread.sleep(forTimeInterval: Double(arc4random() % 2))
      Library.returnBook(book: book)
    }
    else {
      queue.async(flags: .barrier) {
        print("Request \(i) failed")
      }
    }
  }
}

_ = group.wait(timeout: DispatchTime.distantFuture)

queue.sync(flags: .barrier) {
  print("All blocks complete")
  Library.printReport()
}

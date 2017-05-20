import Foundation

final class Library {
  
  private static let singleton = Library(stockLevel: 5)
  
  private let pool:Pool<Book>
  
  private init(stockLevel:Int) {
    var stockId = 0
    pool = Pool<Book> (
      itemCount:stockLevel,
      itemFactory: {
        stockId += 1
        return BookSeller.buyBook(author: "Dickens, Charles",
                                  title: "Hard Times",
                                  stockNumber: stockId)},
      itemAllocator: {(books) in
        var selected = 0
        for index in 1 ..< books.count {
          if (books[index].checkoutCount < books[selected].checkoutCount) {
            selected = index
          }
        }
        return selected
    }
    )
  }
  
  class func checkoutBook(reader:String) -> Book? {
    guard let book = singleton.pool.getFromPool() else { return nil }
    book.reader = reader
    book.checkoutCount += 1
    return book
  }
  
  class func returnBook(book:Book) {
    book.reader = nil
    singleton.pool.returnToPool(item: book)
  }
  
  class func printReport() {
    singleton.pool.processPoolItems() { (books) in
      for book in books {
        print("...Book#\(book.stockNumber)...")
        print("Checked out \(book.checkoutCount) times")
        if let reader = book.reader  {
          print("Checked out to \(reader)")
        }
        else {
          print("In stock")
        }
      }
      print("There are \(books.count) books in the pool")
    }
  }
}

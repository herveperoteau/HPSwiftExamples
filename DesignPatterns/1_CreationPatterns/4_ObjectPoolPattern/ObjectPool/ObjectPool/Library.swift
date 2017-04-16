import Foundation

final class Library {
  
  fileprivate static let singleton = Library(stockLevel:2)

  fileprivate let books:[Book]
  fileprivate let pool:Pool<Book>
  
  fileprivate init(stockLevel:Int) {
    var booksArray = [Book]() 
    for count in 1 ... stockLevel {
      booksArray.append(Book(author: "Dickens, Charles",
                             title: "Hard Times",
                             stock: count))
    }
    
    books = booksArray
    pool = Pool<Book>(items:books) 
  }
  
  class func checkoutBook(reader:String) -> Book? {
    guard let book = singleton.pool.getFromPool() else { return nil }
    book.reader = reader
    book.checkoutCount += 1
    return book 
  }
  
  class func returnBook(book:Book) {
    book.reader = nil 
    singleton.pool.returnToPool(book) 
  }
  
  class func printReport() {
    for book in singleton.books {
      print("...Book#\(book.stockNumber)...") 
      print("Checked out \(book.checkoutCount) times") 
      if (book.reader != nil) {
        print("Checked out to \(book.reader!)") 
      } else {
        print("In stock") 
      }
    }
  }
}

import Foundation

protocol Flyweight {
  subscript(index:Coordinate) -> Int? { get set }
  var total:Int { get }
  var count:Int { get }
}

extension Dictionary {
  init(setupFunc:(() -> [(Key, Value)])) {
    self.init()
    for item in setupFunc() {
      self[item.0] = item.1
    }
  }
}

class FlyweightFactory {
  
  class func createFlyweight() -> Flyweight {
    return FlyweightImplementation(extrinsic: extrinsicData)
  }
  
  fileprivate class var extrinsicData:[Coordinate: Cell] {
    get {
      struct singletonWrapper {
        static let singletonData = Dictionary<Coordinate, Cell>() {
          var results = [(Coordinate, Cell)]()
          let letters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          var stringIndex = letters.startIndex
          let rows = 50
          repeat {
            let colLetter = letters[stringIndex]
            stringIndex = letters.index(after: stringIndex)
            for rowIndex in 1 ... rows {
              let cell = Cell(col: colLetter, row: rowIndex,
                              val: rowIndex)
              results.append((cell.coordinate, cell))
            }
          } while (stringIndex != letters.endIndex)
          return results
        }
      }
      return singletonWrapper.singletonData
    }
  }
}

class FlyweightImplementation : Flyweight  {
  fileprivate let extrinsicData:[Coordinate: Cell]
  fileprivate var intrinsicData:[Coordinate: Cell]
  fileprivate let queue:DispatchQueue
  
  fileprivate init(extrinsic:[Coordinate: Cell]) {
    self.extrinsicData = extrinsic
    self.intrinsicData = Dictionary<Coordinate, Cell>()
    self.queue = DispatchQueue(label: "dataQ", attributes: DispatchQueue.Attributes.concurrent)
  }
  
  subscript(key:Coordinate) -> Int? {
    get {
      var result:Int?
      self.queue.sync() {
        if let cell = self.intrinsicData[key] {
          result = cell.value
        }
        else {
          result = self.extrinsicData[key]?.value
        }
      }
      
      return result
    }
    set (value) {
      if (value != nil) {
        self.queue.sync(flags: .barrier) {
          self.intrinsicData[key] = Cell(col: key.col,
                                         row: key.row,
                                         val: value!)
        }
      }
    }
  }
  
  var total:Int {
    var result = 0
    self.queue.sync() {
      result = self.extrinsicData.values.reduce(0) { total, cell in
        if let intrinsicCell = self.intrinsicData[cell.coordinate] {
          return total + intrinsicCell.value
        }
        else {
          return total + cell.value
        }
      }
    }
    
    return result
  }
  
  var count:Int {
    var result = 0
    self.queue.sync() {
      result = self.intrinsicData.count
    }
    return result
  }
}


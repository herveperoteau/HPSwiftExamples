import Foundation

class Pool<T:AnyObject> {
  
  fileprivate var data = [T]()
  fileprivate let arrayQ = DispatchQueue(label: "arrayQ", attributes: [])
  fileprivate let semaphore:DispatchSemaphore
  
  fileprivate let itemFactory: () -> T
  fileprivate let itemAllocator:([T]) -> Int
  fileprivate let maxItemCount:Int
  fileprivate var createdCount:Int = 0
  
  init(itemCount:Int, itemFactory:@escaping () -> T, itemAllocator:@escaping (([T]) -> Int)) {
    self.maxItemCount = itemCount
    self.itemFactory = itemFactory
    self.itemAllocator = itemAllocator
    self.semaphore = DispatchSemaphore(value: itemCount)
  }
  
  func getFromPool(maxWaitSeconds: Double = 5) -> T? {
    var result:T?    
    let waitTime = (maxWaitSeconds == -1 ? DispatchTime.distantFuture : DispatchTime.now() + maxWaitSeconds)
    if (semaphore.wait(timeout: waitTime) == DispatchTimeoutResult.success) {
      arrayQ.sync() {
        // not available in pool, and maxItem is not achieved, so we create a new object
        if (self.data.count == 0 && self.createdCount < self.maxItemCount) {
          print("getFromPool create ...")
          result = self.itemFactory()
          self.createdCount += 1
        }
          // get an available object from the pool
        else if self.data.count > 0 {
          result = self.data.remove(at: self.itemAllocator(self.data))
          print("getFromPool reuse:\(result!) ...")
        }
        else {
          print("getFromPool pool is empty :-( ...")
        }
      }
    }
    return result
  }
  
  func returnToPool(item:T) {
    arrayQ.sync() {
      let pItem = item as? PoolItem
      // check pItem == nil because Pool can work with object not conform with PoolItem
      if pItem == nil || pItem!.canReuse {
        print("returnToPool \(item)")
        self.data.append(item)
      }
      else {
        print("NOT returnToPool \(item)")
      }
      
      self.semaphore.signal()
    }
  }
  
  func processPoolItems(_ callback:([T]) -> Void) {
    print(">>>>> processPoolItems ...")
    arrayQ.sync(flags: .barrier) {
      callback(self.data)
    }
  }
}

//
//  Product.swift
//  ObjectTemplate
//
//  Created by Hervé PEROTEAU on 16/04/2017.
//  Copyright © 2017 Hervé PEROTEAU. All rights reserved.
//

import Foundation

class Product {
  
  let name:String
  let price:Double
  
  private var stockBackingValue:Int = 0  
  var stock:Int {
    get {
      return stockBackingValue
    }
    set {
      stockBackingValue = max(0, newValue)
    }
  }
  
  init(name:String, price:Double, stock:Int) {
    self.name = name
    self.price = price
    self.stock = stock
  }
  
  func calculateTax(rate: Double) -> Double {
    return min(10, self.price * rate)
  }
  
  var stockValue: Double {
    get {
      return self.price * Double(self.stock)
    }
  }
}

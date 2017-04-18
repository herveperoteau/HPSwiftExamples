class PriceCalculator {
  class func calculatePrice(_ passengers:Int, days:Int) -> Float? {
    let car = RentalCar.createRentalCar(passengers: passengers)
    return car == nil ? nil : car!.pricePerDay * Float(days)
  }
}

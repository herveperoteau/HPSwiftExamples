import Foundation

let facade = PirateFacade()
let prize = facade.getTreasure(TreasureTypes.ship)
if (prize != nil) {
  facade.crew.performAction(PirateCrew.Actions.dive_FOR_JEWELS) { secondPrize in
    print("Prize: \(prize! + secondPrize) pieces of eight")
  }
}

_ = FileHandle.standardInput.availableData

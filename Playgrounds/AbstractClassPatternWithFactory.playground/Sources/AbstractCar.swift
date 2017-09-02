import Foundation

class AbstractCar: VehiculeAnimatable {
    
    var name: String!
    var model3D: String!
    
    func setup(name:String, model3D: String) {
        self.name = name
        self.model3D = model3D
    }
    
    func animate() {
        guard let _ = name, let _ = model3D else {
            fatalError("call setup before !!!")
        }
        
        willMove()
        execMove()
        didMoved()
    }
    
    func willMove() {
        // override if needed
    }

    func didMoved() {
        // override if needed
    }
    
    func execMove() {
        // override if needed
        print("common code for execMove \(name)")
    }
}

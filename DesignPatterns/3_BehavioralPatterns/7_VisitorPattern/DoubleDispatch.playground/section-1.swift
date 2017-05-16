
protocol MyProtocol {
    func dispatch(_ handler:Handler);
}

class FirstClass : MyProtocol {
    func dispatch(_ handler: Handler) {
      handler.handle(self);
    }
}

class SecondClass : MyProtocol {
    func dispatch(_ handler: Handler) {
        handler.handle(self)
    }
}

class Handler {
    
    func handle(_ arg:MyProtocol) {
        print("Protocol");
    }
    
    func handle(_ arg:FirstClass) {
        print("First Class");
    }
    
    func handle(_ arg:SecondClass) {
        print("Second Class");
    }
}

let objects:[MyProtocol] = [FirstClass(), SecondClass()];
let handler = Handler();

for object in objects {
    object.dispatch(handler);
}

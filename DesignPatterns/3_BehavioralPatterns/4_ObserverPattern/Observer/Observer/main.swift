// create meta observer
let monitor = AttackMonitor()
MetaSubject.sharedInstance.addObservers(monitor)

// create regular observers
let log = ActivityLog()
let cache = FileCache()

let authM = AuthenticationManager()
// register only the regular observers
authM.addObservers(cache, monitor)

_ = authM.authenticate("bob", pass: "secret")
print("-----")
_ = authM.authenticate("joe", pass: "shhh")

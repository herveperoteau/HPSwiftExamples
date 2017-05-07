import Foundation

let url = "http://www.apress.com"
let headers = ["Content-Type", "Content-Encoding"]

let proxy = AccessControlProxy(url: url)

for header in headers {
  proxy.getHeader(header) { header, val in
    if let val = val {
      print("\(header): \(val)")
    }
    else {
      print("\(header): NO VALUE")
    }
  }
}

UserAuthentication.sharedInstance.authenticate("bob", pass: "secret")
proxy.execute()

_ = FileHandle.standardInput.availableData

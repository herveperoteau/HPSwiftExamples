import Foundation

class Transmitter {
  var nextLink:Transmitter?
  
  required init() {}
  
  func sendMessage(_ message:Message) -> Bool {
    if let nextLink = nextLink {
      return nextLink.sendMessage(message)
    }
    
    print("End of chain reached. Message not sent")
    return false
  }
  
  // Factory Pattern to create the good chain (depends of localOnly parameter)
  class func createChain(localOnly:Bool) -> Transmitter? {
    
    let transmitterClasses:[Transmitter.Type]
      = localOnly ? [PriorityTransmitter.self, LocalTransmitter.self]
        : [PriorityTransmitter.self, LocalTransmitter.self, RemoteTransmitter.self]
    
    var link:Transmitter?
    
    // create the links in the chain
    for tClass in transmitterClasses.reversed() {
      let existingLink = link
      link = tClass.init()
      link?.nextLink = existingLink
    }
    
    return link
  }
  
  fileprivate class func matchEmailSuffix(_ message:Message) -> Bool {
    
    if let index = message.from.characters.index(of: "@") {
      let suffix = message.from.substring(from: index)
      return message.to.hasSuffix(suffix)
    }
    
    return false
  }
}

class LocalTransmitter : Transmitter {
  
  override func sendMessage(_ message: Message) -> Bool {
    if (Transmitter.matchEmailSuffix(message)) {
      print("Message to \(message.to) sent locally")
      return true
    }
    return super.sendMessage(message)
  }
}

class RemoteTransmitter : Transmitter {
  
  override func sendMessage(_ message: Message) -> Bool {
    if (!Transmitter.matchEmailSuffix(message)) {
      print("Message to \(message.to) sent remotely")
      return true
    }
    return super.sendMessage(message)
  }
}

class PriorityTransmitter : Transmitter {
  
  override func sendMessage(_ message: Message) -> Bool {
    if (message.subject.hasPrefix("Priority")) {
      print("Message to \(message.to) sent as priority")
      return true
    }
    return super.sendMessage(message)
  }
}



class Communicator {
    fileprivate let channnel:Channel
    
    init (channel:Channel.Channels) {
        self.channnel = Channel.getChannel(channel)
    }
    
    fileprivate func sendMessage(_ msg:Message) {
        msg.prepareMessage()
        channnel.sendMessage(msg)
    }
    
    func sendCleartextMessage(_ message:String) {
        self.sendMessage(ClearMessage(message: message))
    }
    
    func sendSecureMessage(_ message:String) {
        self.sendMessage(EncryptedMessage(message: message))
    }
    
    func sendPriorityMessage(_ message:String) {
        self.sendMessage(PriorityMessage(message: message))
    }
}

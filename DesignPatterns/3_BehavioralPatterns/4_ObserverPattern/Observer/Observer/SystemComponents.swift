class ActivityLog : Observer {
  
  func notify(_ notification:Notification) {
    print("Auth request for \(notification.type.rawValue) "
      + "Success: \(notification.data!)")
  }
  
  func logActivity(_ activity:String) {
    print("Log: \(activity)")
  }
}

class FileCache : Observer {
  func notify(_ notification:Notification) {
    if let authNotification = notification as? AuthenticationNotification {
      if (authNotification.requestSuccessed
        && authNotification.userName != nil) {
        loadFiles(authNotification.userName!)
      }
    }
  }
  
  func loadFiles(_ user:String) {
    print("Load files for \(user)")
  }
}

class AttackMonitor : MetaObserver {
  
  func notifySubjectCreated(_ subject: Subject) {
    if (subject is AuthenticationManager) {
      subject.addObservers(self)
    }
  }
  
  func notifySubjectDestroyed(_ subject: Subject) {
    subject.removeObserver(self)
  }
  
  func notify(_ notification: Notification) {
    monitorSuspiciousActivity
      = (notification.type == NotificationTypes.AUTH_FAIL)
  }
  
  var monitorSuspiciousActivity: Bool = false {
    didSet {
      print("Monitoring for attack: \(monitorSuspiciousActivity)")
    }
  }
}


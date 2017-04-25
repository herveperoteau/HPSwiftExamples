class NewCoDirectoryAdapter : EmployeeDataSource {
  fileprivate let directory:NewCoDirectory
  
  init() {
    directory = NewCoDirectory()
  }
  
  var employees:[Employee] {
    // Adatpter : transform NewCoStaffMember to Employee
    return directory.getStaff().values.map {
      staffMember -> Employee in
      return Employee(name: staffMember.getName(), title: staffMember.getJob())
    }
  }
  
  func searchByName(_ name:String) -> [Employee] {
    return createEmployees(filter: {(sv:NewCoStaffMember) -> Bool in
      return sv.getName().range(of: name) != nil
    })
  }
  
  func searchByTitle(_ title:String) -> [Employee] {
    return createEmployees(filter: {(sv:NewCoStaffMember) -> Bool in
      return sv.getJob().range(of: title) != nil
    })
  }
  
  fileprivate func createEmployees(filter filterClosure:((NewCoStaffMember) -> Bool))
    -> [Employee] {
      // Adatpter : transform NewCoStaffMember to Employee
      return directory.getStaff().values.filter(filterClosure).map {
        staffMember -> Employee in
        return Employee(name: staffMember.getName(), title: staffMember.getJob())
      }
  }
}

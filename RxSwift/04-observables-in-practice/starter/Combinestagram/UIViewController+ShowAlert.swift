//
//  UIViewController+ShowAlert.swift
//  Combinestagram
//
//  Created by Hervé PEROTEAU on 26/05/2017.
//  Copyright © 2017 Underplot ltd. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - Rx Show Alert
extension UIViewController {
  
  func alert(title: String, text: String?) -> Observable<Void> {
    return Observable.create { [weak self] observer in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
        observer.onCompleted()
      }))
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
}

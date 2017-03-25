//
//  QuizViewController.swift
//  UITableViewRxQuiz
//
//  Created by Hervé PEROTEAU on 25/03/2017.
//  Copyright © 2017 Hervé PEROTEAU. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QuizViewController: UIViewController, UITableViewDelegate {

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var nextQuestionButton: UIBarButtonItem!
  @IBOutlet weak var choiceTableView: UITableView!
  @IBOutlet weak var submitButton: UIButton!
  
  private let currentQuestionIndex = Variable(0)
  private let currentQuestion: Variable<QuestionModel?> = Variable(nil)
  private let selectedIndexPaths: Variable<[NSIndexPath]> = Variable([])
  private let displayAnswers: Variable = Variable(false)
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Sets self as tableview delegate
    choiceTableView
      .rx
      .setDelegate(self)
      .addDisposableTo(disposeBag)
  }
  
  
  
}

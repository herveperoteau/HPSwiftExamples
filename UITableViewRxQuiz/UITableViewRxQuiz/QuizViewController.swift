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

class QuizViewController: UIViewController {

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var nextQuestionButton: UIBarButtonItem!
  @IBOutlet weak var choiceTableView: UITableView!
  @IBOutlet weak var submitButton: UIButton!
  
  private let currentQuestionIndex = Variable(0)
  private let currentQuestion: Variable<QuestionModel?> = Variable(nil)
  private let selectedIndexPaths: Variable<[IndexPath]> = Variable([])
  fileprivate let displayAnswers: Variable = Variable(false)
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Initialization Observer

  func setup() {
    // Sets self as tableview delegate
    choiceTableView
      .rx
      .setDelegate(self)
      .addDisposableTo(disposeBag)

    setupCurrentQuestionIndexObserver()
    setupCurrentQuestionObserver()
    setupNextQuestionButtonObserver()
    setupChoiceTableViewObserver()
    setupSubmitButtonObserver()
    setupDisplayAnswersObserver()
  }
  
//  Here we are tracking the currentQuestionIndex value, then we map (transform) the value to be sure the index will be inside the question array, and we update the currentQuestion variable with the corresponding question. Notes that I explained before we need to dispose the subscription at the end.
  private func setupCurrentQuestionIndexObserver() {
    currentQuestionIndex
      .asObservable()
      .map { $0 % Quiz.questions.count }
      .subscribe(onNext: { index in
        self.currentQuestion.value = Quiz.questions[index]
      })
      .addDisposableTo(disposeBag)
  }
  
  // MARK: - Generate TableView Cells
  
//  In a first place we are updating the title text each time the currentQuestion change. Then, if there is a question, we bind the question choices to the tableview. So each times the currentQuestion is updated the choiceTableView is reloaded to display the corresponding choice.
  private func setupCurrentQuestionObserver() {
    currentQuestion
      .asObservable()
      .subscribe(onNext: { question in
        // Put question in NavBar
        self.navigationBar.topItem?.title = question?.title
      })
      .addDisposableTo(disposeBag)

    // Prepare all choices of the current question
    currentQuestion
      .asObservable()
      .filter { $0 != nil }  // verify that currentQuestion is not nil
      .map { $0!.choices }   // for each choices... than produce a cell of type ChoiceCell
      .bindTo(choiceTableView.rx.items(cellIdentifier: "ChoiceCell", cellType: ChoiceCell.self))
      { (row, element, cell) in
        cell.choiceModel = element
        cell.displayAnswers = self.displayAnswers.value
      }
      .addDisposableTo(disposeBag)
  }
  
  // MARK: - Handle Next Button
  
  //Here each time the button is tapped we ensure to hide the answers and we update the currentQuestionIndex.
  private func setupNextQuestionButtonObserver() {
    nextQuestionButton
      .rx
      .tap
      .subscribe(onNext: {
        self.displayAnswers.value = false
        self.currentQuestionIndex.value += 1
      })
      .addDisposableTo(disposeBag)
  }
  
  // MARK: - Tracking selection in TableView

  //We need to track the selected items to enable/disable the submit button:

  private func setupChoiceTableViewObserver() {
    choiceTableView
      .rx
      .itemSelected
      .subscribe(onNext: { indexPath in
        self.selectedIndexPaths.value.append(indexPath)  // Save selection in selectedIndexPath
        self.choiceTableView.cellForRow(at: indexPath)?.isSelected = true // Update Display of Cell
      })
      .addDisposableTo(disposeBag)
    
    choiceTableView
      .rx
      .itemDeselected
      .subscribe(onNext: { indexPath in
        // Remove selection from selectedIndexPath
        self.selectedIndexPaths.value = self.selectedIndexPaths.value.filter { $0 != indexPath }
        self.choiceTableView.cellForRow(at: indexPath)?.isSelected = false // Update Display of Cell
      })
      .addDisposableTo(disposeBag)
  }
  
  // MARK: - Manage Submit button state
  
  private func setupSubmitButtonObserver() {

    // We are enabling the submit button when at least one item is selected and answer is not displayed:
    Observable
      .combineLatest(selectedIndexPaths.asObservable(), displayAnswers.asObservable()) { (s, d) in
        return s.count > 0 && !d
      }
      .bindTo(submitButton.rx.isEnabled)
      .addDisposableTo(disposeBag)
    
    // Handle tap on Submit Button
    submitButton
      .rx
      .tap
      .subscribe(onNext: {
        // Display the answers when user tap on Submit
        self.displayAnswers.value = true
      })
      .addDisposableTo(disposeBag)
  }
  
  //When the submit button is tapped we are displaying answers:
  private func setupDisplayAnswersObserver() {
    displayAnswers
      .asObservable()
      .subscribe(onNext: { displayAnswers in
        for cell in self.choiceTableView.visibleCells as! [ChoiceCell] {
          cell.displayAnswers = displayAnswers  // Update Visibles Cells with answer
        }
      })
      .addDisposableTo(disposeBag)
  }
}

extension QuizViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    // If anwsers are displayed, we can't select cell
    return displayAnswers.value ? nil : indexPath
  }
  
  func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    // If anwsers are displayed, we can't deselect cell
    return displayAnswers.value ? nil : indexPath
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // None selection style, because cell used checkMark
    cell.selectionStyle = .none
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    // no delete cell
    return .none
  }
  
}



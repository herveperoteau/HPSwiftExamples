//
//  Quiz.swift
//  UITableViewRxQuiz
//
//  Created by Hervé PEROTEAU on 25/03/2017.
//  Copyright © 2017 Hervé PEROTEAU. All rights reserved.
//

import Foundation

class Quiz {
  static var questions: [QuestionModel] = {
    // Question 1
    let c1 = ChoiceModel(title: "A powerful library", valid: true)
    let c2 = ChoiceModel(title: "A brush", valid: false)
    let c3 = ChoiceModel(title: "A swift implementation of ReactiveX", valid: true)
    let c4 = ChoiceModel(title: "The Observer pattern on steroids", valid: true)
    let q1 = QuestionModel(title: "What is RxSwift?",
                           choices: [c1, c2, c3, c4])
    
    // Question 2
    let c5 = ChoiceModel(title: "Asynchronous events", valid: true)
    let c6 = ChoiceModel(title: "Email validation", valid: true)
    let c7 = ChoiceModel(title: "Networking", valid: true)
    let c8 = ChoiceModel(title: "Interactive UI", valid: true)
    let c9 = ChoiceModel(title: "And many more...", valid: true)

    let c10 = ChoiceModel(title: "sbdnsqbdnsq ...", valid: false)
    let c11 = ChoiceModel(title: "sbdnsqbdnsq fdsf ...", valid: false)
    let c12 = ChoiceModel(title: "sbdnsqbdnsq rezez ...", valid: false)
    let c13 = ChoiceModel(title: "sbdnsqbdnsq cxwcw ...", valid: false)
    let c14 = ChoiceModel(title: "sbdnsqbdnsq pofpfkl ...", valid: false)
    let c15 = ChoiceModel(title: "sbdnsqbdnsq azdcd ...", valid: false)
    let c16 = ChoiceModel(title: "sbdnsqbdnsq bxwc,wxc ...", valid: false)
    
    let q2 = QuestionModel(title: "In which cases RxSwift is useful?",
                           choices: [c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16])
    
    return [q1, q2]
  }()
}

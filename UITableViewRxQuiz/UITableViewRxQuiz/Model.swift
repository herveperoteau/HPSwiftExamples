//
//  Model.swift
//  UITableViewRxQuiz
//
//  Created by Hervé PEROTEAU on 25/03/2017.
//  Copyright © 2017 Hervé PEROTEAU. All rights reserved.
//

import Foundation

struct ChoiceModel {
  let title: String
  let valid: Bool
}

struct QuestionModel {
  let title: String
  let choices: [ChoiceModel]
}

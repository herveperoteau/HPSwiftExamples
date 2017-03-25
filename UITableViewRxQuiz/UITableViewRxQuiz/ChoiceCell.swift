//
//  ChoiceCell.swift
//  UITableViewRxQuiz
//
//  Created by Hervé PEROTEAU on 25/03/2017.
//  Copyright © 2017 Hervé PEROTEAU. All rights reserved.
//

import UIKit

final class ChoiceCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var checkboxImageView: UIImageView!
  @IBOutlet weak var checkmarkImageView: UIImageView!
  
  private let redColor   = UIColor(red: 231 / 255, green: 76 / 255, blue: 60 / 255, alpha: 1)
  private let greenColor = UIColor(red: 46 / 255, green: 204 / 255, blue: 113 / 255, alpha: 1)
  
  var choiceModel: ChoiceModel? {
    didSet {
      layoutCell()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      checkmarkImageView.isHidden = !isSelected
      layoutCell()
    }
  }
  
  var displayAnswers: Bool = false {
    didSet {
      layoutCell()
    }
  }
  
  private func layoutCell() {
    titleLabel.text = choiceModel?.title
    if let choice = choiceModel, displayAnswers {
      checkmarkImageView.tintColor = (isSelected == choice.valid ? greenColor : redColor)
      checkboxImageView.tintColor = (isSelected == choice.valid ? greenColor : redColor)
    }
    else {
      checkboxImageView.tintColor  = .black
      checkmarkImageView.tintColor = .black
    }
  }
}

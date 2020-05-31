//
//  QuizTableCell.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit

class QuizTableCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.brown
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.numberOfLines = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
        //        reviewImageView?.image = nil
    }
    
    func setup(withQuiz quiz: Quiz) {
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        
        if (quiz.image.absoluteString == "") {
            quizImageView.isHidden = true
        } else {
            quizImageView.load(url: quiz.image)
            quizImageView.backgroundColor = categoryToColor(category: quiz.category)
        }
    }
}

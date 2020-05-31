//
//  QuizTableHeader.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

class QuizTableHeader: UIView {

    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        titleLabel = UILabel()
        titleLabel.text = "Quizzes"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.darkGray
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

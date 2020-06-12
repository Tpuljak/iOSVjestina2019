//
//  QuizTableHeader.swift
//  QuizApp
//
//  Created by Toma Puljak on 31/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit
import PureLayout

class QuizTableHeader: UIView {

    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.lightGray
        titleLabel = UILabel()
        titleLabel.text = "Quizzes"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.darkGray
        self.addSubview(titleLabel)
        
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        titleLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
    }
    
    func setTitleAndColor(category: Category) {
        DispatchQueue.main.async {
            self.titleLabel.text = category.rawValue
            self.backgroundColor = categoryToColor(category: category)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

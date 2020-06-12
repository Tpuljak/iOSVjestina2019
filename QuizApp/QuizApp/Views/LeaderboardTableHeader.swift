//
//  LeaderboardTableHeader.swift
//  QuizApp
//
//  Created by Toma Puljak on 10/06/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

class LeaderboardTableHeader : UIView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.lightGray
        titleLabel = UILabel()
        titleLabel.text = "Leaderboard"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.darkGray
        self.addSubview(titleLabel)
        
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        titleLabel.autoAlignAxis(.vertical, toSameAxisOf: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

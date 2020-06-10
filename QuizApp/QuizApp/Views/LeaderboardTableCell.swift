//
//  LeaderboardTableCell.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/06/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit
import PureLayout

class LeaderboardTableCell : UITableViewCell {
    
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var scoreTextLabel: UILabel!
    @IBOutlet weak var usernameOutputLabel: UILabel!
    @IBOutlet weak var scoreOutputLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupConstraints()
    }
    
    func setupConstraints() {
        usernameTextLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
        usernameTextLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 20)
        
        scoreTextLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
        scoreTextLabel.autoPinEdge(.top, to: .bottom, of: usernameTextLabel, withOffset: 20)
        
        usernameOutputLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: 20)
        usernameOutputLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 20)
        
        scoreOutputLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: 20)
        scoreOutputLabel.autoPinEdge(.top, to: .bottom, of: usernameOutputLabel, withOffset: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scoreOutputLabel.text = ""
        usernameOutputLabel.text = ""
    }
    
    func setup(withLeaderboardScore score: LeaderboardScore) {
        usernameOutputLabel.text = score.username
        scoreOutputLabel.text = String(score.score ?? 0)
    }
}

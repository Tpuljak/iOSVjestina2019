//
//  LeaderboardTableViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/06/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardTableViewController : UIViewController {
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var dataFailed: UILabel!
    
    var refreshControl: UIRefreshControl!
    var leaderboard: [LeaderboardScore]?
    var quizId: Int?
    
    let cellReuseIdentifier = "leaderboardCellReuseIdentifier"
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeaderboardTableView()
        getData()
    }
    
    func setupLeaderboardTableView() {
        leaderboardTableView.backgroundColor = UIColor.lightGray
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        leaderboardTableView.separatorStyle = .singleLine
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LeaderboardTableViewController.refresh), for: UIControl.Event.valueChanged)
        leaderboardTableView.refreshControl = refreshControl

        leaderboardTableView.register(UINib(nibName: "LeaderboardTableCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        leaderboardTableView.delegate = self
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.leaderboardTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func getData() {
        DispatchQueue.global(qos: .utility).async {
            let result = self.apiClient.getQuizLeaderboard(quizId: self.quizId ?? -1)
            
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.dataFailed.isHidden = true
                }
                
                self.leaderboard = data?.sorted(by: { $0.score ?? 0 > $1.score ?? 0 })
                
                self.refresh()
                break
            case let .failure(error):
                DispatchQueue.main.async {
                    self.leaderboardTableView.isHidden = true
                    self.dataFailed.isHidden = false
                }
                
                print(error)
                break
            }
        }
    }
    
    func leaderboardScore(atIndex index: Int) -> LeaderboardScore? {
        guard let leaderboard = leaderboard else {
            return nil
        }
        
        return leaderboard[index]
    }
    
    func numberOfScores() -> Int {
        return leaderboard?.count ?? 0
    }
}

extension LeaderboardTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = LeaderboardTableHeader()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LeaderboardTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! LeaderboardTableCell
        
        if let leaderboardScore = leaderboardScore(atIndex: indexPath.row) {
            cell.setup(withLeaderboardScore: leaderboardScore)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfScores()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfScores()
    }
}


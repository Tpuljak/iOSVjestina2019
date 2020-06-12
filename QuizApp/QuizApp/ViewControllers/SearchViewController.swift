//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 09/06/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import CoreData

class SearchViewController : QuizTableViewController {
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var searchInput: UITextField!
    @IBAction func searchAction(_ sender: Any) {
        guard self.searchInput != nil || self.searchInput.text != nil else { return }
        
        self.getLocalData()
        
        if searchInput!.text! != "" {
            self.quizzes = self.quizzes?.filter({
                $0.title.contains(searchInput!.text!) || $0.description.contains(searchInput!.text!)
            })
        }
        
        self.updateSections()
        
        self.refresh()
    }
}

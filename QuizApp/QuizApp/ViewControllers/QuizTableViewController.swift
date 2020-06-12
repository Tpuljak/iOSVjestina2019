//
//  ViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 07/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class QuizTableViewController: UIViewController, ReachabilityObserverDelegate {
    
    @IBOutlet weak var quizTableView: UITableView!
    @IBOutlet weak var dataFailed: UILabel!
    
    var refreshControl: UIRefreshControl!
    var quizzes: [Quiz]?
    var quizSections: Dictionary<Category, [Quiz]>?
    var categories: [Category]?
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!UserDefaults.standard.valueExists(forKey: "token")) {
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.setLoginRootController()
            }
        }
        
        setupQuizTableView()
        
        try? addReachabilityObserver()
    }
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            getLocalData()
        } else {
            getData()
        }
    }
    
    func setupQuizTableView() {
        quizTableView.backgroundColor = UIColor.lightGray
        quizTableView.delegate = self
        quizTableView.dataSource = self
        quizTableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizTableViewController.refresh), for: UIControl.Event.valueChanged)
        quizTableView.refreshControl = refreshControl
        
        quizTableView.register(UINib(nibName: "QuizTableCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        quizTableView.delegate = self
    }
    
    func getLocalData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizzesCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let quizzesString = result.value(forKey: "quizzes") as? String else { return }
                    guard let quizJsonData = quizzesString.data(using: .utf8) else { return}
                    
                    self.quizzes = try JSONDecoder().decode([Quiz].self, from: quizJsonData)
                    self.updateSections()
                }
                
                self.refresh()
            }
        } catch {
            print("Error retrieving: \(error)")
        }
    }
    
    func getData() {
        DispatchQueue.global(qos: .utility).async {
            let result = self.apiClient.getQuizData()
            
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.dataFailed.isHidden = true
                }
                
                self.quizzes = data.flatMap{ $0.quizzes }!
                self.updateSections()
                
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let context = appDelegate.persistentContainer.viewContext
                    let quizModels = NSEntityDescription.insertNewObject(forEntityName: "QuizzesCoreData", into: context)
                    
                    let jsonData = try! JSONEncoder().encode(self.quizzes)
                    quizModels.setValue(String(data: jsonData, encoding: .utf8), forKey: "quizzes")
                    
                    do {
                        try context.save()
                    } catch {
                        fatalError("Error saving context")
                    }
                    
                    self.refresh()
                }
                
                break
            case let .failure(error):
                if self.quizzes?.isEmpty ?? true {
                    DispatchQueue.main.async {
                        self.quizTableView.isHidden = true
                        self.dataFailed.isHidden = false
                    }
                    
                    print(error)
                }
                
                break
            }
        }
    }
    
    func updateSections() {
        self.quizSections = Dictionary(grouping: self.quizzes ?? [], by: { $0.category })
        
        if self.quizSections != nil {
            self.categories = Array(self.quizSections!.keys)
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.quizTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func answerButtonAction(sender: UIButton) {
        if (sender.tag == 1) {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
    }
    
    func quiz(atIndex index: Int, atSection: Int) -> Quiz? {
        guard quizzes != nil else {
            return nil
        }
        
        if quizSections != nil && categories != nil {
            return quizSections![categories![atSection]]![index]
        }
        
        return nil
    }
    
    func numberOfQuizzes(section: Int) -> Int {
        if quizSections != nil && categories != nil {
            return quizSections![categories![section]]!.count
        }
        
        return 0
    }
    
}

extension QuizTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = QuizTableHeader()
        
        if categories != nil {
            view.setTitleAndColor(category: categories![section])
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let quiz = quiz(atIndex: indexPath.row, atSection: indexPath.section) {
            let singleQuizViewController = SingleQuizViewController()
            singleQuizViewController.quiz = quiz
            navigationController?.pushViewController(singleQuizViewController, animated: true)
        }
    }
}

extension QuizTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableCell
        
        if let quiz = quiz(atIndex: indexPath.row, atSection: indexPath.section) {
            cell.setup(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizSections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfQuizzes(section: section)
    }
}

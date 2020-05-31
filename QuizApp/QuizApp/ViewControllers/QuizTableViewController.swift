//
//  ViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 07/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

class QuizTableViewController: UIViewController {
    
    @IBOutlet weak var quizTableView: UITableView!
    @IBOutlet weak var dataFailedLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    var quizzes: [Quiz]?
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var apiClient = ApiClient(baseUrl: "https://iosquiz.herokuapp.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupQuizTableView()
    }
    
    func setupQuizTableView() {
        quizTableView.backgroundColor = UIColor.lightGray
        quizTableView.delegate = self
        quizTableView.dataSource = self
        quizTableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(ReviewsViewController.refresh), for: UIControl.Event.valueChanged)
        quizTableView.refreshControl = refreshControl

        quizTableView.register(UINib(nibName: "QuizTableViewController", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func getData() {
        DispatchQueue.global(qos: .utility).async {
            let result = self.apiClient.getQuizData()
            
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    let quizzes = data.flatMap{ $0.quizzes }!
                    
//                    let randomQuiz = quizzes[Int.random(in: 0..<quizzes.count)]
//                    self.dataFailedLabel.isHidden = true
//                    self.funFactCountLabel.text = String(self.getFunFactCount(quizzes: quizzes))
//                    self.questionView.subviews.forEach({ $0.removeFromSuperview() })
//
//                    if (randomQuiz.image.absoluteString == "") {
//                        self.singleQuizImageView.isHidden = true
//                    } else {
//                        self.singleQuizImageView.load(url: randomQuiz.image)
//                        self.singleQuizImageView.backgroundColor = categoryToColor(category: randomQuiz.category)
//                    }
//
//                    self.singleQuizNameLabel.text = randomQuiz.title
//                    self.singleQuizNameLabel.backgroundColor = categoryToColor(category: randomQuiz.category)
//                    self.mainStackView.isHidden = false
//
//                    if (quizzes.filter{ $0.questions.count > 0 }.count == 0) { return }
//                    var questions = randomQuiz.questions
//
//                    while(questions.count == 0) {
//                        questions = quizzes[Int.random(in: 0..<quizzes.count)].questions
//                    }
//
//                    let randomQuestion = questions[Int.random(in: 0..<questions.count)]
//
//                    let questionLabel = UILabel()
//                    questionLabel.text = randomQuestion.question
//                    questionLabel.numberOfLines = 0
//                    self.questionView.addSubview(questionLabel)
//
//                    questionLabel.translatesAutoresizingMaskIntoConstraints = false
//                    questionLabel.centerXAnchor.constraint(equalTo: self.questionView.centerXAnchor).isActive = true
//                    questionLabel.widthAnchor.constraint(equalTo: self.questionView.widthAnchor).isActive = true
//                    questionLabel.topAnchor.constraint(equalTo: self.questionView.topAnchor).isActive = true
//
//                    var previous: UIButton?
//                    for (index, answer) in randomQuestion.answers.enumerated() {
//                        let answerButton = UIButton()
//                        answerButton.setTitle(answer, for: .normal)
//                        answerButton.setTitleColor(UIColor.init(rgb: 0x007AFF), for: .normal)
//                        answerButton.tag = index == randomQuestion.correct_answer ? 1 : 0
//                        answerButton.addTarget(self, action: #selector(self.answerButtonAction), for: UIControl.Event.touchUpInside)
//                        self.questionView.addSubview(answerButton)
//
//                        answerButton.translatesAutoresizingMaskIntoConstraints = false
//                        answerButton.centerXAnchor.constraint(equalTo: self.questionView.centerXAnchor).isActive = true
//                        answerButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
//                        answerButton.widthAnchor.constraint(equalTo: self.questionView.widthAnchor).isActive = true
//
//                        if let previous = previous {
//                            answerButton.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
//                        } else {
//                            answerButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10).isActive = true
//                        }
//
//                        previous = answerButton
//                    }
                    break
                case let .failure(error):
                    self.dataFailedLabel.isHidden = false
//                    self.tableView.isHidden = true
                    print(error)
                    break
                }
            }
        }
    }
    
    func getFunFactCount(quizzes: Array<Quiz>) -> Int {
        var funFactCount = 0
        
        quizzes.forEach{ quiz in
            funFactCount += quiz.questions.filter { $0.question.contains("NBA") }.count
        }
        
        return funFactCount
    }
    
    @objc func answerButtonAction(sender: UIButton) {
        if (sender.tag == 1) {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
    }
    
    func quiz(atIndex index: Int) -> Quiz? {
        guard let quizzes = quizzes else {
            return nil
        }
        
        return quizzes[index]
    }
    
    func numberOfQuizzes() -> Int {
        return quizzes?.count ?? 0
    }
    
}

extension QuizTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = QuizTableHeader()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let review = quiz(atIndex: indexPath.row) {
            let singleQuizViewController = SingleQuizViewController()
            navigationController?.pushViewController(singleQuizViewController, animated: true)
        }
    }
}

extension QuizTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableCell
        
        if let quiz = quiz(atIndex: indexPath.row) {
            cell.setup(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfQuizzes()
    }
}

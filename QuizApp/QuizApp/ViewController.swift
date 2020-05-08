//
//  ViewController.swift
//  QuizApp
//
//  Created by Toma Puljak on 07/05/2020.
//  Copyright © 2020 Toma Puljak. All rights reserved.
//

import UIKit

struct Question: Codable {
    let id: Int
    let question: String
    let answers: Array<String>
    let correct_answer: Int
}

struct Quiz: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let level: Int
    let image: URL
    let questions: Array<Question>
}

struct Response: Codable {
    let quizzes: Array<Quiz>
}

extension UIImage {
    
    func resize(maxWidthHeight : Double)-> UIImage? {
        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0
        
        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }
        
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image.resize(maxWidthHeight: 200)
                    }
                }
            }
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var dataFailedLabel: UILabel!
    @IBOutlet weak var funFactCountLabel: UILabel!
    @IBOutlet weak var singleQuizImageView: UIImageView!
    @IBOutlet weak var singleQuizNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getData(_ sender: Any) {
        if let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        
                        let randomQuiz = res.quizzes[Int.random(in: 0..<res.quizzes.count)]
                        
                        DispatchQueue.main.async {
                            self.dataFailedLabel.isHidden = true
                            self.funFactCountLabel.text = String(self.getFunFactCount(quizzes: res.quizzes))
                            self.questionView.subviews.forEach({ $0.removeFromSuperview() })
                            
                            if (randomQuiz.image.absoluteString == "") {
                                self.singleQuizImageView.isHidden = true
                            } else {
                                self.singleQuizImageView.load(url: randomQuiz.image)
                            }
                            
                            self.singleQuizNameLabel.text = randomQuiz.title
                            self.mainStackView.isHidden = false
                            
                            if (res.quizzes.filter{ $0.questions.count > 0 }.count == 0) { return }
                            var questions = randomQuiz.questions
                            
                            while(questions.count == 0) {
                                questions = res.quizzes[Int.random(in: 0..<res.quizzes.count)].questions
                            }
                            
                            let randomQuestion = questions[Int.random(in: 0..<questions.count)]
                            
                            let questionLabel = UILabel()
                            questionLabel.text = randomQuestion.question
                            questionLabel.numberOfLines = 0
                            self.questionView.addSubview(questionLabel)
                            
                            questionLabel.translatesAutoresizingMaskIntoConstraints = false
                            questionLabel.centerXAnchor.constraint(equalTo: self.questionView.centerXAnchor).isActive = true
                            questionLabel.widthAnchor.constraint(equalTo: self.questionView.widthAnchor).isActive = true
                            questionLabel.topAnchor.constraint(equalTo: self.questionView.topAnchor).isActive = true
                            
                            var previous: UIButton?
                            for (index, answer) in randomQuestion.answers.enumerated() {
                                let answerButton = UIButton()
                                answerButton.setTitle(answer, for: .normal)
                                answerButton.setTitleColor(UIColor.init(rgb: 0x007AFF), for: .normal)
                                answerButton.tag = index == randomQuestion.correct_answer ? 1 : 0
                                answerButton.addTarget(self, action: #selector(self.answerButtonAction), for: UIControl.Event.touchUpInside)
                                self.questionView.addSubview(answerButton)
                                
                                answerButton.translatesAutoresizingMaskIntoConstraints = false
                                answerButton.centerXAnchor.constraint(equalTo: self.questionView.centerXAnchor).isActive = true
                                answerButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
                                answerButton.widthAnchor.constraint(equalTo: self.questionView.widthAnchor).isActive = true
                                
                                if let previous = previous {
                                    answerButton.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
                                } else {
                                    answerButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10).isActive = true
                                }

                                previous = answerButton
                            }
                        }
                    } catch let error {
                        self.mainStackView.isHidden = true
                        self.dataFailedLabel.isHidden = false
                        print(error)
                    }
                }
            }.resume()
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
}


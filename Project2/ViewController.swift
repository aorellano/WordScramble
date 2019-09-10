//
//  ViewController.swift
//  Project2
//
//  Created by Alexis Orellano on 3/3/19.
//  Copyright © 2019 Alexis Orellano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var timer: UILabel!
    var answerPrompt: UIAlertController!
    var errorPrompt: UIAlertController!
    var timeLeft = 60
    var timing: Timer?
    var words = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateWordArray()
        startGame()
    }
    
    func populateWordArray(){
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                words = startWords.components(separatedBy: "\n")
            }
        } else {
            words = ["silkworm"]
        }
    }
    
    func startGame() {
        word.text = words.randomElement()
    }
    
    func startTimer() {
        timing = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        timeLeft -= 1
        timer.text = "\(timeLeft)"
        if timeLeft <= 0 {
            timing?.invalidate()
            timing = nil
            gameOver()
        }
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "Times up!", message: "You got \(usedWords.count) words", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        if presentedViewController == nil {
            present(ac, animated: true)
        } else {
            answerPrompt.dismiss(animated: true)
            
            if errorPrompt != nil {
                errorPrompt.dismiss(animated: true)
            }
            present(ac, animated: true)
        }
    }

    @IBAction func startButtonPressed(_ sender: Any) {
        promptForAnswer()
        startTimer()
        startButton.setTitle("Restart", for: .normal)
        timeLeft = 60
        word.text = words.randomElement()
    }
    
    func promptForAnswer() {
        answerPrompt = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        answerPrompt.addTextField()
        let enter = UIAlertAction(title: "Submit", style: .default) { [unowned self, answerPrompt] action in
            let answer = answerPrompt?.textFields![0]
            self.submit(answer: answer!.text!)
        }
        answerPrompt.addAction(enter)
        present(answerPrompt, animated: true)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        
        if isPossible(answer: lowerAnswer) {
            if isOriginal(answer: lowerAnswer) {
                if isReal(answer: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
        
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    promptForAnswer()
                    return
                } else {
                    errorTitle = "Word not recognised"
                }
            } else {
                errorTitle = "Word used already"
            }
        } else {
            errorTitle = "Word not possible"
        }
        
        errorPrompt = UIAlertController(title: errorTitle, message: nil, preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Ok", style: .default) { _ in
            self.promptForAnswer()
        }
        
        errorPrompt.addAction(dismiss)
        present(errorPrompt, animated: true)
        promptForAnswer()
    }
    
    func isPossible(answer: String) -> Bool {
        var temp = answer.lowercased()
        for letter in answer {
            if let pos = temp.range(of: String(letter)) {
                temp.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(answer: String) -> Bool {
        return !usedWords.contains(answer)
    }
    
    func isReal(answer: String) -> Bool {
        let checker = UITextChecker()
        let misspelled = checker.rangeOfMisspelledWord(in: answer, range: NSMakeRange(0, answer.utf16.count), startingAt: 0, wrap: false, language: "en")
        
        return misspelled.location == NSNotFound
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

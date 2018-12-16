//
//  WordsViewController.swift
//  Apple Pie
//
//  Created by Wessel Mel on 10/12/2018.
//

import UIKit

class WordsViewController: UIViewController, UITextFieldDelegate {
    
    var amount: Int?
    var gameType = ""

    @IBOutlet weak var wordsList: UITextView!
    @IBOutlet weak var enterWords: UITextField!
    @IBOutlet weak var startGame: UIButton!
    
    var wordList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterWords.delegate = self
        wordsList.text = "Your Words: \n"
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterWords.resignFirstResponder()
        addWord()
        return true
    }
    
    func containsOnlyLetters(input: String) -> Bool {
        for chr in input {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func addWord() {
        if containsOnlyLetters(input: enterWords.text!) {
            wordList.append(enterWords.text!)
            wordsList.text += "\(enterWords.text!)\n"
            enterWords.text = ""
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a word with only letters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            enterWords.text = ""
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameSegue2" {
            let gameVC = segue.destination as! ViewController
            gameVC.amount = amount
            gameVC.wordsList = wordList
            gameVC.gameType = gameType
        }
    }
    
    @IBAction func startGameButton(_ sender: Any) {
        if wordList.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please enter some words before starting the game!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "GameSegue2", sender: startGame)
        }
        
    }
    
}

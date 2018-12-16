//
//  ViewController.swift
//  Apple Pie
//
//  Created by Wessel Mel on 08-11-18.
//

import UIKit

class ViewController: UIViewController {
    struct playerData {
        let id: String
        var wins: Int
        var losses: Int
    }
    
    var amount: Int?
    var players: [playerData] = [playerData]()
    var newWord = ""
    var gameType = ""
    var guessedWords = "Guessed words: "
    var player = 0
    var new = 0
    
    var wordsList: [String]?
    var listOfWords = ["food", "names", "hobbies", "animals"]
    let incorrectMovesAllowed = 7
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    var currentGame: Game!

    
    
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var guessedWordsLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gameType == "" || gameType == "SinglePlayer" {
            playerLabel.text = ""
        }
        if amount != nil {
            for i in 1 ... amount! {
                players.append(playerData(id: "Player \(i)", wins: 0, losses: 0))
            }
            print(players[0].id)
        }
        if wordsList != nil {
            print(wordsList!)
            listOfWords = wordsList!
        }
        newRound()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            new = 1
            updateUI()
        } else {
            enableLetterButtons(false)
            if gameType != "Multiplayer" {
                let alert = UIAlertController(title: "Done", message: "You have guessed \(totalWins) word(s) right and \(totalLosses) word(s) wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    //run your function here
                    self.performSegue(withIdentifier: "endGameSegue", sender: alert)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                var message = ""
                for i in players {
                    message += "\(i.id) has guessed \(i.wins) word(s) right and \(i.losses) wrong. "
                }
                let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    //run your function here
                    self.performSegue(withIdentifier: "endGameSegue", sender: alert)
                }))
                present(alert, animated: true, completion: nil)
            }
            
            
        }
        
    }
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func updateUI() {
        if new != 1 && gameType == "Multiplayer" {
            nextPlayer()
        }
        new = 0
        if gameType == "Multiplayer" {
            playerLabel.text = players[player].id
        }
        guessedWordsLabel.text = guessedWords
        var letters = [String]()
        for letter in currentGame.formattedWord.characters {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Total Wins: \(totalWins), Total Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }

    @IBAction func buttonPress(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            if gameType == "Multiplayer" {
                players[player].losses += 1
            }
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            guessedWords += "\(currentGame.formattedWord), "
            guessedWordsLabel.text = guessedWords
            if gameType == "Multiplayer" {
                players[player].wins += 1
            }
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextPlayer() {
        player += 1
        if player >= players.count {
            player = 0
        }
    }


}


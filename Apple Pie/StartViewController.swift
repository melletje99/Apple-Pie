//
//  StartViewController.swift
//  Apple Pie
//
//  Created by Wessel Mel on 10/12/2018.
//

import UIKit

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var wordTypePickerData: [String] = [String]()
    var typeChosen: String = "Enter own words"
    var gameType: String = ""
    var amount: Int?

    @IBOutlet weak var wordTypePicker: UIPickerView!
    @IBOutlet weak var multiplayerButton: UIButton!
    @IBOutlet weak var singePlayerButton: UIButton!
    @IBOutlet weak var playerAmountField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerAmountField.delegate = self
        wordTypePicker.delegate = self
        wordTypePicker.dataSource = self
        wordTypePickerData = ["Enter own words", "Build in words"]
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playerAmountField.resignFirstResponder()
        let num = Int(playerAmountField.text!)
        if num != nil && num! >= 2 && num! <= 4 {
            amount = num
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a number between 2 and 4 or do you want to empty the field?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Empty", style: .default, handler: {
                action in self.amount = nil
            }))
            present(alert, animated: true, completion: nil)
            playerAmountField.text = ""
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wordTypePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wordTypePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeChosen = wordTypePickerData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateWordsSegue" {
            let wordsVC = segue.destination as! WordsViewController
            wordsVC.amount = amount
            wordsVC.gameType = gameType
        }
        else if segue.identifier == "GameSegue" {
            let gameVC = segue.destination as! ViewController
            if amount != nil {
                gameVC.amount = amount
            }
            gameVC.gameType = gameType
        }
    }
    
    @IBAction func Multiplayer(_ sender: Any) {
        gameType = "Multiplayer"
        if amount == nil {
            let alert = UIAlertController(title: "Error", message: "You need to enter an amount of players!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else {
            if typeChosen == "Enter own words" {
                performSegue(withIdentifier: "CreateWordsSegue", sender: multiplayerButton)
            }
            else {
                performSegue(withIdentifier: "GameSegue", sender: multiplayerButton)
            }
        }
        
    }
    
    @IBAction func singlePlayer(_ sender: Any) {
        gameType = "SinglePlayer"
        print(typeChosen)
        if typeChosen == "Enter own words"{
            let alert = UIAlertController(title: "Error message", message: "You can't play with your own words against yourself", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "GameSegue", sender: singePlayerButton)
        }
    }
    
}

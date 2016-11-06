//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var phrase : String?
    var phraseLength : Int = 0
    var hangScore : Int = 1
    var phraseCharSet : Set<Character> = [] // for quick guess lookup
    var incorrectGuesses : Set<Character> = []
    var gameOver = false
    var userWins = false
    @IBOutlet weak var letterTextField: UITextField!
    @IBOutlet weak var currentPhraseGuessLabel: UILabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var attemptsLabel: UILabel!
    
    @IBAction func guessButtonPressed(_ sender: Any) {
        if letterTextField.text != nil &&
        letterTextField.text!.characters.count == 1 {
            let guess = Character(letterTextField.text!.uppercased())
            letterTextField.text = nil
            
            if phraseCharSet.contains(guess) { // correect guess
                var newGuessLabel = Array(currentPhraseGuessLabel.text!.characters)
                let phraseCharacters = Array(phrase!.characters)
                
                // iterate through guess label and flip correctly guessed characters
                for var i in 0..<phraseCharacters.count {
                    if phraseCharacters[i] == guess {
                        newGuessLabel[i] = phraseCharacters[i]
                    }
                }
                
                currentPhraseGuessLabel.text = String(newGuessLabel) // convert back to text
                phraseCharSet.remove(guess)
                print("User guessed \(guess) correctly!")
            } else { // incorrect guess
                hangScore += 1
                print("User guessed \(guess) incorrectly.")
                print("hangScore: \(hangScore)")
                
                if !incorrectGuesses.contains(guess) {
                    incorrectGuesses.insert(guess)
                    attemptsLabel.text = String(incorrectGuesses)
                }
                
                // update hangman display
                let newHangmanImageName = "hangman" + String(hangScore) + ".gif"
                hangmanImage.image = UIImage(named: newHangmanImageName)
            }
            
            checkGameState()
        }
    }
    
    
    func checkGameState() {
        if phraseCharSet.isEmpty { // user wins!
            print("User wins! Game over.")
            gameOver = true
            userWins = true
        } else if hangScore >= 7 { // user loses.
            // game over popup and ask if want to continue playing the game
            print("User loses... Game over.")
            gameOver = true
            userWins = false
        }
        
        if gameOver {
            var popupTitle : String
            
            if userWins {
                popupTitle = "Game over. You win!!"
            } else {
                popupTitle = "Game over. You lose..."
            }
            
            let alertController = UIAlertController(title: popupTitle, message: "Play again?", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            initializeGame()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeGame()
    }
    
    func initializeGame() {
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print("Phrase: \(phrase!)")
        attemptsLabel.text = ""
        incorrectGuesses = []
        phraseLength = phrase!.characters.count
        phraseCharSet = Set(phrase!.characters)
        phraseCharSet.remove(" ") // remove whitespace (not a match)
        var initialPhraseLabel = ""
        let phraseCharacters = Array(phrase!.characters)
        gameOver = false
        userWins = false
        
        // initialize currentPhraseGuessLabel
        for i in 0..<phraseLength {
            if phraseCharacters[i] == " " {
                initialPhraseLabel += " "
            }
            else {
                initialPhraseLabel += "_"
            }
        }
        
        currentPhraseGuessLabel.text = initialPhraseLabel
        hangmanImage.image = UIImage(named: "hangman1.gif")
        hangScore = 1
        print("hangScore: \(hangScore)")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

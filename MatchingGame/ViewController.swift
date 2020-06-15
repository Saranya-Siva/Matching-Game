//
//  ViewController.swift
//  Match App
//
//  Created by Saranya Kalyanasundaram on 5/4/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Float = 60 * 1000
    
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call the getCards method of the CardModel
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    override func viewDidAppear(_ animated: Bool) {
       
        soundManager.playSound(.shuffle)
        
    }
    
    //MARK: - Timer methods
    
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        //Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //set to timer label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //when the timer reached 0
        if milliseconds <= 0 {
            
            //Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Check if there are any unmatched cards
            checkGameEnded()
            
        }
        
    }
    
    //MARK: - UICollectionView protocol methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //get the card the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        //set the card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check if there is any time left
        if milliseconds <= 0{
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false  && card.isMatched == false{
            
            card.isFlipped = true
            //flip the card
            cell.flip()
            
            //play the flip sound
            soundManager.playSound(.flip)
            
            //Determine if its the first card or the second card flipped over
            if firstFlippedCardIndex == nil{
                
                // This is the first card being flipped
                firstFlippedCardIndex = indexPath
                print("\(firstFlippedCardIndex!)")
            }
            else{
                
                //This is the second card being flipped
                //Perform the matching logic
                checkForMatches(indexPath)
            }
        }
        
        
    }
    
    //MARK: - Game logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        
        //Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell

        //Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //It's Match
            soundManager.playSound(.match)
            
            //Set the status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Check if there are any cards unmatched
            checkGameEnded()
            
        }
        else{
            
            //It's not a Match
            soundManager.playSound(.nomatch)
            
            //Set the status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip back the cards
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //Tell the collection view to reload the cell of the first card
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        
        //Reset the property that tracks first card flipped
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded(){
        
        //Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray{
            
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        //If not, the user has won, stop the timer
        if isWon == true{
            
            if milliseconds > 0 {
                
                timer?.invalidate()
            }
            title = "Congratulations"
            message = "You've won"
        }
        else{
            //If there are unmatched cards, check there is time left in the timer
            if milliseconds > 0{
                return
            }
            title = "Game Over"
            message = "You've lost"
                   
        }
       
        //show won/lost message
        showAlert(title,message)
        
        
    }
    
    func showAlert(_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}//End of view controller class

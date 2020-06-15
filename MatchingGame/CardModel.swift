//
//  CardModel.swift
//  Match App
//
//  Created by Saranya Kalyanasundaram on 5/4/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import Foundation
 

class CardModel {
    
    func getCards() -> [Card] {
        
        //Declare an array to store the numbers we r generating
        var generatedNumbersArray = [Int]()
        
        //Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pair of cards
        while generatedNumbersArray.count < 8{
        
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            //  Make it so we only have a unique pair of cards
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
               
                //log the number and store the number to the generatedNUmberArray
                //print(randomNumber)
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                // Create second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
            
        
            
        }
        
        //  Randomize the array
        for i in 0...generatedCardsArray.count - 1{
            
            //find a random index to swap with
            let randomNumer = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            //swap the cards
            let temporaryNumber = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumer]
            generatedCardsArray[randomNumer] = temporaryNumber
            
            //lets print the random unique cards
            print(generatedCardsArray[i].imageName, generatedCardsArray[randomNumer].imageName )
            
        }
        
        
        // Return the array
        return generatedCardsArray
        
    }
}

//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Saranya Kalyanasundaram on 5/4/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!

    var card:Card?
    
    func setCard(_ card:Card){
        
        //Keep track of the card thst gets passed in
        self.card = card
        
        if(card.isMatched == true){
            frontImageView.alpha = 0
            backImageView.alpha = 0
            
            return
        }
        else{
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //Determine if the card is in the flipped up stateor flipped down state
        if card.isFlipped == true{
            
            //make sure the frontImageView is on the top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }
        else{
            //make sure the backImageView is on the top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove(){
        
        //Remove both the imageviews from being visible
        backImageView.alpha = 0
        
        // Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
        
    }
}

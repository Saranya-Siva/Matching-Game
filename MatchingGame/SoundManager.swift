//
//  SoundManager.swift
//  Match App
//
//  Created by Saranya Kalyanasundaram on 5/6/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
     var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
     func playSound(_ effect:SoundEffect){
        
        var soundFileName = ""
        
        //Determine which sound effect we want to play
        //Set the appropriate file name
        switch effect{
            
        case .flip:
            soundFileName = "cardflip"
            
        case .shuffle:
            soundFileName = "shuffle"
            
        case .match:
            soundFileName = "dingcorrect"
            
        case .nomatch:
            soundFileName = "dingwrong"
            
        }
        
        //Get the path of the sound file
       var bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else{
            print("couldn find the file \(soundFileName)")
            return
        }
        
        //Create the URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
            //Create the audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //play the sound
            audioPlayer?.play()
        }
        catch{
            //could'n create the audio player object log the error
            print("Couldn't create the audio player object for the sound file \(soundFileName)")
        }
    }
}


//
//  Siri.swift
//  Siri
//
//  Created by Marin Todorov on 6/23/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import Foundation
import AVFoundation

class Assistant: NSObject, AVSpeechSynthesizerDelegate {
    
    internal let answers: [String] = [
        "OK from now on I'll call you 'my little princess'. I sent your new name to all your contacts as well",
        "Can't find any local business around you for search term 'cheap booze'",
        "Looks like you are leaving the house - don't forget you're living in a post apocalyptic zombie world",
        "Making a wake up reminder for 3:00 AM. Don't wake me up...",
        "Here is the list of the 20 closest 'raging football fans' around you"
    ]
    
    private var completionBlock: ( () -> Void )?
    
    private let synth = AVSpeechSynthesizer()
    
    override init () {
        super.init()
        synth.delegate = self
    }
    
    func randomAnswer() -> String {
        return answers[Int(arc4random_uniform(UInt32(answers.count)))]
    }
    
    func speak(phrase: String, completion: ()->Void) {
        //save the completion block
        completionBlock = completion

        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 1.0
        synth.speakUtterance(utterance)
    }
    
    //MARK: - speech synth methods
    internal func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        completionBlock?()
    }
}
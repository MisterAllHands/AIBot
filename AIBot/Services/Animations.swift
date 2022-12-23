//
//  Animations.swift
//  AIBot
//
//  Created by TTGMOTSF on 20/12/2022.
//

import Foundation
import UIKit
import GlitchLabel
import LTMorphingLabel
import TransitionButton

class AnimationForLabel{
    
    static func startAnimation(with label1: LTMorphingLabel, label2: GlitchLabel, button1: TransitionButton ){
        
        let textArray = ["Better","Smarter","Faster", "AI ASSISTANT"]
        label1.font = .systemFont(ofSize: 50, weight: .bold)
        label1.morphingEffect = .anvil
        label1.morphingDuration = 0.60
        
       DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            
            label1.text = textArray[0]
            
        }
        
       DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
            label1.text = textArray[1]
        }
        
       DispatchQueue.main.asyncAfter(deadline: .now()+2.5){
            label1.text = textArray[2]
        }
        
       DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
            label1.morphingDuration = 2.0
            label1.morphingEffect = .fall
            label1.text = textArray[3]
        }
        
       DispatchQueue.main.asyncAfter(deadline: .now()+6.5){
           label1.text = ""
           label2.font = .systemFont(ofSize: 50, weight: .bold)
           label2.blendMode = .colorDodge
           label2.amplitudeBase = 2000
           label2.textColor = .black
           label2.text = "AI ASSISTANT"
           label2.alphaMin = 1.0
           label2.amplitudeRange = 5.0
           label1.text = "AI ASSISTANT"
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+7.5){
            label2.textColor = .systemTeal
            label2.blendMode = .destinationIn
        }
       
       DispatchQueue.main.asyncAfter(deadline: .now()+7){
           button1.isHidden = false
           button1.transform = CGAffineTransform(translationX: 0, y: 70)
           UIView.animate(withDuration: 1.0) {
               button1.transform = .identity
           }
           button1.alpha = 0
           UIView.animate(withDuration: 0.50) {
               button1.alpha = 1
           }
       }
    }
}

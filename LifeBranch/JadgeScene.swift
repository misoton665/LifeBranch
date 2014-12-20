//
//  JadgeScene.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/19.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import SpriteKit

class JadgeScene: SKScene{
    var questionText: NSString = "Question"
    var choisesAText: NSString = "ChoisesA"
    var choisesBText: NSString = "ChoisesB"
    
    var question: NSString{
        get{
            return questionText
        }
        set(text){
            questionText = text
        }
    }
    
    var choisesA: NSString{
        get{
            return choisesAText
        }
        set(text){
            choisesAText = choisesA
        }
    }
    
    var choisesB: NSString{
        get{
            return choisesBText
        }
        set(text){
            choisesBText = choisesB
        }
    }
    
    override func didMoveToView(view: SKView) {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
}

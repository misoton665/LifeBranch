//
//  Problem.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/20.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import Foundation

class Problem{
    private var problemText: NSString = ""
    private var choicesAText: NSString = ""
    private var choicesBText: NSString = ""
    
    internal var problem: NSString{
        get{
            return problemText
        }
        set(text){
            problemText = text
        }
    }
    
    internal var choicesA: NSString{
        get{
            return choicesAText
        }
        set(text){
            choicesAText = text
        }
    }
    
    internal var choicesB: NSString{
        get{
            return choicesBText
        }
        set(text){
            choicesBText = text
        }
    }
    
    func hasEmpty() -> Bool{
        return problemText == "" || choicesAText == "" || choicesBText == ""
    }
}

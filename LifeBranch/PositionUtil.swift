//
//  PositionUtil.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/15.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import UIKit

struct PositionUtil{
    static var _uiMidX: CGFloat = 0.0
    static var _uiMidY: CGFloat = 0.0
    
    static var uiMidX: CGFloat{
        get{
            return _uiMidX
        }
        set(value){
            _uiMidX = value
        }
    }
    
    static var uiMidY: CGFloat{
        get{
            return _uiMidY
        }
        set(value){
            _uiMidY = value
        }
    }
}
//
//  SimpleSKLabel.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/24.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import Foundation
import SpriteKit

class SimpleSKLabel: SKLabelNode{
    private var parentScene: SKScene!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parentScene scene: SKScene, text t: NSString, fontSize s: CGFloat, porition p: (CGFloat, CGFloat)){
        super.init()
        self.text = t
        self.fontSize = s
        self.fontColor = AppColors.textColor
        self.position = CGPointMake(p.0, p.1)
        self.parentScene = scene
    }
    
    func addToScene(){
        parentScene.addChild(self)
    }
}
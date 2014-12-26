//
//  JudgeCircleNode.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/25.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import Foundation
import SpriteKit

protocol JudgeCircleFalledDelegate{
    func judgeCircleFalled(falledNode: JudgeCircleNode)
}

class JudgeCircleNode: SKShapeNode{
    private var parentScene: SKScene!
    private var fallBorder: Int!
    private var fallCount: Int = 0
    private var timer: NSTimer!
    var falledDelegate: JudgeCircleFalledDelegate!
    
    var delegate: JudgeCircleFalledDelegate{
        get{
            return self.falledDelegate
        }
        set(d){
            self.falledDelegate = d
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parentScene: SKScene,position: (CGFloat, CGFloat), fallBorder: Int = 6){
        super.init()
        self.fallBorder = fallBorder
        self.fillColor = AppColors.ballColor
        self.parentScene = parentScene
        self.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 10.0 * 2.0, 10.0 * 2.0), nil)
        self.position = CGPointMake(position.0 - 10.0, position.1 - 10.0)
        self.physicsBody = SKPhysicsBody(polygonFromPath: self.path)
        self.physicsBody?.restitution = 0.6
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: "stateUpdate", userInfo: nil, repeats: true)
    }
    
    func stateUpdate(){
        if(self.position.y < 30){
            self.incFallCount(1)
        } else {
            self.resetFallCount()
        }
        if(self.isFall()){
            timer.invalidate()
            falledDelegate.judgeCircleFalled(self)
        }
    }
    
    private func incFallCount(value: Int){
        fallCount += value
    }
    
    private func resetFallCount(){
        fallCount = 0
    }
    
    func isFall()->Bool{
        return fallCount > fallBorder
    }
    
    func addToScene(){
        self.parentScene.addChild(self)
    }
}
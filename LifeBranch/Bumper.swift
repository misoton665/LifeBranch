//
//  Bumper.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/23.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import Foundation
import SpriteKit

class Bumper: SKShapeNode{
    enum NodeType{
        case Circle,
        Rect,
        Triangle
    }
    
    private var rotatable: Bool = false
    private var parentScene: SKScene? = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parentScene scene: SKScene, nodeType t: NodeType, position p: (CGFloat, CGFloat), nodeSize s: CGFloat, nodeColor c: UIColor = AppColors.mainColor, rotatable r: Bool = false){
        super.init()
        self.parentScene = scene
        self.initSelfNode(nodeType: t, nodeSize: s, position: p)
        self.fillColor = AppColors.mainColor
        self.physicsBody = SKPhysicsBody(edgeLoopFromPath: self.path)
        self.physicsBody?.dynamic = false
    }
    
    private func initSelfNode(nodeType t: NodeType, nodeSize s: CGFloat, position p: (CGFloat, CGFloat)){
        switch(t){
        case .Circle:
            self.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, s, s), nil)
            self.position = CGPointMake(p.0 - s / 2.0, p.1 - s / 2.0)
            
        case .Rect:
            self.path = CGPathCreateWithRect(CGRectMake(0, 0, s, s), nil)
            self.position = CGPointMake(p.0 - s / 2.0, p.1 - s / 2.0)
            
        case .Triangle:
            var points = [CGPoint(x:s / 2.0, y: -s / 2.0 * 1.73205080757 / 3.0),
                CGPoint(x:-s / 2.0, y: -s / 2.0 * 1.73205080757 / 3.0),
                CGPoint(x: 0.0, y: s / 2.0 * 1.73205080757 / 3.0 * 2.0),
                CGPoint(x:s / 2.0, y: -s / 2.0 * 1.73205080757 / 3.0)]
            
            var path = CGPathCreateMutable()
            
            var oneflag : Bool = true
            for point in points {
                if oneflag == true {
                    CGPathMoveToPoint(path,nil,point.x,point.y)
                    oneflag = false
                }
                else{
                    CGPathAddLineToPoint(path,nil,point.x,point.y)
                }
            }
            CGPathCloseSubpath(path)
            
            self.path = path
            self.position = CGPointMake(p.0, p.1)
            
        default:
            println("catched default in Bumper.initSelfNode.")
        }
        
    }
    
    func addToScene(){
        self.parentScene?.addChild(self)
    }
}
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
    private var parentScene: SKScene!
    private var action: SKAction!
    private var nodeType: NodeType!
    private var purePosition: CGPoint!
    
    var restitution: CGFloat?{
        get{
            return self.physicsBody?.restitution
        }
        set(r){
            self.physicsBody?.restitution = r!
        }
    }
    
    var degree: CGFloat?{
        get{
            return self.zRotation
        }
        set(d){
            self.zRotation = CGFloat(d!) / CGFloat(180.0 * M_1_PI)
        }
    }
    
    var convertedPosition: CGPoint?{
        get{
            return self.position
        }
        set(p){
            self.position = p!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(parentScene scene: SKScene, nodeType t: NodeType, position p: (CGFloat, CGFloat), nodeSize s: (CGFloat, CGFloat), nodeColor c: UIColor = AppColors.mainColor, rotatable r: Bool = false){
        super.init()
        self.parentScene = scene
        self.nodeType = t
        self.rotatable = r
        self.purePosition = CGPointMake(p.0, p.1)
        self.createNode(nodeFrame: CGRectMake(0, 0, s.0, s.1))
        self.fillColor = AppColors.bumperColor
    }
    
    convenience init(parentScene scene: SKScene, circlePos p: (CGFloat, CGFloat), circleRadius s: CGFloat, circleColor c: UIColor = AppColors.mainColor, rotatable r: Bool = false){
        self.init(parentScene: scene, nodeType: .Circle, position: p, nodeSize: (s, s), nodeColor: c, rotatable: r)
    }
    
    convenience init(parentScene scene: SKScene, rectPos p: (CGFloat, CGFloat), rectSize s: (CGFloat, CGFloat), rectColor c: UIColor = AppColors.mainColor, rotatable r: Bool = false){
        self.init(parentScene: scene, nodeType: .Rect, position: p, nodeSize: s, nodeColor: c, rotatable: r)
    }
    
    convenience init(parentScene scene: SKScene, trianglePos p: (CGFloat, CGFloat), triangleLength s: CGFloat, triangleColor c: UIColor = AppColors.mainColor, rotatable r: Bool = false){
        self.init(parentScene: scene, nodeType: .Triangle, position: p, nodeSize: (s, s), nodeColor: c, rotatable: r)
    }
    
    private func createNode(nodeFrame f: CGRect){
        switch(self.nodeType!){
        case .Circle:
            self.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, f.width * 2.0, f.height * 2.0), nil)
            self.position = CGPointMake(purePosition.x - f.width, purePosition.y - f.height)
            self.physicsBody = SKPhysicsBody(polygonFromPath: self.path)
            
        case .Rect:
            self.path = CGPathCreateWithRect(CGRectMake(0, 0, f.width, f.height), nil)
            self.position = CGPointMake(purePosition.x - f.width / 2.0, purePosition.y - f.height / 2.0)
            self.physicsBody = SKPhysicsBody(edgeLoopFromRect: f)
            
        case .Triangle:
            var points = [CGPoint(x:f.width / 2.0, y: -f.height / 2.0 * 1.73205080757 / 3.0),
                CGPoint(x:-f.width / 2.0, y: -f.height / 2.0 * 1.73205080757 / 3.0),
                CGPoint(x: 0.0, y: f.height / 2.0 * 1.73205080757 / 3.0 * 2.0),
                CGPoint(x:f.width / 2.0, y: -f.height / 2.0 * 1.73205080757 / 3.0)]
            
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
            self.position = CGPointMake(purePosition.x, purePosition.y)
            self.physicsBody = SKPhysicsBody(polygonFromPath: path)
            
        default:
            println("catched default in Bumper.createNode.")
        }
        self.physicsBody?.dynamic = false
    }
    
    func addToScene(){
        self.parentScene?.addChild(self)
    }
}
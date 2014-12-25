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
    
    private let rotateTime: Double = 0.1
    
    private var rotatable: Bool = false
    private var parentScene: SKScene!
    private var action: SKAction!
    private var nodeType: NodeType!
    private var purePosition: CGPoint!
    private var timer: NSTimer!
    
    private var rotateAction: SKAction!
    
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
    
    init(parentScene scene: SKScene, nodeType t: NodeType, position p: (CGFloat, CGFloat), nodeSize s: (CGFloat, CGFloat), nodeColor c: UIColor = AppColors.mainColor, rotatable r: Bool = false, rotateDegree d: CGFloat = 0.0){
        super.init()
        self.parentScene = scene
        self.nodeType = t
        self.rotatable = r
        self.purePosition = CGPointMake(p.0, p.1)
        self.createNode(nodeSize: CGRectMake(0, 0, s.0, s.1))
        self.fillColor = AppColors.bumperColor
        if self.rotatable {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: "update", userInfo: nil, repeats: true)
            rotateAction = SKAction.rotateByAngle( CGFloat(d) / CGFloat(180.0 * M_1_PI) , duration: rotateTime)
        }
    }
    
    // 円形バンパーの時のイニシャライザ
    convenience init(parentScene scene: SKScene, circlePos p: (CGFloat, CGFloat), circleRadius s: CGFloat, rotatable r: Bool = false, rotateDegree d: CGFloat = 0.0, circleColor c: UIColor = AppColors.mainColor){
        self.init(parentScene: scene, nodeType: .Circle, position: p, nodeSize: (s, s), nodeColor: c, rotatable: r, rotateDegree: d)
    }
    
    // 四角形バンパーの時のイニシャライザ
    convenience init(parentScene scene: SKScene, rectPos p: (CGFloat, CGFloat), rectSize s: (CGFloat, CGFloat), rotatable r: Bool = false, rotateDegree d: CGFloat = 0.0, rectColor c: UIColor = AppColors.mainColor){
        self.init(parentScene: scene, nodeType: .Rect, position: p, nodeSize: s, nodeColor: c, rotatable: r, rotateDegree: d)
    }
    
    // 三角形バンパーの時のイニシャライザ
    convenience init(parentScene scene: SKScene, trianglePos p: (CGFloat, CGFloat), triangleLength s: CGFloat, rotatable r: Bool = false, rotateDegree d: CGFloat = 0.0, triangleColor c: UIColor = AppColors.mainColor){
        self.init(parentScene: scene, nodeType: .Triangle, position: p, nodeSize: (s, s), nodeColor: c, rotatable: r, rotateDegree: d)
    }
    
    private func createNode(nodeSize s: CGRect){
        switch(self.nodeType!){
        case .Circle:
            self.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, s.width * 2.0, s.height * 2.0), nil)
            self.convertedPosition = CGPointMake(purePosition.x - s.width, purePosition.y - s.height)
            self.physicsBody = SKPhysicsBody(polygonFromPath: self.path)
            
        case .Rect:
            var points = [CGPoint(x:s.width / 2.0, y: s.height / 2.0),
                CGPoint(x:-s.width / 2.0, y: s.height / 2.0),
                CGPoint(x:-s.width / 2.0, y:-s.height / 2.0),
                CGPoint(x:s.width / 2.0, y: -s.height / 2.0),
                CGPoint(x:s.width / 2.0, y: s.height / 2.0)]
            
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
            self.convertedPosition = CGPointMake(purePosition.x, purePosition.y)
            self.physicsBody = SKPhysicsBody(polygonFromPath: path)
            
        case .Triangle:
            let rt3: CGFloat = 1.73205080757
            
            var points = [CGPoint(x:s.width / 2.0, y: -s.height / 2.0 * rt3 / 3.0),
                CGPoint(x:-s.width / 2.0, y: -s.height / 2.0 * rt3 / 3.0),
                CGPoint(x: 0.0, y: s.height / 2.0 * rt3 / 3.0 * 2.0),
                CGPoint(x:s.width / 2.0, y: -s.height / 2.0 * rt3 / 3.0)]
            
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
            self.convertedPosition = CGPointMake(purePosition.x, purePosition.y)
            self.physicsBody = SKPhysicsBody(polygonFromPath: path)
            
        default:
            println("catched default in Bumper.createNode.")
        }
        self.physicsBody?.dynamic = false
    }
    
    func update(){
        self.runRotation()
    }
    
    func runRotation(){
        self.runAction(rotateAction)
    }
    
    func addToScene(){
        self.parentScene?.addChild(self)
    }
}
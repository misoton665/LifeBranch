//
//  JadgeScene.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/19.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import SpriteKit

extension SKScene{
    
    func GetMid()->CGPoint{
        return CGPointMake(self.frame.midX, self.frame.midY)
    }
    
    func DegreeToRadian(Degree : Double!)-> CGFloat{
        return CGFloat(Degree) / CGFloat(180.0 * M_1_PI)
    }
    
}

class JadgeCircleNode: SKShapeNode{
    let fallBorder: Int = 20
    var fallCount: Int = 0
    
    func incFallCount(value: Int){
        fallCount += value
    }
    
    func resetFallCount(){
        fallCount = 0
    }
    
    func isFall()->Bool{
        return fallCount > fallBorder
    }
}

class RemovedBool{
    var _boolValue: Int = 1
    
    var bool: Bool{
        get{
            if(_boolValue == 1){
                return true
            } else {
                return false
            }
        }
        set(bool){
            if(bool){
                _boolValue = 1
            } else {
                _boolValue = 0
            }
        }
    }
    
    init(bool: Bool){
        if(bool){
            _boolValue = 1
        } else {
            _boolValue = 0
        }
    }
}

class JadgeScene: SKScene{
    var _problem: Problem = Problem()
    
    private let wallThickness: CGFloat = 10.0
    
    private var leftRotateAction :SKAction!
    private var rightRotateAction :SKAction!
    private var circleBumperA: SKShapeNode!
    private var circleBumperB: SKShapeNode!
    private var triangleBumperA : SKShapeNode!
    private var triangleBumperB : SKShapeNode!
    private var triangleBumperC : SKShapeNode!
    private var triangleBumperD : SKShapeNode!
    private var wallBumperA: SKShapeNode!
    private var wallBumperB: SKShapeNode!
    private var wallBumperC: SKShapeNode!
    private var wallBumperD: SKShapeNode!
    private var leftLabel: SKLabelNode!
    private var rightLabel: SKLabelNode!
    
    private var leftCnt: Int = 0
    private var rightCnt: Int = 0
    
    private var rotatefl: Bool = true
    
    private var circles: [(JadgeCircleNode, RemovedBool)] = []
    
    var problem: Problem{
        get{
            return _problem
        }
        set(value){
            _problem = value
        }
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = AppColors.backgroundColor
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
        
        leftRotateAction = SKAction.rotateByAngle( DegreeToRadian(36.0) , duration: 0.1)
        rightRotateAction = SKAction.rotateByAngle( DegreeToRadian(-36.0) , duration: 0.1)
        
        circleBumperA = SKShapeNode(circleOfRadius: 24.0)
        circleBumperA.fillColor = AppColors.bumperColor
        circleBumperA.position = CGPointMake(self.frame.midX - 120, self.frame.midY + 200)
        circleBumperA.physicsBody = SKPhysicsBody(circleOfRadius: 24.0)
        circleBumperA.physicsBody?.dynamic = false
        circleBumperA.physicsBody?.restitution = -0.2
        self.addChild(circleBumperA)
        
        circleBumperB = SKShapeNode(circleOfRadius: 24.0)
        circleBumperB.fillColor = AppColors.bumperColor
        circleBumperB.position = CGPointMake(self.frame.midX + 120, self.frame.midY + 200)
        circleBumperB.physicsBody = SKPhysicsBody(circleOfRadius: 24.0)
        circleBumperB.physicsBody?.dynamic = false
        circleBumperB.physicsBody?.restitution = -0.2
        self.addChild(circleBumperB)
        
        var halfLength: CGFloat = 30.0
        
        var points = [CGPoint(x:halfLength, y: -halfLength * 1.73205080757 / 3.0),
            CGPoint(x:-halfLength, y: -halfLength * 1.73205080757 / 3.0),
            CGPoint(x: 0.0, y: halfLength * 1.73205080757 / 3.0 * 2.0),
            CGPoint(x:halfLength, y: -halfLength * 1.73205080757 / 3.0)]
        
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
        
        triangleBumperA = SKShapeNode(points: &points, count: UInt(points.count))
        triangleBumperA.physicsBody = SKPhysicsBody(polygonFromPath: path)
        triangleBumperA.fillColor = AppColors.bumperColor
        triangleBumperA.position = CGPointMake(self.frame.midX + halfLength * 1.73205080757 / 3.0 * 2.0,self.frame.midY)
        triangleBumperA.physicsBody?.dynamic = false
        triangleBumperA.physicsBody?.restitution = 1.2
        self.addChild(triangleBumperA)
        
        triangleBumperB = SKShapeNode(points: &points, count: UInt(points.count))
        triangleBumperB.physicsBody = SKPhysicsBody(polygonFromPath: path)
        triangleBumperB.fillColor = AppColors.bumperColor
        triangleBumperB.position = CGPointMake(self.frame.midX - halfLength * 1.73205080757 / 3.0 * 2.0,self.frame.midY)
        triangleBumperB.physicsBody?.dynamic = false
        triangleBumperA.physicsBody?.restitution = 1.2
        self.addChild(triangleBumperB)
        
        halfLength = 20.0
        
        points = [CGPoint(x:halfLength, y: -halfLength * 1.73205080757 / 3.0),
            CGPoint(x:-halfLength, y: -halfLength * 1.73205080757 / 3.0),
            CGPoint(x: 0.0, y: halfLength * 1.73205080757 / 3.0 * 2.0),
            CGPoint(x:halfLength, y: -halfLength * 1.73205080757 / 3.0)]
        
        triangleBumperC = SKShapeNode(points: &points, count: UInt(points.count))
        triangleBumperC.physicsBody = SKPhysicsBody(polygonFromPath: path)
        triangleBumperC.fillColor = AppColors.bumperColor
        triangleBumperC.position = CGPointMake(self.frame.midX - 160, self.frame.midY - 160)
        triangleBumperC.physicsBody?.dynamic = false
        self.addChild(triangleBumperC)
        
        triangleBumperD = SKShapeNode(points: &points, count: UInt(points.count))
        triangleBumperD.physicsBody = SKPhysicsBody(polygonFromPath: path)
        triangleBumperD.fillColor = AppColors.bumperColor
        triangleBumperD.position = CGPointMake(self.frame.midX + 160, self.frame.midY - 160)
        triangleBumperD.physicsBody?.dynamic = false
        self.addChild(triangleBumperD)
        
        wallBumperA = SKShapeNode(rectOfSize: CGSizeMake(100.0, wallThickness))
        wallBumperA.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100.0, wallThickness))
        wallBumperA.fillColor = AppColors.bumperColor
        wallBumperA.position = CGPointMake(self.frame.midX - 100, self.frame.midY - 100)
        wallBumperA.zRotation = DegreeToRadian(-30)
        wallBumperA.physicsBody?.dynamic = false
        wallBumperA.physicsBody?.restitution = 1.0
        self.addChild(wallBumperA)
        
        wallBumperB = SKShapeNode(rectOfSize: CGSizeMake(100.0, wallThickness))
        wallBumperB.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(100.0, wallThickness))
        wallBumperB.fillColor = AppColors.bumperColor
        wallBumperB.position = CGPointMake(self.frame.midX + 100, self.frame.midY - 100)
        wallBumperB.zRotation = DegreeToRadian(30)
        wallBumperB.physicsBody?.dynamic = false
        wallBumperB.physicsBody?.restitution = 1.0
        self.addChild(wallBumperB)
        
        wallBumperC = SKShapeNode(rectOfSize: CGSizeMake(80.0, wallThickness))
        wallBumperC.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(80.0, wallThickness))
        wallBumperC.fillColor = AppColors.bumperColor
        wallBumperC.position = CGPointMake(self.frame.midX - 173, self.frame.midY + 20)
        wallBumperC.zRotation = DegreeToRadian(-10)
        wallBumperC.physicsBody?.dynamic = false
        self.addChild(wallBumperC)
        
        wallBumperD = SKShapeNode(rectOfSize: CGSizeMake(80.0, wallThickness))
        wallBumperD.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(80.0, wallThickness))
        wallBumperD.fillColor = AppColors.bumperColor
        wallBumperD.position = CGPointMake(self.frame.midX + 173, self.frame.midY + 20)
        wallBumperD.zRotation = DegreeToRadian(10)
        wallBumperD.physicsBody?.dynamic = false
        self.addChild(wallBumperD)
        
        var llinePoints = [
            CGPointMake(self.frame.midX - 217, self.frame.maxY),
            CGPointMake(self.frame.midX - 217, -self.frame.maxY)
        ]
        
        var rlinePoints = [
            CGPointMake(self.frame.midX + 217, self.frame.maxY),
            CGPointMake(self.frame.midX + 217, -self.frame.maxY)
        ]
        
        var choicesLinePoints = [
            CGPointMake(self.frame.midX, self.frame.minY),
            CGPointMake(self.frame.midX, self.frame.minY + 100)
        ]
        
        let leftBorderLine = SKShapeNode(points: &llinePoints, count: UInt(llinePoints.count))
        leftBorderLine.strokeColor = AppColors.mainColor
        leftBorderLine.physicsBody = SKPhysicsBody(edgeFromPoint: llinePoints[0], toPoint: llinePoints[1])
        self.addChild(leftBorderLine)
        
        let rightBorderLine = SKShapeNode(points: &rlinePoints, count: UInt(rlinePoints.count))
        rightBorderLine.strokeColor = AppColors.mainColor
        rightBorderLine.physicsBody = SKPhysicsBody(edgeFromPoint: rlinePoints[0], toPoint: rlinePoints[1])
        self.addChild(rightBorderLine)
        
        let ChoicesBorderLine = SKShapeNode(points: &choicesLinePoints, count: UInt(choicesLinePoints.count))
        ChoicesBorderLine.strokeColor = AppColors.mainColor
        ChoicesBorderLine.physicsBody = SKPhysicsBody(edgeFromPoint: choicesLinePoints[0], toPoint: choicesLinePoints[1])
        self.addChild(ChoicesBorderLine)
        
        leftLabel = SKLabelNode(text: "\(leftCnt)")
        leftLabel.fontSize = 50
        leftLabel.fontColor = AppColors.textColor
        leftLabel.position = CGPointMake((self.frame.midX + self.frame.midX - 217) / 2, self.frame.minY + 40)
        self.addChild(leftLabel)
        
        rightLabel = SKLabelNode(text:"\(rightCnt)")
        rightLabel.fontSize = 50
        rightLabel.fontColor = AppColors.textColor
        rightLabel.position = CGPointMake((self.frame.midX + self.frame.midX - 217) / 2 + (self.frame.midX - (self.frame.midX - 217)), self.frame.minY + 40)
        self.addChild(rightLabel)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches{
            let location = touch.locationInNode(self)
            
            let circle = JadgeCircleNode(circleOfRadius: 10.0)
            circle.fillColor = AppColors.ballColor
            circle.position = location
            circle.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
            circle.physicsBody?.restitution = 0.6
        
            self.addChild(circle as SKShapeNode)
            
            circles.append(circle, RemovedBool(bool: true))
        }
    }
    
    func update(){
        triangleBumperA.runAction(rightRotateAction)
        triangleBumperB.runAction(leftRotateAction)
        triangleBumperC.runAction(leftRotateAction)
        triangleBumperD.runAction(rightRotateAction)
        
        var cnt = 0
        
        for circle: (JadgeCircleNode, RemovedBool) in circles{
            if(!circle.1.bool){
                continue
            }
            
            if(circle.0.position.y < 20){
                circle.0.incFallCount(1)
            } else {
                circle.0.resetFallCount()
            }
            if(circle.0.isFall()){
                if(circle.0.frame.midX < self.frame.midX){
                    leftCnt++
                    leftLabel.text = "\(leftCnt)"
                } else {
                    rightCnt++
                    rightLabel.text = "\(rightCnt)"
                }
                self.removeChildrenInArray([circle.0])
                circle.1.bool = false
            }
            cnt++
        }
    }
}

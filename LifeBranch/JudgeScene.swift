//
//  JadgeScene.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/19.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import SpriteKit
import Social

extension SKScene{
    
    func GetMid()->CGPoint{
        return CGPointMake(self.frame.midX, self.frame.midY)
    }
    
    func DegreeToRadian(Degree : Double!)-> CGFloat{
        return CGFloat(Degree) / CGFloat(180.0 * M_1_PI)
    }
    
}

class JudgeCircleNode: SKShapeNode{
    let fallBorder: Int = 6
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

class JudgeScene: SKScene{
    var _problem: Problem = Problem()
    
    private let wallThickness: CGFloat = 10.0
    
    private var leftRotateAction :SKAction!
    private var rightRotateAction :SKAction!
    
    private var circleLeftCntLabel: SKLabelNode!
    private var throwableArea: SKShapeNode!
    private var choicesArea: SKShapeNode!
    
    private var circleBumperA: SKShapeNode!
    private var circleBumperB: SKShapeNode!
    private var circleBumperC: SKShapeNode!
    private var circleBumperD: SKShapeNode!
    
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
    
    private var choicesALabel: SKLabelNode!
    private var choicesBLabel: SKLabelNode!
    
    private var leftCnt: Int = 0
    private var rightCnt: Int = 0
    private var circleLeftCnt: Int = 11
    private var circleFalledCnt: Int = 0
    private let circleMax: Int = 11
    
    private var rotatefl: Bool = true
    
    private var circles: [(JudgeCircleNode, RemovedBool)] = []
    
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
        
        circleLeftCntLabel = SKLabelNode(text: "\(circleLeftCnt)")
        circleLeftCntLabel.fontSize = 50
        circleLeftCntLabel.fontColor = AppColors.textColor
        circleLeftCntLabel.position = CGPointMake(self.frame.midX, self.frame.maxY - 70)
        self.addChild(circleLeftCntLabel)
        
        throwableArea = SKShapeNode(rectOfSize: CGSizeMake(self.frame.maxX, 100))
        throwableArea.fillColor = AppColors.maskBlackColor
        throwableArea.position = CGPointMake(self.frame.midX, self.frame.maxY - 48.0)
        self.addChild(throwableArea)
        
        choicesArea = SKShapeNode(rectOfSize: CGSizeMake(self.frame.maxX, 100))
        choicesArea.fillColor = AppColors.maskMainColor
        choicesArea.position = CGPointMake(self.frame.midX, self.frame.minY + 50.0)
        self.addChild(choicesArea)
        
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
        
        circleBumperC = SKShapeNode(circleOfRadius: 20.0)
        circleBumperC.fillColor = AppColors.bumperColor
        circleBumperC.position = CGPointMake(self.frame.midX - 60, self.frame.midY + 100)
        circleBumperC.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        circleBumperC.physicsBody?.dynamic = false
        circleBumperC.physicsBody?.restitution = -0.2
        self.addChild(circleBumperC)
        
        circleBumperD = SKShapeNode(circleOfRadius: 20.0)
        circleBumperD.fillColor = AppColors.bumperColor
        circleBumperD.position = CGPointMake(self.frame.midX + 60, self.frame.midY + 100)
        circleBumperD.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        circleBumperD.physicsBody?.dynamic = false
        circleBumperD.physicsBody?.restitution = -0.2
        self.addChild(circleBumperD)
        
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
        leftLabel.position = CGPointMake((self.frame.midX + self.frame.midX - 217) / 2, self.frame.minY + 37)
        self.addChild(leftLabel)
        
        rightLabel = SKLabelNode(text:"\(rightCnt)")
        rightLabel.fontSize = 50
        rightLabel.fontColor = AppColors.textColor
        rightLabel.position = CGPointMake((self.frame.midX + self.frame.midX - 217) / 2 + (self.frame.midX - (self.frame.midX - 217)), self.frame.minY + 37)
        self.addChild(rightLabel)
        
        choicesALabel = SKLabelNode(text:"\(problem.choicesA)")
        choicesALabel.fontSize = 20
        choicesALabel.fontColor = AppColors.textColor
        choicesALabel.position = CGPointMake((self.frame.midX + self.frame.midX - 217) / 2, self.frame.minY + 100)
        self.addChild(choicesALabel)
        
        choicesBLabel = SKLabelNode(text:"\(problem.choicesB)")
        choicesBLabel.fontSize = 20
        choicesBLabel.fontColor = AppColors.textColor
        choicesBLabel.position = CGPointMake((self.frame.midX + self.frame.midX - 217) / 2 + (self.frame.midX - (self.frame.midX - 217)), self.frame.minY + 100)
        self.addChild(choicesBLabel)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches{
            let location = touch.locationInNode(self)
            
            if location.y < self.frame.maxY - 100 || circleLeftCnt <= 0 {
                showChoicesLabels()
                continue
            }
            
            let circle = JudgeCircleNode(circleOfRadius: 10.0)
            circle.fillColor = AppColors.ballColor
            circle.position = location
            circle.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
            circle.physicsBody?.restitution = 0.6
            self.addChild(circle as SKShapeNode)
            circles.append(circle, RemovedBool(bool: true))
            
            circleLeftCnt--
            circleLeftCntLabel.text = "\(circleLeftCnt)"
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        hideChoicesLabels()
    }
    
    func showChoicesLabels(){
        choicesALabel.hidden = false
        choicesBLabel.hidden = false
    }
    
    func hideChoicesLabels(){
        choicesALabel.hidden = true
        choicesBLabel.hidden = true
    }
    
    func update(){
        triangleBumperA.runAction(leftRotateAction)
        triangleBumperB.runAction(rightRotateAction)
        triangleBumperC.runAction(leftRotateAction)
        triangleBumperD.runAction(rightRotateAction)
        
        var cnt = 0
        
        for circle: (JudgeCircleNode, RemovedBool) in circles{
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
                    if(leftCnt >= (circleMax - 1) / 2 + 1){
                        leftLabel.fontColor = AppColors.emphasisColor
                    }
                } else {
                    rightCnt++
                    rightLabel.text = "\(rightCnt)"
                    if(rightCnt >= (circleMax - 1) / 2 + 1){
                        rightLabel.fontColor = AppColors.emphasisColor
                    }
                }
                self.removeChildrenInArray([circle.0])
                circle.1.bool = false
                circleFalledCnt++
                
                if circleFalledCnt >= circleMax {
                    var choicesText: NSString = ""
                    if leftCnt > rightCnt {
                        choicesText = problem.choicesA
                    } else {
                        choicesText = problem.choicesB
                    }
                    launchFinishAlert(choicesText)
                }
            }
            cnt++
        }
    }
    
    func launchFinishAlert(choicesText: NSString){
        let myAlert = UIAlertController(title: "決定しました！", message: "\(choicesText)", preferredStyle: .Alert)
        let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
            self.launchTweetDialog("\(self.problem.problem) という悩みを \(choicesText) で解決！ #lifebranch")
        }
        myAlert.addAction(myOkAction)
        self.view?.window?.rootViewController?.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func launchTweetDialog(tweetText: NSString){
        let myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        myComposeView.setInitialText(tweetText)
        myComposeView.completionHandler = { hanlder in
            let titleScene = TitleScene(size: self.scene!.size)
            
            let transitionEffect = SKTransition.fadeWithDuration(0.5)
            
            titleScene.size = self.frame.size
            
            titleScene.scaleMode = .AspectFill
            
            self.view?.presentScene(titleScene)
        }
        self.view?.window?.rootViewController?.presentViewController(myComposeView, animated: true, completion: nil)
    }
}

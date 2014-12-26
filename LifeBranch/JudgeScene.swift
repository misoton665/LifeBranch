//
//  JudgeScene.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/19.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import SpriteKit
import Social

class JudgeScene: SKScene, JudgeCircleFalledDelegate{
    
    var _problem: Problem = Problem()
    
    // 壁バンパーの厚み
    private let wallThickness: CGFloat = 10.0
    private let throwableAreaLength: CGFloat = 100.0
    
    private var circleLeftCntLabel: SKLabelNode!
    private var throwableArea: SKShapeNode!
    private var choicesArea: SKShapeNode!
    
    // バンパー
    private var circleBumperA: Bumper!
    private var circleBumperB: Bumper!
    private var circleBumperC: Bumper!
    private var circleBumperD: Bumper!
    private var triangleBumperA: Bumper!
    private var triangleBumperB: Bumper!
    private var triangleBumperC: Bumper!
    private var triangleBumperD: Bumper!
    private var wallBumperA: Bumper!
    private var wallBumperB: Bumper!
    private var wallBumperC: Bumper!
    private var wallBumperD: Bumper!
    
    // それぞれの選択肢に落ちた球の数
    private var leftLabel: SKLabelNode!
    private var rightLabel: SKLabelNode!
    
    // 選択肢の内容ラベル
    private var choicesALabel: SKLabelNode!
    private var choicesBLabel: SKLabelNode!
    
    // 球のカウント
    // 左側に落ちた球の数
    private var leftCnt: Int = 0
    // 右側に落ちた球の数
    private var rightCnt: Int = 0
    // まだ出していない球の数
    private var circleLeftCnt: Int = 11
    // 落ちた球の数
    private var circleFalledCnt: Int = 0
    // 球の最大数
    private let circleMax: Int = 11
    
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
        
        circleLeftCntLabel = SKLabelNode(text: "\(circleLeftCnt)")
        circleLeftCntLabel.fontSize = 50
        circleLeftCntLabel.fontColor = AppColors.textColor
        circleLeftCntLabel.position = CGPointMake(self.frame.midX, self.frame.maxY - 70)
        self.addChild(circleLeftCntLabel)
        
        throwableArea = SKShapeNode(rectOfSize: CGSizeMake(self.frame.maxX, throwableAreaLength))
        throwableArea.fillColor = AppColors.maskBlackColor
        throwableArea.position = CGPointMake(self.frame.midX, self.frame.maxY - (throwableAreaLength / 2) + 2.0)
        self.addChild(throwableArea)
        
        choicesArea = SKShapeNode(rectOfSize: CGSizeMake(self.frame.maxX, 100))
        choicesArea.fillColor = AppColors.maskMainColor
        choicesArea.position = CGPointMake(self.frame.midX, self.frame.minY + 50.0)
        self.addChild(choicesArea)
        
        circleBumperA = Bumper(parentScene: self, circlePos: (self.frame.midX - 120, self.frame.midY + 200), circleRadius: 24.0)
        circleBumperA.restitution = -0.2
        circleBumperA.addToScene()
        
        circleBumperB = Bumper(parentScene: self, circlePos: (self.frame.midX + 120, self.frame.midY + 200), circleRadius: 24.0)
        circleBumperB.restitution = -0.2
        circleBumperB.addToScene()
        
        circleBumperC = Bumper(parentScene: self, circlePos: (self.frame.midX - 60, self.frame.midY + 100), circleRadius: 20.0)
        circleBumperC.restitution = -0.2
        circleBumperC.addToScene()
        
        circleBumperD = Bumper(parentScene: self, circlePos: (self.frame.midX + 60, self.frame.midY + 100), circleRadius: 20.0)
        circleBumperD.restitution = -0.2
        circleBumperD.addToScene()
        
        var halfLength: CGFloat = 30.0
        
        triangleBumperA = Bumper(parentScene: self, trianglePos: (self.frame.midX - 40.0,self.frame.midY), triangleLength: 60.0, rotatable: true, rotateDegree: 36.0)
        triangleBumperA.restitution = 1.2
        triangleBumperA.addToScene()
        
        triangleBumperB = Bumper(parentScene: self, trianglePos: (self.frame.midX + 40.0,self.frame.midY), triangleLength: 60.0, rotatable: true, rotateDegree: -36.0)
        triangleBumperB.restitution = 1.2
        triangleBumperB.addToScene()
        
        halfLength = 20.0
        
        triangleBumperC = Bumper(parentScene: self, trianglePos: (self.frame.midX - 160, self.frame.midY - 160), triangleLength: 40.0, rotatable: true, rotateDegree: 36.0)
        triangleBumperC.addToScene()
        
        triangleBumperD = Bumper(parentScene: self, trianglePos: (self.frame.midX + 160, self.frame.midY - 160), triangleLength: 40.0, rotatable: true, rotateDegree: -36.0)
        triangleBumperD.addToScene()
        
        wallBumperA = Bumper(parentScene: self, rectPos: (self.frame.midX - 100, self.frame.midY - 100), rectSize: (100.0, wallThickness))
        wallBumperA.degree = -30
        wallBumperA.restitution = 1.0
        wallBumperA.addToScene()
        
        wallBumperB = Bumper(parentScene: self, rectPos: (self.frame.midX + 100, self.frame.midY - 100), rectSize: (100.0, wallThickness))
        wallBumperB.degree = 30
        wallBumperB.restitution = 1.0
        wallBumperB.addToScene()
        
        wallBumperC = Bumper(parentScene: self, rectPos: (self.frame.midX - 173, self.frame.midY + 20), rectSize: (80.0, wallThickness))
        wallBumperC.degree = -10
        wallBumperC.addToScene()
        
        wallBumperD = Bumper(parentScene: self, rectPos: (self.frame.midX + 173, self.frame.midY + 20), rectSize: (80.0, wallThickness))
        wallBumperD.degree = 10
        wallBumperD.addToScene()
        
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
        
        let choicesBorderLine = SKShapeNode(points: &choicesLinePoints, count: UInt(choicesLinePoints.count))
        choicesBorderLine.strokeColor = AppColors.mainColor
        choicesBorderLine.physicsBody = SKPhysicsBody(edgeFromPoint: choicesLinePoints[0], toPoint: choicesLinePoints[1])
        self.addChild(choicesBorderLine)
        
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
            
            //
            if location.y < self.frame.maxY - throwableAreaLength || circleLeftCnt <= 0 {
                showChoicesLabels()
                continue
            }
            
            let circle = JudgeCircleNode(parentScene: self, position: (location.x, location.y), fallBorder: 6)
            circle.delegate = self
            circle.addToScene()
            
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
            self.transitionTitleScene()
        }
        self.view?.window?.rootViewController?.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    func transitionTitleScene(){
        let titleScene = TitleScene(size: self.scene!.size)
        let transitionEffect = SKTransition.fadeWithDuration(0.5)
        titleScene.size = self.frame.size
        titleScene.scaleMode = .AspectFill
        self.view?.presentScene(titleScene)
    }
    
    func judgeCircleFalled(falledNode: JudgeCircleNode){
        if(falledNode.frame.midX < self.frame.midX){
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
        self.removeChildrenInArray([falledNode])
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
}

//
//  GameScene.swift
//  LifeBranch
//
//  Created by misoton on 2014/12/10.
//  Copyright (c) 2014年 misoton. All rights reserved.
//

import SpriteKit
import UIKit

class TitleScene: SKScene, UITextFieldDelegate {
    
    enum Tag: Int{
        case ProglemTag = 1,
        ChoicesA,
        ChoicesB
    }
    
    var problem: Problem = Problem()
    
    let titleLabel: UILabel = UILabel()
    let problemLabel: UILabel = UILabel()
    let problemTextField: UITextField = UITextField()
    let choicesLabel: UILabel = UILabel()
    let choicesATextField: UITextField = UITextField()
    let choicesBTextField: UITextField = UITextField()
    let solutionLabel: UILabel = UILabel()
    let myButton = UIButton()
    
    var uiSubViews : [UIView] = []
    
    override func didMoveToView(view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        self.backgroundColor = AppColors.backgroundColor
        
        titleLabel.frame = CGRectMake(0, 0, 300, 60)
        titleLabel.text = "LifeBranch!!"
        titleLabel.layer.position = CGPoint(x: self.view!.bounds.width/2.0, y: 90)
        titleLabel.textColor = AppColors.textColor
        titleLabel.textAlignment = NSTextAlignment.Center
        let font: UIFont = UIFont.systemFontOfSize(42.0)
        titleLabel.font = font
        self.view?.addSubview(titleLabel)
        
        problemTextField.frame = CGRectMake(0, 0, 300, 60)
        problemTextField.placeholder = "今日の夕飯どうしよう？"
        problemTextField.delegate = self
        problemTextField.layer.masksToBounds = true
        problemTextField.layer.cornerRadius = 4.0
        problemTextField.borderStyle = UITextBorderStyle.RoundedRect
        problemTextField.layer.borderColor = AppColors.mainColor.CGColor
        problemTextField.layer.borderWidth = 1.0
        problemTextField.layer.position = CGPoint(x:self.view!.bounds.width/2.0,y:200)
        problemTextField.tag = Tag.ProglemTag.rawValue
        self.view?.addSubview(problemTextField)
        
        problemLabel.frame = CGRectMake(0, 0, 300, 40)
        problemLabel.text = "という悩みを"
        problemLabel.textColor = AppColors.textColor
        problemLabel.layer.position = CGPoint(x: self.view!.bounds.width/2.0, y: 250)
        self.view?.addSubview(problemLabel)
        
        choicesATextField.frame = CGRectMake(0, 0, 300, 60)
        choicesATextField.placeholder = "外に食べに行く"
        choicesATextField.delegate = self
        choicesATextField.layer.masksToBounds = true
        choicesATextField.layer.cornerRadius = 4.0
        choicesATextField.borderStyle = UITextBorderStyle.RoundedRect
        choicesATextField.layer.borderColor = AppColors.mainColor.CGColor
        choicesATextField.layer.borderWidth = 1.0
        choicesATextField.layer.position = CGPoint(x:self.view!.bounds.width/2.0,y:330)
        choicesATextField.tag = Tag.ChoicesA.rawValue
        self.view?.addSubview(choicesATextField)
        
        choicesLabel.frame = CGRectMake(0, 0, 300, 40)
        choicesLabel.text = "または"
        choicesLabel.layer.position = CGPoint(x: self.view!.bounds.width/2.0, y: 380)
        choicesLabel.textColor = AppColors.textColor
        self.view?.addSubview(choicesLabel)
        
        choicesBTextField.frame = CGRectMake(0, 0, 300, 60)
        choicesBTextField.placeholder = "自炊して節約する"
        choicesBTextField.delegate = self
        choicesBTextField.layer.masksToBounds = true
        choicesBTextField.layer.cornerRadius = 4.0
        choicesBTextField.borderStyle = UITextBorderStyle.RoundedRect
        choicesBTextField.layer.borderColor = AppColors.mainColor.CGColor
        choicesBTextField.layer.borderWidth = 1.0
        choicesBTextField.layer.position = CGPoint(x:self.view!.bounds.width/2.0,y:430)
        choicesBTextField.tag = Tag.ChoicesB.rawValue
        self.view?.addSubview(choicesBTextField)
        
        solutionLabel.frame = CGRectMake(0, 0, 300, 40)
        solutionLabel.text = "で解決します"
        solutionLabel.layer.position = CGPoint(x: self.view!.bounds.width/2.0 + 200, y: 480)
        solutionLabel.textColor = AppColors.textColor
        self.view?.addSubview(solutionLabel)
        
        myButton.frame = CGRectMake(0,0,300,40)
        myButton.backgroundColor = AppColors.mainColor
        myButton.layer.masksToBounds = true
        myButton.setTitle("決定", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.setTitle("決定", forState: UIControlState.Highlighted)
        myButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        myButton.layer.cornerRadius = 4.0
        myButton.layer.position = CGPoint(x: self.view!.bounds.width/2.0, y: 560)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view?.addSubview(myButton)
        
        uiSubViews = [titleLabel, problemLabel, problemTextField, choicesLabel, choicesATextField, choicesBTextField, myButton, solutionLabel]
    }
    
    func onClickMyButton(sender : UIButton){
        if(problem.hasEmpty()){
            let myAlert = UIAlertController(title: "空欄の場所があります", message: "全ての空欄を埋めてください", preferredStyle: .Alert)
            let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
                println("Action OK!!")
            }
            myAlert.addAction(myOkAction)
            self.view?.window?.rootViewController?.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        for i in uiSubViews{
            i.hidden = true
        }
        
//        problem.problem = "Sample Problem"
//        problem.choicesA = "Sample Choices A"
//        problem.choicesB = "Sample Choices B"
        
        let judgeScene = JudgeScene(size: self.scene!.size)
        
        let transitionEffect = SKTransition.fadeWithDuration(0.5)
        
        judgeScene.size = self.frame.size
        
        judgeScene.scaleMode = .AspectFill
        
        judgeScene.problem = problem
        
        self.view?.presentScene(judgeScene)
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        println("textFieldDidBeginEditing:" + textField.text)
        switch(textField.tag){
        case Tag.ProglemTag.rawValue:
            problem.problem = textField.text
            
        case Tag.ChoicesA.rawValue:
            problem.choicesA = textField.text
            
        case Tag.ChoicesB.rawValue:
            problem.choicesB = textField.text
        default:
            println("textFieldShouldEndEditing:" + "default")
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textFieldShouldEndEditing:" + textField.text)
        switch(textField.tag){
        case Tag.ProglemTag.rawValue:
            problem.problem = textField.text
            
        case Tag.ChoicesA.rawValue:
            problem.choicesA = textField.text
            
        case Tag.ChoicesB.rawValue:
            problem.choicesB = textField.text
        default:
            println("textFieldShouldEndEditing:" + "default")
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

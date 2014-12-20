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
    
    override func didMoveToView(view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        self.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.0)
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 300, 60))
        titleLabel.text = "LifeBranch!!"
        titleLabel.layer.position = CGPoint(x: self.view!.bounds.width/2.0, y: 100)
        titleLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        titleLabel.textAlignment = NSTextAlignment.Center
        let font: UIFont = UIFont.systemFontOfSize(42.0)
        titleLabel.font = font
        self.view?.addSubview(titleLabel)
        
        let QuestionTextField: UITextField = UITextField(frame: CGRectMake(0,0,300,60))
        QuestionTextField.placeholder = "e.g.)今日の夕食どうしよう？"
        QuestionTextField.delegate = self
        QuestionTextField.layer.masksToBounds = true
        QuestionTextField.layer.cornerRadius = 4.0
        QuestionTextField.borderStyle = UITextBorderStyle.RoundedRect
        QuestionTextField.layer.borderColor = UIColor(red: 1.0, green: 0.498, blue: 0.314, alpha: 0.9).CGColor
        QuestionTextField.layer.borderWidth = 1.0
        QuestionTextField.layer.position = CGPoint(x:self.view!.bounds.width/2,y:240)
        self.view?.addSubview(QuestionTextField)
        
        let choicesATextField: UITextField = UITextField(frame: CGRectMake(0,0,300,60))
        choicesATextField.placeholder = "e.g.)外に食べに行く"
        choicesATextField.delegate = self
        choicesATextField.layer.masksToBounds = true
        choicesATextField.layer.cornerRadius = 4.0
        choicesATextField.borderStyle = UITextBorderStyle.RoundedRect
        choicesATextField.layer.borderColor = UIColor(red: 1.0, green: 0.498, blue: 0.314, alpha: 0.9).CGColor
        choicesATextField.layer.borderWidth = 1.0
        choicesATextField.layer.position = CGPoint(x:self.view!.bounds.width/2,y:360)
        self.view?.addSubview(choicesATextField)
        
        let choicesBTextField: UITextField = UITextField(frame: CGRectMake(0, 0, 300, 60))
        choicesBTextField.placeholder = "e.g.)自炊で節約する"
        choicesBTextField.delegate = self
        choicesBTextField.layer.masksToBounds = true
        choicesBTextField.layer.cornerRadius = 4.0
        choicesBTextField.borderStyle = UITextBorderStyle.RoundedRect
        choicesBTextField.layer.borderColor = UIColor(red: 1.0, green: 0.498, blue: 0.314, alpha: 0.9).CGColor
        choicesBTextField.layer.borderWidth = 1.0
        choicesBTextField.layer.position = CGPoint(x:self.view!.bounds.width/2,y:430)
        self.view?.addSubview(choicesBTextField)
        
        let myButton = UIButton()
        myButton.frame = CGRectMake(0,0,300,40)
        myButton.backgroundColor = UIColor(red: 1.0, green: 0.498, blue: 0.314, alpha: 0.8)
        myButton.layer.masksToBounds = true
        myButton.setTitle("Add Block", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.setTitle("Done", forState: UIControlState.Highlighted)
        myButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        myButton.layer.cornerRadius = 4.0
        myButton.layer.position = CGPoint(x: self.view!.bounds.width/2.0, y: 540)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view?.addSubview(myButton)
    }
    
    func onClickMyButton(sender : UIButton){
        
        let rect = SKShapeNode(circleOfRadius: 15.0)
        rect.fillColor = UIColor.redColor()
        rect.position = CGPointMake(self.frame.midX, self.frame.midY)
        rect.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
        
        self.addChild(rect)
    }
    
    /*
    UITextFieldが編集された直後に呼ばれる.
    */
    func textFieldDidBeginEditing(textField: UITextField){
        println("textFieldDidBeginEditing:" + textField.text)
    }
    
    /*
    UITextFieldが編集終了する直前に呼ばれる.
    */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textFieldShouldEndEditing:" + textField.text)
        
        return true
    }
    
    /*
    改行ボタンが押された際に呼ばれる.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

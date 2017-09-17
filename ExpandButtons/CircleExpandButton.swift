//
//  ExpandableButtonLauncher.swift
//  Drememe
//
//  Created by John Jin Woong Kim on 8/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import Foundation
import UIKit


class CircleExpandButton: UIView {
    // change this to false to remove the green border around view, but I found it helpful to
    //  debug and get a good fit when you need visual aid
    let debugFlag = true
    
    var currButtonIndex = -1
    // holds the buttons themselves
    
    // -1 = neither
    //  0 = unexpanded
    //  1 = expanded
    var currState = -1
    
    // origin point for the unexpanded
    var mainCenterOrigin:CGPoint!
    
    // var to save the cgrect of the unexpanded view, AKA cgpoint 0 and its regular size params
    var mainFrame1:CGRect!
    
    // saving the original init() frame param's width and height divided by 2 since I use it so much
    var width2: CGFloat = 0
    var height2: CGFloat = 0
        
    // the view needs to be expanded as well for the subbuttons to
    //  recieve onPress actions
    var expandedView:CGRect!
    //  default cgrect frame
    var unexpandedView:CGRect!
    
    // center cg point for the x cancel buttons
    var centerCancelOrigin: CGPoint!
    
    // Array that will hold the uibuttons that will
    //   be shown once the mainButton is pressed and expanded
    var expandedButtons = [UIButton]()
    
    var margin:CGFloat = 0
    var startDegree:CGFloat = 0
    
    lazy var mainButton0: UIButton = {
        let b = UIButton()
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.white.cgColor
        b.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        b.imageView?.tintColor = UIColor.white
        b.setImage(UIImage(imageLiteralResourceName: "plus").withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = UIColor.black
        b.addTarget(self, action: #selector(onMainButton(sender:)), for: .touchUpInside)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        width2 = frame.width/2
        height2 = frame.height/2
        mainCenterOrigin = CGPoint(x: 0, y: 0)
        mainFrame1 = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 60) )
        // frame for the expanded view, 3 times bigger and origin shifted 1.5
        expandedView = CGRect(x: (frame.origin.x+width2)-(1.5*frame.width), y: (frame.origin.y+width2)-(1.5*frame.width), width: frame.width*3, height: frame.height*3)
        // origin of the cancel button in the middle of the expanded view
        centerCancelOrigin = CGPoint(x: (expandedView.width/2)-frame.width/2, y: (expandedView.width/2)-frame.width/2)
        // saving original frame
        unexpandedView = frame
        
        if debugFlag == true{
            layer.borderWidth = 1
            layer.borderColor = UIColor.green.cgColor
        }
        
    }

    func setupButton(numOfButtons:Int, margin:CGFloat, startDegree:CGFloat){
        self.margin = margin
        self.startDegree = startDegree
        
        var index = 0
        for _ in 0..<numOfButtons{
            let b = UIButton()
            b.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.width, height: frame.height))
            b.titleLabel?.textColor = UIColor.white
            b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            b.setTitle(String(index), for: .normal)
            b.layer.cornerRadius = width2
            b.layer.borderWidth = 1
            b.layer.borderColor = UIColor.black.cgColor
            b.backgroundColor = UIColor.black
            b.isUserInteractionEnabled = false
            b.addTarget(self, action: #selector(onSubButton(sender:)), for: .touchUpInside)
            expandedButtons.append(b)
            addSubview(b)
            index += 1
        }
        
        mainButton0.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.width, height: frame.height))
        
        addSubview(mainButton0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onMainButton(sender: UIButton!) {
        // if currstate is -1, unexpanded
        // else, is expanded
        if currState == -1{
            
            currState = 1
            // ANIMATION 1
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                // moving dual buttons to center
                self.mainButton0.frame.origin = self.mainCenterOrigin

            }, completion: { (completedAnimation) in
                // ANIMATION 2
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    // shrinking and updating origin based on size
                    self.mainButton0.layer.cornerRadius = self.width2
                    self.mainButton0.frame.origin = self.centerCancelOrigin
                    self.mainButton0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
                    self.frame = self.expandedView
                    // expand arrows
                    let constant:CGFloat = CGFloat(360/self.expandedButtons.count)
                    var scaler:CGFloat = 0.0
                    for b in self.expandedButtons{
                        b.frame.origin = self.degreeToOrigin(degree: scaler*(constant))
                        scaler += 1
                    }
                }, completion: { (completedAnimation) in
                self.enableButtons(flag: 1)
                })// 2 FIN
                
            })// 1 FIN
        }else{
            // ANIMATION 1
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                // reset the mainbutton from x to whatever it was before

                // turn off buttons
                self.enableButtons(flag: 0)
                
                // spin, reset corners, and move back into original place
                self.mainButton0.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi*2)/4))
                self.mainButton0.layer.cornerRadius = 10
                self.frame = self.unexpandedView
                
                // contract all the expanded buttons
                for b in self.expandedButtons{
                    b.frame.origin = CGPoint(x: 0, y: 0)
                }
                
                // move the buttons back in the center of the newly shrinked view
                self.mainButton0.frame = self.mainFrame1
             }, completion: { (completedAnimation) in
            })// 1 FIN
         currState = -1
        }

    }
    
    func onSubButton(sender: UIButton!) {
        var j = 0
        for b in self.expandedButtons{
            if b == sender{
                // currbuttonindex is the index for expandedButtons that has been pressed
                currButtonIndex = j
                break
            }
            j+=1
        }
    }
    
    func enableButtons(flag: Int){
        // flag == 0 disables all subbuttons from user touches
        // flag == 1 enables them
        for b in expandedButtons{
            if flag == 0{
                b.isUserInteractionEnabled = false
            }else{
                b.isUserInteractionEnabled = true
            }
        }
    }
    
    func degreeToOrigin(degree: CGFloat)-> CGPoint{
        // Convert from degrees to radians via multiplication by PI/180
        let d:CGFloat = self.startDegree+degree
        let deg:CGFloat = (d*CGFloat.pi)/180.0
        let rad:CGFloat = ((unexpandedView.width)+margin)
        let x:CGFloat = (rad * cos(deg))+(expandedView.width/2)
        let y:CGFloat = (rad * sin(deg))+(expandedView.width/2)
        return CGPoint(x: x-width2, y: y-width2)
    }
    
    
    
}

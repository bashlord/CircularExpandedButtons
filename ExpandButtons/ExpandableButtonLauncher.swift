//
//  ExpandableButtonLauncher.swift
//  Drememe
//
//  Created by John Jin Woong Kim on 8/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import Foundation
import UIKit


class ExpandableButtonLauncher: UIView {
    let cellId = "cellId"
    
    // rows of 5
    let imageNames = ["1","2-1", "2-2", "3", "4", "custom"]
    
    // 0 == default unexpanded state
    // 1 == expanded state, showing camera/gallery options
    var uploadFlag = 0
    var expandedButtonWidth = 0
    
    // height of imageview
    var imageviewHeight = 0
    // x y origin of the sub buttons
    var suborigin:CGPoint = CGPoint()
    
    var currButtonIndex = -1
    // holds the buttons themselves

    var keyWindowFrame:CGRect!
    var t0:CGFloat = 0
    var t1:CGFloat = 0
    var t2:CGFloat = 0
    var offset:CGFloat = 0
    
    var style1_w0:CGFloat = 0
    var style1_w1:CGFloat = 0

    var radius_offset:CGFloat = 0
    var diagonal_h:CGFloat = 0
    var diagonal_w:CGFloat = 0
    var animate2MainButtonScale:CGFloat = 20
    
    var animationStyle = 0
    
    lazy var mainButton: UIButton = {
        let b = UIButton()
        b.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        b.setImage(UIImage(imageLiteralResourceName: "plus"), for: UIControlState.normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = UIColor.white
        b.addTarget(self, action: #selector(onMainButton(sender:)), for: .touchUpInside)
        return b
    }()
    
    // Array that will hold the uibuttons that will
    //   be shown once the mainButton is pressed and expanded
    var expandedButtons = [UIButton]()
    // flag for which state the expand is in
    var stateFlag = 0
    
    var memeEditorController: MemeEditorController?
    
    var flag: Int! = -1// 0 for left, 1 for right
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let window = UIApplication.shared.keyWindow {
            self.keyWindowFrame = window.frame
            //((self.keyWindowFrame.height)-96) - ((((self.keyWindowFrame.height)*5)!/6)-(self.mainButton.frame.height/2))
            t0 = ((self.keyWindowFrame.height)-96)
            t1 = (((self.keyWindowFrame.height)*5)/6)
            t2 = (self.mainButton.frame.height/2)
            offset = (t0-(t1-t2))
            print("ExpandableButtonLauncher::  offset ", offset)
            //self.backgroundColor = UIColor.black
            self.layer.cornerRadius = 10
            self.expandedButtonWidth = Int(window.frame.width/6)
            self.imageviewHeight = Int(window.frame.size.height*(2/3))
            for name in imageNames{
                let b = UIButton()
                b.frame = CGRect(origin: .zero, size: CGSize(width: self.expandedButtonWidth, height: self.expandedButtonWidth))
                b.setImage(UIImage(imageLiteralResourceName: name), for: UIControlState.normal)
                b.layer.cornerRadius = 10
                b.layer.borderWidth = 1
                b.layer.borderColor = UIColor.black.cgColor
                b.backgroundColor = UIColor.gray
                b.isUserInteractionEnabled = false
                b.addTarget(self, action: #selector(onSubButton(sender:)), for: .touchUpInside)
                expandedButtons.append(b)
                //addSubview(b)
            }
            expandedButtons[expandedButtons.count-1].backgroundColor = UIColor.black
            addSubview(mainButton)
            let woff:CGFloat = (window.frame.width-mainButton.frame.width)/4
            let w_half:CGFloat = window.frame.width/2
            let main_half:CGFloat = mainButton.frame.width/2
            style1_w0 = w_half-(main_half+woff+CGFloat(self.expandedButtonWidth/2))
            style1_w1 = w_half+(main_half+woff-CGFloat(self.expandedButtonWidth/2))
        }
    }
    
    func setFlag(flag: Int){
        self.flag = flag
        setupButton()
    }
    
    func setupButton(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onMainButton(sender: UIButton!) {
        if stateFlag == 0{
            var i = 0
            var dur = 0.1
            if animationStyle == 0{
                dur = 0
            }
            UIView.animate(withDuration: dur, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                //self.mainButton.frame.origin.y -= self.offset
                if self.animationStyle != 0{
                    self.frame.origin.y -= self.offset
                }
                
            }) { (completed: Bool) in
                print("MainButton origin after move",self.mainButton.frame.origin.x,self.mainButton.frame.origin.y)
            // EXPAND all sub button views
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                if self.animationStyle == 2{
                    //self.mainButton.frame.origin.x += self.animate2MainButtonScale/2
                    //self.mainButton.frame.origin.y += self.animate2MainButtonScale/2
                    //self.mainButton.frame.size.width -= self.animate2MainButtonScale
                    //self.mainButton.frame.size.height -= self.animate2MainButtonScale
                    
                    self.frame.origin.x += self.animate2MainButtonScale/2
                    self.frame.origin.y += self.animate2MainButtonScale/2
                    self.frame.size.width -= self.animate2MainButtonScale
                    self.frame.size.height -= self.animate2MainButtonScale
                    self.mainButton.frame.size.width -= self.animate2MainButtonScale
                    self.mainButton.frame.size.height -= self.animate2MainButtonScale
                }
                
                self.mainButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
                self.mainButton.layer.cornerRadius = 40
                self.mainButton.backgroundColor = UIColor.white
                self.mainButton.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi*3)/4))
                //self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
                self.layer.cornerRadius = 40
                //self.backgroundColor = UIColor.white
                //self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi*3)/4))
                
                
                self.expandedButtons[self.expandedButtons.count-1].backgroundColor = UIColor.gray
                
                if self.animationStyle == 0{
                    for b in self.expandedButtons{
                        //b.frame.origin.y = CGFloat(self.imageviewHeight+1)
                        b.isUserInteractionEnabled = true
                        b.frame.origin.y = CGFloat((self.memeEditorController?.uploadedImageView.frame.height)!)
                        b.frame.origin.x = CGFloat(self.expandedButtonWidth*i)
                        //print("button at index ", i, " x y ", b.frame.origin.x, b.frame.origin.y)
                        i+=1
                    }
                }else if self.animationStyle == 1{
                    self.memeEditorController?.toggleBackSaveButtons(f: 0)
                    self.expandedButtons[0].frame.origin.y = CGFloat((self.memeEditorController?.uploadedImageView.frame.height)!)
                    self.expandedButtons[3].frame.origin.y = CGFloat((self.memeEditorController?.uploadedImageView.frame.height)!)
                    self.expandedButtons[0].frame.origin.x = self.style1_w0
                    self.expandedButtons[3].frame.origin.x = self.style1_w1
                        
                    self.expandedButtons[1].frame.origin.y = CGFloat(self.keyWindowFrame.height*(7/9))
                    self.expandedButtons[4].frame.origin.y = CGFloat(self.keyWindowFrame.height*(7/9))
                    self.expandedButtons[1].frame.origin.x = self.style1_w0
                    self.expandedButtons[4].frame.origin.x = self.style1_w1
                    
                    self.expandedButtons[2].frame.origin.y = CGFloat(self.keyWindowFrame.height*(8/9))
                    self.expandedButtons[5].frame.origin.y = CGFloat(self.keyWindowFrame.height*(8/9))
                    self.expandedButtons[2].frame.origin.x = self.style1_w0
                    self.expandedButtons[5].frame.origin.x = self.style1_w1
                    
                    for b in self.expandedButtons{
                        //b.frame.origin.y = CGFloat(self.imageviewHeight+1)
                        b.isUserInteractionEnabled = true
                    }
                }else if self.animationStyle == 2{
                    self.memeEditorController?.toggleBackSaveButtons(f: 0)
                    
                    self.expandedButtons[0].frame.origin.y -= self.radius_offset
                    self.expandedButtons[5].frame.origin.y += self.radius_offset
                    
                    self.expandedButtons[1].frame.origin.x -= (self.diagonal_w)
                    self.expandedButtons[2].frame.origin.x -= (self.diagonal_w)
                    self.expandedButtons[1].frame.origin.y -= (self.diagonal_h)
                    self.expandedButtons[2].frame.origin.y += (self.diagonal_h)
                    
                    self.expandedButtons[3].frame.origin.x += (self.diagonal_w)
                    self.expandedButtons[4].frame.origin.x += (self.diagonal_w)
                    self.expandedButtons[3].frame.origin.y -= (self.diagonal_h)
                    self.expandedButtons[4].frame.origin.y += (self.diagonal_h)
                    
                    
                    
                    for b in self.expandedButtons{
                        //b.frame.origin.y = CGFloat(self.imageviewHeight+1)
                        b.isUserInteractionEnabled = true
                    }
                }
            
            }) { (completed: Bool) in }
                }
            self.stateFlag = 1
                  }else{
            // contract all sub button views
            UIView.animate(withDuration: 0.32, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                self.mainButton.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi*2)/4))
                //self.mainButton.transform = CGAffineTransform(rotationAngle: -CGFloat((Double.pi/4)))
                self.layer.cornerRadius = 10
                self.mainButton.layer.cornerRadius = 10
                self.mainButton.backgroundColor = UIColor.gray
                self.mainButton.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi*1)/4))
                self.mainButton.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi*0)/4))
                
                if self.animationStyle == 2{
                    //self.mainButton.frame.origin.x -= self.animate2MainButtonScale/2
                    //self.mainButton.frame.origin.y -= self.animate2MainButtonScale/2
                    //self.mainButton.frame.size.width += self.animate2MainButtonScale
                    //self.mainButton.frame.size.height += self.animate2MainButtonScale
                    
                    self.frame.origin.x -= self.animate2MainButtonScale/2
                    self.frame.origin.y -= self.animate2MainButtonScale/2
                    self.frame.size.width += self.animate2MainButtonScale
                    self.frame.size.height += self.animate2MainButtonScale
                    self.mainButton.frame.size.width += self.animate2MainButtonScale
                    self.mainButton.frame.size.height += self.animate2MainButtonScale
                }
                
                for b in self.expandedButtons{
                    b.isUserInteractionEnabled = false
                    b.frame.origin = self.suborigin
                }
                self.expandedButtons[self.expandedButtons.count-1].backgroundColor = UIColor.black
                
                if self.animationStyle != 0{
                    self.memeEditorController?.toggleBackSaveButtons(f: 1)
                    
                }
            }) { (completed: Bool) in

                if self.animationStyle != 0{
                
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                        self.frame.origin.y += self.offset
                    
                    }) { (completed: Bool) in }
                }
            }
            stateFlag = 0
            
        }
    }
    
    func onSubButton(sender: UIButton!) {
        var j = 0
        for b in self.expandedButtons{
            if b == sender{
                if currButtonIndex == -1{
                    memeEditorController?.onSubButton(flag: j)
                    currButtonIndex = j
                    self.expandedButtons[j].backgroundColor = UIColor.white
                }else if currButtonIndex != j{
                    self.expandedButtons[currButtonIndex].backgroundColor = UIColor.gray
                
                    memeEditorController?.onSubButton(flag: j)
                    currButtonIndex = j
                    self.expandedButtons[j].backgroundColor = UIColor.white
                }
                if currButtonIndex == 5{
                    currButtonIndex = -1
                    self.expandedButtons[j].backgroundColor = UIColor.gray
                }
                print("button at index ", j, " selected")
                break
            }
            j+=1
        }
    }
    
    func saveSubButtonOrigin(){
        self.suborigin = self.expandedButtons[0].frame.origin
        
        self.radius_offset = self.suborigin.y-(memeEditorController?.uploadedImageView.frame.height)!
        self.diagonal_h = self.radius_offset/CGFloat(2)
        self.diagonal_w = self.diagonal_h*CGFloat(sqrtf(3))
        print("saveSubButtonOrigin() radius diag", radius_offset, diagonal_h, diagonal_w)
    }
    
    func getCurrentButtonIndex()->Int{
        return currButtonIndex
    
    }
    
    
}


class ButtonCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(91, green: 14, blue: 13)
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintsWithFormat("H:[v0(\(frame.width))]", views: imageView)
        addConstraintsWithFormat("V:[v0(\(frame.height))]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
}

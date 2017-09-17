//
//  ButtonLauncher.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/14/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import Foundation
import UIKit

class Button: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class ButtonLauncher: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    // rows of 5
    
    
    // 0 == horizontal
    // 1 == vertical
    var flag: Int = 0
    // default expand direction
    // 0 == down/right
    // 1 == up/left
    var expandFlag: Int = 0
    // which state the button is in
    // 0 == unexpanded
    // 1 == expanded
    var expandState = 0
    // index of the cell that will un expand the collectionview, default 0
    var rootIndex: Int = 0
    // origin point needs to be saved since if the expand happens
    //  in the non default case, the origin must move accordingly
    var originPoint:CGPoint!
    
    var cellWidth: CGFloat = 0
    var numOfExpandedCells: Int = 2
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        cellWidth = frame.size.width
        collectionView.register(ButtonTextCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.black.cgColor
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
    }
    
    func setFlag(flag: Int, expandFlag:Int, rootIndex: Int, numOfExpanded:Int){
        self.flag = flag
        self.expandFlag = expandFlag
        self.rootIndex = rootIndex
        self.numOfExpandedCells = numOfExpanded
        setupButton()
    }
    
    func setupButton(){
        collectionView.backgroundColor = UIColor.white
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ButtonLauncher:: " ,indexPath.item)
        //navigation buttons
        if flag == 0{ // horizontal buttons
            if expandFlag == 1{// expanding leftward
                
                if expandState == 0{
                    // expand the button to show options
                    
                    expandState = 1
                    
                    self.collectionView.reloadData()
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        
                        
                        self.frame.origin.x -= (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.frame.size.width += (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                    }) { (completed: Bool) in }
                    
                }else{
                    
                    expandState = 0
                    
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                        self.frame.origin.x += (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.frame.size.width -= (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.collectionView.reloadData()
                        
                    }) { (completed: Bool) in }

                }
            }else{// expanding towrads the right
                if expandState == 0{
                    // expand the button to show options
                    
                    expandState = 1
                    
                    
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        
                        self.frame.size.width += (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.collectionView.reloadData()
                    }) { (completed: Bool) in }
                    
                }else{
                    
                    expandState = 0
                    
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                        self.frame.size.width -= (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.collectionView.reloadData()
                        
                    }) { (completed: Bool) in }
                    
                }
            }
            
        }else if flag == 1{// vertical buttons
            print("vertical flag", expandFlag)
            if expandFlag == 1{// expanding upward
                
                if expandState == 0{
                    // expand the button to show options
                    
                    expandState = 1
                    
                    self.collectionView.reloadData()
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        
                        self.frame.origin.y -= (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.frame.size.height += (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                    }) { (completed: Bool) in }
                    
                }else{
                    
                    expandState = 0
                    
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                        self.frame.origin.y += (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.frame.size.height -= (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.collectionView.reloadData()
                        
                    }) { (completed: Bool) in }
                    
                }
            }else{// expanding downward
                if expandState == 0{
                    // expand the button to show options
                    
                    expandState = 1
                    
                    
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        
                        self.frame.size.height += (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.collectionView.reloadData()
                    }) { (completed: Bool) in}
                    
                }else{
                    
                    expandState = 0
                    
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                        //self.frame.origin.x += 160
                        self.frame.size.height -= (CGFloat(self.numOfExpandedCells-1)*self.cellWidth)
                        self.collectionView.reloadData()
                        
                    }) { (completed: Bool) in }
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if expandState == 1{
            return numOfExpandedCells
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ButtonTextCell

        cell.layer.cornerRadius = cellWidth/2
        cell.layer.borderWidth = 2
        if expandState == 1{
            if indexPath.item == rootIndex{
                cell.labelView.text = "root"
                cell.layer.borderColor = UIColor.green.cgColor

            }else{
                cell.labelView.text = String(indexPath.item)
                cell.layer.borderColor = UIColor.gray.cgColor
            }
        }else{
            cell.labelView.text = "root"
            cell.layer.borderColor = UIColor.green.cgColor

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {            return CGSize(width: cellWidth, height: cellWidth)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ButtonTextCell: BaseCell {
    // in this case a label is used since I will just be using index
    //  values to label each cell, but imageViews are possible too
    /*
     let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        //iv.tintColor = UIColor.rgb(91, green: 14, blue: 13)
        return iv
    }()
     */
    
    let labelView:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
        //    imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13)
        
        }
    }
    
    override var isSelected: Bool {
        didSet {
         //   imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(labelView)
        addConstraintsWithFormat("H:[v0(\(frame.width))]", views: labelView)
        addConstraintsWithFormat("V:[v0(\(frame.height))]", views: labelView)
        
        addConstraint(NSLayoutConstraint(item: labelView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: labelView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
}

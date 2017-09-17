//
//  DataViewController.swift
//  ExpandButtons
//
//  Created by John Jin Woong Kim on 9/7/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    var keyWindowFrame:CGRect!
    
    //var expandButton0:ButtonLauncher!
    //var expandButton1: ButtonLauncher!
    var expandButton0: CircleExpandButton?
    var expandButton1: CircleExpandButton?
    var flag = -1
    /*
     lazy var uploadButton: ButtonLauncher = {
     //let b = ButtonLauncher()
     let b = ButtonLauncher(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 80)))
     b.favoritesCollectionView = self
     b.setFlag(flag: 11)
     return b
     }()
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        keyWindowFrame = UIScreen.main.bounds
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func initButtons(flag:Int){
        // feel free to add new flag calls with different parameters
        if flag == 0{
            expandButton0 = CircleExpandButton(frame: CGRect(x: 200, y: 200, width: 60, height: 60))
            expandButton0?.setupButton(numOfButtons: 5, margin: 10, startDegree: 90)
            view.addSubview(expandButton0!)
            self.flag = flag
        }else{
            expandButton1 = CircleExpandButton(frame: CGRect(x: 200, y: 200, width: 60, height: 60))
            expandButton1?.setupButton(numOfButtons: 4, margin: 0, startDegree: 0)
            view.addSubview(expandButton1!)
            self.flag = flag
        }
    }


}


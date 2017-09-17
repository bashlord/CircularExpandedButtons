//
//  BaseCell.swift
//  Drememe
//
//  Created by John Jin Woong Kim on 2/24/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    deinit{
        print("A BaseCell has been deinitialized.")
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



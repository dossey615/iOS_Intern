//
//  CustomCell.swift
//  iOS_Intern
//
//  Created by 土居将史 on 2018/05/08.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet var lblSample:UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}

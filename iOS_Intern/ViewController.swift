//
//  ViewController.swift
//  iOS_Intern
//
//  Created by 土居将史 on 2018/05/01.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let composer = TWTRComposer()
        composer.setText("おはよう")
//        composer.show(from: ViewController, completion: { result in })
        TWTRComposer().show(from: self) { _ in }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


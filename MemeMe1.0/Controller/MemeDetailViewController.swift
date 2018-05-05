//
//  MemeDetailViewController.swift
//  MemeMe1.0
//
//  Created by 秋山剛 on 2018/04/29.
//  Copyright © 2018 秋山剛. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    // MARK: Properties
    
    var meme: Memes!
    
    // MARK: Outlet
    
    @IBOutlet weak var memedImg: UIImageView!
    
    
    // MRAK: life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memedImg.image = meme.memedImage
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}


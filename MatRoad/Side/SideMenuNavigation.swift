//
//  SideMenuNavigation.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/17.
//

import UIKit
import SideMenu

class SideMenuNavigation: SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationStyle = .viewSlideOutMenuIn
        
        self.leftSide = true
        
        self.statusBarEndAlpha = 0
        
        self.presentDuration = 0.5
        
        self.dismissDuration = 0.5
        
        self.menuWidth = view.frame.width * 0.65
    }
    
    
    
    
    
    
}

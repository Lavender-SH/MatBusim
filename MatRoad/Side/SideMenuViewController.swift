//
//  SideMenuViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/17.
//

import UIKit
import SnapKit

class SideMenuViewController: BaseViewController {
    
    
    override func configureView() {
        <#code#>
    }
    override func setConstraints() {
        <#code#>
    }
    
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

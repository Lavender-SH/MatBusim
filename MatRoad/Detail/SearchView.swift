//
//  SearchView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/02.
//

import UIKit
import SnapKit

class SearchView: BaseView {
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 70
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchCell")
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = ""
        searchBar.layer.shadowColor = UIColor.clear.cgColor
        searchBar.showsCancelButton = true
        searchBar.barTintColor = .darkGray
        searchBar.searchTextField.textColor = .white
        searchBar.autocapitalizationType = .none
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            cancelButton.tintColor = .white
        }
        return searchBar
    }()
    
    
    
    override func configureView() {
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    
}

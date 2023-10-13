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
        view.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        return view
    }()
    
    lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = ""
        searchBar.layer.shadowColor = UIColor.clear.cgColor
        searchBar.showsCancelButton = true
        searchBar.barTintColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        searchBar.searchTextField.textColor = .white
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "맛집을 검색해주세요"
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            cancelButton.tintColor = .white
        }
        return searchBar
    }()
    lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "검색결과가 없습니다."
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func configureView() {
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(noResultsLabel)
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
        noResultsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}

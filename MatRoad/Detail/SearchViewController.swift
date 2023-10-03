//
//  SearchViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/02.
//

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    
    let searchView = SearchView()
    var isEnd = false
    var page = 1
    var foodManager = NetworkManager.shared
    var foodItems: [Document] = []
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.prefetchDataSource = self
        searchView.searchBar.delegate = self
        makeNavigationUI()
        //view.backgroundColor = .white

    }
    
    func loadData(query: String) {
        foodManager.searchPlaceCallRequest(query: query) { documents in
            guard let documents = documents else { return }
            self.foodItems.append(contentsOf: documents)
            self.searchView.tableView.reloadData()
        }
    }
    
    
    // MARK: - 네비게이션UI
    func makeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .gray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "맛집 검색"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - 확장: 서치바 관련 함수
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchView.searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        loadData(query: text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        foodItems.removeAll()
        searchView.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            foodItems.removeAll()
            searchView.tableView.reloadData()
        }
    }
}

// MARK: - 확장: 테이블뷰 관련 함수
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard indexPath.row < foodItems.count else {
            return UITableViewCell()
        }
        let item = foodItems[indexPath.row]
        cell.configure(with: item)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            //print("==999==", foodItems.count, start)
            guard let query = searchView.searchBar.text else { return }
            
            if foodItems.count - 1 == indexPath.row && !isEnd {
                page += 1
                
                NetworkManager.shared.searchPlaceCallRequest(query: query, page: page) { documents in
                    guard let documents = documents else { return }
                    self.foodItems.append(contentsOf: documents)
                    self.searchView.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let ReviewVC = ReviewViewController()
        //ReviewVC.modalPresentationStyle = .fullScreen
        present(ReviewVC, animated: true, completion: nil)
    }
    
    
    
    
}

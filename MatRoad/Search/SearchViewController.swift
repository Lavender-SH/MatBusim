//
//  SearchViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/02.
//

import UIKit
import SnapKit
import RealmSwift

class SearchViewController: BaseViewController {
    
    let searchView = SearchView()
    var isEnd = false
    var page = 1
    var foodManager = NetworkManager.shared
    var foodItems: [Document] = []
    deinit { NotificationCenter.default.removeObserver(self) }
    
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
        view.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        //서치화면 -> 리뷰창 닫기 -> 메인화면으로 돌아오기
        NotificationCenter.default.addObserver(self, selector: #selector(handleReviewSavedNotification), name: Notification.Name("ReviewSavedFromSearch"), object: nil)
        
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard5))
        tapGesture5.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.searchBar.becomeFirstResponder()
    }
    // MARK: - 네트워킹
    func loadData(query: String) {
        foodManager.searchPlaceCallRequest(query: query) { documents in
            guard let documents = documents else { return }
            //self.foodItems.append(contentsOf: documents)
            self.foodItems = documents
            self.searchView.noResultsLabel.isHidden = !self.foodItems.isEmpty
            self.searchView.tableView.reloadData()
        }
    }
    
    // MARK: - 네비게이션UI
    func makeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Navigation")
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "textColor") as Any,
            .font: UIFont(name: "KCC-Ganpan", size: 19.0) as Any
        ]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "맛집 검색"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard5() {
        view.endEditing(true)
    }
    
    @objc func handleReviewSavedNotification() {
        self.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
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
        searchView.noResultsLabel.isHidden = true
        searchView.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        foodItems.removeAll()
        
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            loadData(query: searchText)
        } else {
            searchView.tableView.reloadData()
        }
        if searchText.isEmpty {
            foodItems.removeAll()
            searchView.noResultsLabel.isHidden = true
            searchView.tableView.reloadData()
        }
        
    }
    
}

// MARK: - 확장: 테이블뷰 관련 함수
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foodItems.isEmpty {
            searchView.emptyImageView.isHidden = false
            searchView.emptyImageLabel.isHidden = false
        } else {
            searchView.emptyImageView.isHidden = true
            searchView.emptyImageLabel.isHidden = true
        }
        return foodItems.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard indexPath.row < foodItems.count else {
            return UITableViewCell()
        }
        let item = foodItems[indexPath.row]
        cell.configure(with: item)
        cell.backgroundColor = UIColor(named: "White")
        
        return cell
    }
    // MARK: - 페이지네이션
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
        let reviewVC = ReviewViewController()
        let selectedItem = foodItems[indexPath.row]
        
        reviewVC.placeLongitude = selectedItem.x
        reviewVC.placeLatitude = selectedItem.y
        
        // selectedItem.placeURL을 URL로 변환하면서 http를 https로 변경
        guard var urlString = selectedItem.placeURL else {
            return
        }
        if urlString.starts(with: "http://") {
            urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        }
        guard let url = URL(string: urlString) else {
            return
        }
        
        reviewVC.placeName = selectedItem.placeName
        reviewVC.placeURL = urlString
        let webviewVC = WebViewController(url: url)
        webviewVC.urlToLoad = url // URL 타입으로 전달
        
        present(reviewVC, animated: true, completion: nil)
        
        //navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}


extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITableViewCell || touch.view?.isDescendant(of: searchView.tableView) == true {
            return false
        }
        return true
    }
}

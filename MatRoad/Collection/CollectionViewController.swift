//
//  MainViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit
import RealmSwift

class CollectionViewController: BaseViewController {
    
    let mainView = CollectionView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationUI()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        
        
        
    }
    
    // MARK: - 네비게이션UI
    func makeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .darkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(reviewPlusButtonTapped))
        
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "minus.square"), style: .plain, target: self, action: #selector(reviewDeleteButtonTapped))
        
        let albumButton = UIBarButtonItem(image: UIImage(systemName: "tray"), style: .plain, target: self, action: #selector(albumButtonTapped))
        
        
        navigationItem.rightBarButtonItems = [plusButton, deleteButton]
        navigationItem.leftBarButtonItem = albumButton
        
        navigationItem.title = "MatBusim"
        
    }
    
    
    @objc func reviewPlusButtonTapped() {
        let alertController = UIAlertController(title: nil, message: "맛집을 찾으셨습니까?", preferredStyle: .actionSheet)
        
        
        let registerAction = UIAlertAction(title: "맛집 등록", style: .default) { (action) in
            // 맛집 등록 관련 코드를 여기에 작성하세요.
            
            let searchVC = SearchViewController()
            let searchNavController = UINavigationController(rootViewController: searchVC)
            searchNavController.modalPresentationStyle = .fullScreen
            self.present(searchNavController, animated: true, completion: nil)
        }
        alertController.addAction(registerAction)
        
 
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        

        self.present(alertController, animated: true, completion: nil)
    }

    
    @objc func reviewDeleteButtonTapped() {
        
    }
    
    @objc func albumButtonTapped() {
        
    }
    
    
    
    
    
    
    
    
    
}

// MARK: - 확장: 컬렉션뷰 관련 함수
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .yellow
        
        return cell
    }
    
    
}

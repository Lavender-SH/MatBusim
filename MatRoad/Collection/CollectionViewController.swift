//
//  CollectionViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher

class CollectionViewController: BaseViewController {
    
    let mainView = CollectionView()
    //Realm 관련 변수
    var reviewItems: Results<ReviewTable>!
    let realm = try! Realm()
    let repository = ReviewTableRepository()
    var notificationToken: NotificationToken?
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reviewItems 초기화
        reviewItems = repository.fetch()
        
        makeNavigationUI()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        // Realm 데이터베이스의 변경을 감지하는 옵저버를 추가
        notificationToken = reviewItems.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // 초기 데이터 로딩 시
                self?.mainView.collectionView.reloadData()
            case .update(_, _, _, _):
                // 데이터베이스 변경 시
                self?.mainView.collectionView.reloadData()
            case .error(let error):
                // 에러 발생 시
                print("Error: \(error)")
            }
        }
        
        
        print(realm.configuration.fileURL)
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
        
        navigationItem.title = "맛슐랭"
        
    }
    
    
    @objc func reviewPlusButtonTapped() {
        let alertController = UIAlertController(title: nil, message: "맛집을 찾으셨습니까?", preferredStyle: .actionSheet)
        
        
        let registerAction = UIAlertAction(title: "맛집 등록", style: .default) { (action) in
            
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
        return reviewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        
        let review = reviewItems[indexPath.row]
        if let imageUrlString = review.imageView1URL, let imageUrl = URL(string: imageUrlString) {
            cell.imageView.kf.setImage(with: imageUrl) // Kingfisher 라이브러리를 사용하여 이미지를 로드합니다.
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let review = reviewItems[indexPath.row]
        let reviewVC = ReviewViewController()
        
        
        reviewVC.placeName = review.storeName
        reviewVC.placeURL = review.internetSettle
        reviewVC.starCount = review.starCount
        reviewVC.rateNumber = review.rateNumber
        reviewVC.reviewDate = review.reviewDate
        reviewVC.memo = review.memo
        reviewVC.imageView1URL = review.imageView1URL
        reviewVC.imageView2URL = review.imageView2URL
        
        
        present(reviewVC, animated: true, completion: nil)
    }
    
    
}







//        if let imageUrlString = review.imageView1URL, let imageUrl = URL(string: imageUrlString) {
//                reviewVC.imageView1Data = UIImage(data: try! Data(contentsOf: imageUrl))
//            }
//        if let imageUrlString2 = review.imageView2URL, let imageUrl2 = URL(string: imageUrlString2) {
//                reviewVC.imageView2Data = UIImage(data: try! Data(contentsOf: imageUrl2))
//            }
//        if let imageView1URL = review.imageView1URL {
//            reviewVC.imageView1Data = UIImage(contentsOfFile: imageView1URL)
//        }
//        if let imageView2URL = review.imageView2URL {
//            reviewVC.imageView2Data = UIImage(contentsOfFile: imageView2URL)
//        }

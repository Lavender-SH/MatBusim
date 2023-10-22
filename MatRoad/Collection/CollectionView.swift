//
//  CollectionView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit

class CollectionView: BaseView {
    lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "  맛집 키워드 검색"
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont(name: "KCC-Ganpan", size: 14.0)//UIFont.systemFont(ofSize: 14) //플레이스 홀더 글씨 크기
        }
        searchBar.layer.shadowColor = UIColor.clear.cgColor
        //searchBar.showsCancelButton = true
        searchBar.tintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal // 서치바 스타일을 minimal로 설정하여 기본 배경을 제거.
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default) // 배경 이미지를 빈 이미지로 설정
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.font = UIFont(name: "KCC-Ganpan", size: 13.0)//UIFont.systemFont(ofSize: 13)
        
//        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
//            cancelButton.setTitle("취소", for: .normal)
//            cancelButton.setTitleColor(UIColor(named: "cancelButton"), for: .normal)
//            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//            cancelButton.tintColor = .white
//        }
        return searchBar
    }()
    
    let ratingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("별점순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 13.0)//UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    let visitsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("방문순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 13.0)//UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    let timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시간순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 13.0)//UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.backgroundColor = UIColor(named: "White")//UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1))
        return view
    }()
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "투명아이콘")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let emptyImageLabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "+버튼을 눌러서 맛집을 등록해주세요!"
        view.textColor = .darkGray
        view.font = UIFont(name: "KCC-Ganpan", size: 17.0)//UIFont.systemFont(ofSize: 17)
        view.isHidden = true
        return view
    }()
    
    override func configureView() {
        addSubview(collectionView)
        addSubview(ratingButton)
        addSubview(visitsButton)
        addSubview(timeButton)
        addSubview(searchBar)
        addSubview(emptyImageView)
        addSubview(emptyImageLabel)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(ratingButton.snp.bottom).offset(13)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            
            make.left.equalToSuperview()
            make.right.equalTo(timeButton.snp.left).offset(-5)
            make.height.equalTo(45)
        }
        ratingButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        visitsButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(ratingButton.snp.left).offset(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        timeButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(visitsButton.snp.left).offset(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        emptyImageLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).inset(50)
            make.centerX.equalTo(emptyImageView)
            //make.width.equalTo(300)
        }
        
        
        
    }
    
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        let size = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: size / 3, height: 192)
        //layer.cornerRadius = 30
        return layout
    }
    
    
    
    
    
}

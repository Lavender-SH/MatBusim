//
//  CollectionView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit

class CollectionView: BaseView {
    
    let ratingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("별점순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    let latestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    let pastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("과거순", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.backgroundColor = UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1))
        return view
    }()
    
    
    override func configureView() {
        addSubview(collectionView)
        addSubview(ratingButton)
        addSubview(latestButton)
        addSubview(pastButton)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(ratingButton.snp.bottom).offset(13)
            make.bottom.equalToSuperview()
        }
        ratingButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        latestButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(ratingButton.snp.left).offset(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        pastButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(latestButton.snp.left).offset(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        

    }
    
    
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        let size = UIScreen.main.bounds.width - 30
        layout.itemSize = CGSize(width: size / 3, height: 195)
        //layer.cornerRadius = 30
        return layout
    }
    
    
    
    
    
}

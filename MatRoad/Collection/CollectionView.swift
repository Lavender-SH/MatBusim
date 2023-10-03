//
//  CollectionView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit

class CollectionView: BaseView {
    
    let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("등록일", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    
    override func configureView() {
        addSubview(collectionView)
        addSubview(sortButton)
    }
    
    override func setConstraints() {
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-13)
            make.width.equalTo(50)
            make.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(sortButton.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            
        }
    }
    
    
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        let size = UIScreen.main.bounds.width - 30
        layout.itemSize = CGSize(width: size / 3, height: 170)
        //layer.cornerRadius = 30
        return layout
    }
    
    
    
    
    
}

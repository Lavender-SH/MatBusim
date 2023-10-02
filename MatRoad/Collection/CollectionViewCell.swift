//
//  CollectionViewCell.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit

class CollectionViewCell: BaseCollectionViewCell {
    
    
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .green
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .left
        view.text = "2023.09.27."
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.text = "가현산생고기"
        return view
    }()
    
    override func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(170)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(130)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(1)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            
        }
    }
    
}



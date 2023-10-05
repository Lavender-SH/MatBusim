//
//  CollectionViewCell.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import Cosmos

class CollectionViewCell: BaseCollectionViewCell {
    
    
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .green
        
        // 그라디언트 레이어 추가
        let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
            gradientLayer.locations = [0, 0.3, 0.7, 1] // 그라디언트 위치 조정
            gradientLayer.frame = view.bounds
            view.layer.insertSublayer(gradientLayer, at: 0)
        
        return view
    }()

    
    let dateLabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .left
        view.text = ""
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.text = ""
        return view
    }()
    
    let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        view.settings.filledImage = UIImage(named: "fill")
        view.settings.emptyImage = UIImage(named: "empty")
        return view
    }()
    
    let deleteCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .red
        imageView.isHidden = true
        return imageView
    }()
    
    
    override func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(cosmosView)
        contentView.addSubview(deleteCheckmark)
        
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(170)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(110)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(1)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            
        }
        cosmosView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).inset(10)
            make.leading.equalTo(imageView.snp.leading).offset(3)
        }
        deleteCheckmark.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(imageView)
        }
    }
    
}



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
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16.5
        view.clipsToBounds = true
        view.backgroundColor = .clear
        
        // 그라디언트 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.0] // 시작 위치와 끝 위치 설정
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 10)
        view.textAlignment = .left
        view.text = ""
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 12)
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
        view.settings.filledImage = UIImage(named: "smallfill")
        view.settings.emptyImage = UIImage()
        view.settings.starSize = 12 // 별의 크기 설정
        view.settings.starMargin = 1 // 별 사이의 간격 설정
        //view.settings.emptyImage = UIImage(named: "empty")
        //view.settings.emptyImage = nil
        return view
    }()
    
    let deleteCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .red
        imageView.isHidden = true
        return imageView
    }()
    let transCheckmark: UIImageView = {
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
        contentView.addSubview(transCheckmark)
        
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            //make.horizontalEdges.equalTo(contentView)
            make.left.equalTo(contentView).offset(2)
            make.right.equalTo(contentView).offset(-2)
            make.top.equalTo(contentView.snp.top).inset(0)
            make.height.equalTo(180)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(2)
            make.leading.equalTo(7)
            
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).inset(0)
            make.leading.equalTo(7)
            make.width.equalToSuperview()
            
        }
        cosmosView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            //make.top.equalTo(contentView.snp.top).inset(0)
            make.leading.equalTo(imageView.snp.leading).offset(7)
            make.centerX.equalTo(contentView)
            //make.width.equalTo(80)
            //make.right.equalTo(imageView.snp.right).inset(7)
        }
        deleteCheckmark.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(imageView)
        }
        transCheckmark.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(imageView)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = imageView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = imageView.bounds
        }
    }

    
}



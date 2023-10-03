//
//  ReviewView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/03.
//

import UIKit
import SnapKit
import Cosmos

class ReviewView: BaseView {
    
    lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let imageView1 = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .darkGray
        view.image = UIImage(named: "food1")
        return view
    }()
    
    let imageView2 = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .darkGray
        view.image = UIImage(named: "food2")
        return view
    }()
    
    let homeImage = {
        let view = UIImageView()
        view.tintColor = .white
        view.image = UIImage(systemName: "house")
        return view
    }()
    
    let storeNameLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 19)
        view.textAlignment = .center
        view.backgroundColor = .clear
        return view
    }()
    
    let internetImage = {
        let view = UIImageView()
        view.tintColor = .white
        view.image = UIImage(systemName: "globe")
        return view
    }()
    let internetButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.contentHorizontalAlignment = .center
        return button
    }()

    let rateLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 17)
        view.text = "Rate"
        view.backgroundColor = .clear
        view.textAlignment = .center
        return view
    }()
    
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half // 별을 반으로 채울 수 있게 설정
        view.settings.updateOnTouch = true // 사용자가 탭하거나 드래그할 때 별점 업데이트
        view.settings.starSize = 45 // 별의 크기 설정
        view.settings.starMargin = 7 // 별 사이의 간격 설정
        view.settings.filledColor = .orange // 채워진 별의 색상 설정
        view.settings.emptyBorderColor = .orange // 빈 별의 테두리 색상 설정
        view.settings.filledBorderColor = .yellow // 채워진 별의 테두리 색상 설정
        view.contentMode = .center
        view.rating = 0.0
        return view
    }()
    
    let rateNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "0.0"
        return label
    }()
    
    
    let dateLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 17)
        view.text = "Date"
        view.backgroundColor = .clear
        view.textAlignment = .center
        return view
    }()
    
    let dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("  맛집을 방문한 날짜를 입력해보세요.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .left
            button.contentHorizontalAlignment = .left
        button.setTitleColor(.white, for: .normal)
        let calendarImage = UIImage(systemName: "calendar")
            button.setImage(calendarImage, for: .normal)
            button.tintColor = .white
        return button
    }()
    
    let memoLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "Memo"
        view.backgroundColor = .clear
        view.textAlignment = .center
        return view
    }()
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.backgroundColor = .black
        textView.layer.borderWidth = 2.0
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.textColor = .white
        return textView
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.contentHorizontalAlignment = .center
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.contentHorizontalAlignment = .center
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.5
        button.clipsToBounds = true
        return button
    }()
    
    
    
    override func configureView() {
        addSubview(alertView)
        alertView.addSubview(imageView1)
        alertView.addSubview(imageView2)
        alertView.addSubview(homeImage)
        alertView.addSubview(storeNameLabel)
        alertView.addSubview(internetImage)
        alertView.addSubview(internetButton)
        alertView.addSubview(rateLabel)
        alertView.addSubview(cosmosView)
        alertView.addSubview(rateNumberLabel)
        alertView.addSubview(dateLabel)
        alertView.addSubview(dateButton)
        alertView.addSubview(memoLabel)
        alertView.addSubview(memoTextView)
        alertView.addSubview(cancelButton)
        alertView.addSubview(saveButton)
        
        
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            print("User rated: \(rating)")
            self?.rateNumberLabel.text = "\(rating)"
        }
        imageView1.tag = 1
        imageView2.tag = 2
        
    }

    
    override func setConstraints() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        imageView1.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.top).inset(10)
            make.left.equalTo(alertView.snp.left).inset(10)
            
            make.height.equalTo(200)
            make.width.equalTo(alertView).multipliedBy(0.49).offset(-10)
        }
        imageView2.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.top).inset(10)
            make.left.equalTo(imageView1.snp.right).offset(13)
            make.right.equalTo(alertView.snp.right).inset(10)
            make.height.equalTo(200)
            make.width.equalTo(alertView).multipliedBy(0.49).offset(-10)
        }
        homeImage.snp.makeConstraints { make in
            make.top.equalTo(imageView1.snp.bottom).offset(10)
            make.left.equalTo(alertView.snp.left).inset(10)
            make.size.equalTo(30)
        }
        
        storeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView1.snp.bottom).offset(10)
            make.left.equalTo(homeImage.snp.right).offset(10)
            make.right.equalTo(alertView.snp.right).offset(-10)
            make.height.equalTo(30)
        }
        internetImage.snp.makeConstraints { make in
            make.top.equalTo(homeImage.snp.bottom).offset(10)
            make.left.equalTo(alertView.snp.left).inset(10)
            make.size.equalTo(30)
        }
        internetButton.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(10)
            make.left.equalTo(homeImage.snp.right).offset(10)
            make.right.equalTo(alertView.snp.right).offset(-10)
            make.height.equalTo(30)
        }
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(internetImage.snp.bottom).offset(10)
            make.left.equalTo(alertView.snp.left).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        cosmosView.snp.makeConstraints { make in
            make.top.equalTo(internetButton.snp.bottom).offset(10)
            make.left.equalTo(rateLabel.snp.right).offset(10)
            make.right.equalTo(rateNumberLabel.snp.left).offset(-10)
            //make.width.equalTo(220)
            make.height.equalTo(40)
        }
        rateNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(internetButton.snp.bottom).offset(10)
            make.left.equalTo(cosmosView.snp.right).offset(10)
            make.right.equalTo(alertView.snp.right).inset(10)
            make.width.equalTo(45)
            make.height.equalTo(40)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).offset(5)
            make.left.equalTo(alertView.snp.left).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(cosmosView.snp.bottom).offset(5)
            make.left.equalTo(dateLabel.snp.right).offset(10)
            make.right.equalTo(alertView.snp.right).offset(-10)
            //make.width.equalTo(220)
            make.height.equalTo(40)
        }
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(0)
            make.left.equalTo(alertView.snp.left).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(0)
            make.left.equalTo(alertView.snp.left).inset(10)
            make.right.equalTo(alertView.snp.right).offset(-10)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(10)
            make.width.equalTo(alertView).multipliedBy(0.5)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(10)
            make.width.equalTo(alertView).multipliedBy(0.5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        
        
        
    }
    
    
    
}



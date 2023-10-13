//
//  BackupView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/10.
//

import UIKit
import SnapKit

class BackUpView: BaseView {
    
    private let backUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "백업/복구"
        return label
    }()
    
    let backUpTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .gray
        textView.backgroundColor = .clear
        textView.text = "생성된 백업 파일은 앱 내에 저장되기 때문에 앱 삭제 시\n백업 파일도 함께 삭제됩니다. \n메신저, 이메일, 클라우드 스토리지 등으로 백업 파일을 보내주세요."
        textView.textContainer.maximumNumberOfLines = 3
        textView.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        return textView
    }()
    
    let backUpButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        view.setTitle("백업 파일 만들기", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return view
    }()
    
    let restoreButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        view.setTitle("복구 하기", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return view
    }()
    
    let backupTableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1))
        view.separatorColor = .darkGray
        return view
    }()
    
    override func configureView() {
        addSubview(backupTableView)
        addSubview(backUpButton)
        addSubview(backUpLabel)
        addSubview(backUpTextView)
        addSubview(restoreButton)
    }
    
    override func setConstraints() {
        backUpLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalToSuperview().offset(30)
        }
        backUpTextView.snp.makeConstraints { make in
            make.top.equalTo(backUpLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(60)
        }
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(170)
        }
        backUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(backupTableView.snp.top).offset(-10)
            make.left.equalToSuperview().offset(30)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-45) // 화면의 절반 넓이에서 45를 빼서 버튼 간격을 조정
            make.height.equalTo(40)
        }
        restoreButton.snp.makeConstraints { make in
            make.bottom.equalTo(backupTableView.snp.top).offset(-10)
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(backUpButton.snp.width) // backUpButton과 동일한 넓이
            make.height.equalTo(40)
        }
        
    }
    
}


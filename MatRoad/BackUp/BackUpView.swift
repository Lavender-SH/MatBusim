//
//  BackupView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/10.
//

import UIKit
import SnapKit

class BackUpView: BaseView {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "투명아이콘")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let backUpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KCC-Ganpan", size: 15.0)//UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.text = "백업/복구/공유하기"
        return label
    }()

    let backUpTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .darkGray
        textView.backgroundColor = .clear
        textView.text = "생성된 백업 파일은 앱 내에서 관리되기 때문에 앱을 삭제하면 백업도 함께 사라집니다. 에어드랍, 카카오톡, 메일 등 다양한 방법으로 백업 파일을 안전하게 보관하세요. 친구, 지인의 백업파일을 받아 복구하기를 눌러 데이터를 공유할 수 있습니다. 단, 나의 기존 데이터는 사라집니다."
        //"생성된 백업 파일은 앱 내에 저장되기 때문에 앱 삭제 시\n백업 파일도 함께 삭제됩니다. \n메신저, 이메일, 클라우드 스토리지 등으로 백업 파일을 보내주세요."
        textView.textContainer.maximumNumberOfLines = 5
        textView.font = UIFont(name: "KCC-Ganpan", size: 13.0)//UIFont.systemFont(ofSize: 13, weight: .heavy)
        return textView
    }()
    
    let backUpIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.badge.plus")
        imageView.tintColor = .white // 색상을 흰색으로 설정
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let backUpButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "darkGold")
        view.setTitle("         백업 파일 만들기", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 16.5
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.white.cgColor
        view.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 15.0)//UIFont.boldSystemFont(ofSize: 15)
        return view
    }()
    
    let restoreIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "repeat.circle")
        imageView.tintColor = .white // 색상을 흰색으로 설정
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let restoreButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "darkGold")
        view.setTitle("   복구 하기", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 16.5
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.white.cgColor
        view.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 15.0)//UIFont.boldSystemFont(ofSize: 15)
        return view
    }()

    let backupTableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = UIColor(named: "White")
        view.separatorColor = .darkGray
        return view
    }()

    override func configureView() {
        addSubview(logoImageView)
        addSubview(backupTableView)
        addSubview(backUpButton)
        addSubview(backUpLabel)
        addSubview(backUpTextView)
        addSubview(restoreButton)
        addSubview(backUpIconImageView)
        addSubview(restoreIconImageView)
    }

    override func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
        
        backUpLabel.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.left.equalToSuperview().offset(30)
        }
        backUpTextView.snp.makeConstraints { make in
            make.top.equalTo(backUpLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(95)
        }
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(300)
        }
        backUpIconImageView.snp.makeConstraints { make in
                make.centerY.equalTo(backUpButton)
                make.left.equalTo(backUpButton.snp.left).inset(10)
                make.size.equalTo(25)
        }
        backUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(backupTableView.snp.top).offset(-10)
            make.left.equalToSuperview().offset(22)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-35)
            make.height.equalTo(40)
        }
        restoreIconImageView.snp.makeConstraints { make in
                make.centerY.equalTo(restoreButton)
                make.left.equalTo(restoreButton.snp.left).inset(10)
                make.size.equalTo(25)
            }
        restoreButton.snp.makeConstraints { make in
            make.bottom.equalTo(backupTableView.snp.top).offset(-10)
            make.right.equalToSuperview().offset(-22)
            make.width.equalTo(backUpButton.snp.width)
            make.height.equalTo(40)
        }

    }

}



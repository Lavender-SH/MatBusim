//
//  BackUpTableViewCell.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/10.
//

import UIKit


class BackUpTableViewCell: BaseTableViewCell {
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "파일그림")
        return label
    }()
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "파일그림")
        return label
    }()
    private let docImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text")
        imageView.tintColor = UIColor(named: "파일그림")
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configureView() {
        contentView.addSubview(fileNameLabel)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(docImageView)
    }
    
    override func setConstraints() {
        docImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 30, height: 30))
            }
        fileNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.left.equalTo(docImageView.snp.right).offset(15)
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(fileNameLabel.snp.bottom).offset(7)
            make.left.equalTo(docImageView.snp.right).offset(15)
        }

    }
    
    func setCellData(fileName: String, fileSize: String) {
        fileNameLabel.text = fileName
        sizeLabel.text = fileSize
    }

    
}

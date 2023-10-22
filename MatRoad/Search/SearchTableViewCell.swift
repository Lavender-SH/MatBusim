//
//  SearchTableViewCell.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/03.
//

import UIKit


class SearchTableViewCell: BaseTableViewCell {
    
    static let reuseIdentifier = "SearchCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KCC-Ganpan", size: 14.0)//UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KCC-Ganpan", size: 12.0)//UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private let roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KCC-Ganpan", size: 12.0)//UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KCC-Ganpan", size: 12.0)//UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func configureView() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(placeLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(roadAddressLabel)
        contentView.addSubview(phoneLabel)
    }
    
    override func setConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(40)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(posterImageView.snp.right).offset(10)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(placeLabel.snp.right).offset(10)
        }
        roadAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(2)
            make.left.equalTo(posterImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(roadAddressLabel.snp.bottom).offset(2)
            make.left.equalTo(posterImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    func configure(with item: Document) {
        posterImageView.image = UIImage(named: "pin")
        placeLabel.text = item.placeName
        categoryLabel.text = item.finalCategory
        roadAddressLabel.text = item.roadAddressName
        phoneLabel.text = item.phone
    }
    

    
}


//
//  BaseCollectionViewCell.swift
//  Recap Shopping
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() { }
    
    func setConstraints() { }
    
    
    
}

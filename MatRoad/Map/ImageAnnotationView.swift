//
//  ImageAnnotationView.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/09.
//

import UIKit
import MapKit
import RealmSwift
import Kingfisher
import SnapKit

class ImageAnnotationView: MKAnnotationView {
    
    private var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        self.addSubview(imageView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with url: URL) {
        imageView?.kf.setImage(with: url)
    }
    

}

class customView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageClusterView: MKAnnotationView {
    private var imageView: UIImageView!
    private var countLabel: UILabel!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 58, height: 58)
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        let aView = customView(frame: self.bounds)
        self.addSubview(aView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        aView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.textColor = .white
        countLabel.font = UIFont(name: "KCC-Ganpan", size: 14.0)//UIFont.boldSystemFont(ofSize: 14)
        countLabel.backgroundColor = UIColor(named: "countGold")
        countLabel.layer.cornerRadius = 10
        countLabel.clipsToBounds = true
        aView.addSubview(countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(2)
            make.top.equalToSuperview().inset(2)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                if let firstAnnotation = cluster.memberAnnotations.first as? MKPointAnnotation,
                   let imageUrlString = firstAnnotation.subtitle,
                   let imageUrl = URL(string: imageUrlString ) {
                    imageView?.kf.setImage(with: imageUrl)
                }
                countLabel?.text = "\(cluster.memberAnnotations.count)"
            }
        }
    }
}

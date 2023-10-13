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

class ImageAnnotationView: MKAnnotationView {

    private var imageView: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with url: URL) {
        imageView?.kf.setImage(with: url)
    }
}

class ImageClusterView: MKAnnotationView {
    private var imageView: UIImageView!
    private var countLabel: UILabel!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)

        countLabel = UILabel(frame: self.bounds)
        countLabel.textAlignment = .center
        countLabel.textColor = .white
        countLabel.font = UIFont.boldSystemFont(ofSize: 19)
        self.addSubview(countLabel)
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




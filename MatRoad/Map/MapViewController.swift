//
//  ViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/25.
//

import UIKit
import MapKit
import RealmSwift
import Kingfisher
import SnapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let mapView = MKMapView()
    let reviewRepository = ReviewTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 4000000)
        addLogoToMapView()
        loadAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAnnotations()
    }
    
    func loadAnnotations() {
        let currentAnnotations = mapView.annotations
        let reviews = reviewRepository.fetch()
        var newAnnotations: [MKPointAnnotation] = []

        for review in reviews {
            if let latitude = Double(review.latitude ?? ""), let longitude = Double(review.longitude ?? "") {
                let annotation = MKPointAnnotation()
                annotation.title = review.storeName
                annotation.subtitle = review.imageView1URL
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                newAnnotations.append(annotation)
            }
        }

        // 기존에 있던 어노테이션 중 새로운 어노테이션에 없는 것만 제거
        let annotationsToRemove = currentAnnotations.filter { annotation in
            !newAnnotations.contains { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude }
        }
        mapView.removeAnnotations(annotationsToRemove)

        // 새로운 어노테이션 중 기존에 없던 것만 추가
        let annotationsToAdd = newAnnotations.filter { newAnnotation in
            !currentAnnotations.contains { $0.coordinate.latitude == newAnnotation.coordinate.latitude && $0.coordinate.longitude == newAnnotation.coordinate.longitude }
        }
        mapView.addAnnotations(annotationsToAdd)
        
        let center = CLLocationCoordinate2D(latitude: 36.5, longitude: 127.8)
        let span = MKCoordinateSpan(latitudeDelta: 10 / 1.6, longitudeDelta: 10 / 1.6)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKClusterAnnotation {
            let identifier = "ImageCluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ImageClusterView
            if clusterView == nil {
                clusterView = ImageClusterView(annotation: annotation, reuseIdentifier: identifier)
            }
            return clusterView
        } else {
            let identifier = "ImageAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ImageAnnotationView
            if annotationView == nil {
                annotationView = ImageAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.clusteringIdentifier = identifier
            }
            
            if let imageUrlString = annotation.subtitle, let imageUrl = URL(string: imageUrlString ?? "") {
                annotationView?.setImage(with: imageUrl)
            }
            return annotationView
        }
    }
    
    func addLogoToMapView() {
        let logo = UIImage(named: "matlogo")
        let imageView = UIImageView(image: logo)
        mapView.addSubview(imageView)
        
    
        imageView.snp.makeConstraints { make in
            make.top.equalTo(mapView).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(156.33)
            make.height.equalTo(44)
            
        }
    }
    
       
}
extension MapViewController {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        if let review = reviewRepository.fetch().first(where: { $0.storeName == annotation.title && $0.imageView1URL == annotation.subtitle }) {
            let reviewVC = ReviewViewController()
            
            reviewVC.isEditMode = true
            reviewVC.selectedReviewId = review._id
            
            reviewVC.placeName = review.storeName
            reviewVC.placeURL = review.internetSettle
            reviewVC.starCount = review.starCount
            reviewVC.rateNumber = review.rateNumber
            reviewVC.reviewDate = review.reviewDate
            reviewVC.memo = review.memo
            reviewVC.imageView1URL = review.imageView1URL
            reviewVC.imageView2URL = review.imageView2URL
            reviewVC.visitCount = review.visitCount
            
            present(reviewVC, animated: true, completion: nil)
        }
    }
}




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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let mapView = MKMapView()
    let reviewRepository = ReviewTableRepository()
    let locationManager = CLLocationManager()
    let moveToCurrentLocationButton = UIButton()
    let searchBar = UISearchBar()
    var isAtCurrentLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        mapView.frame = view.bounds
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 4000000)
        loadAnnotations()
        setupSearchBar()
        addLogoToMapView()
        setupLocationManager()
        setupMoveToCurrentLocationButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAnnotations()
    }
    
    func loadAnnotations() {
        let currentAnnotations = mapView.annotations
        var newAnnotations: [MKPointAnnotation] = []
        
        let reviews = reviewRepository.fetch()
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
            //콜아웃 기능
            //annotationView?.canShowCallout = true
            
            if let imageUrlString = annotation.subtitle, let imageUrl = URL(string: imageUrlString ?? "") {
                annotationView?.setImage(with: imageUrl)
            }
            return annotationView
        }
    }
    
    func addLogoToMapView() {
        let logo = UIImage(named: "투명아이콘")
        let imageView = UIImageView(image: logo)
        mapView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(mapView).offset(-60)
            make.leading.equalTo(mapView).offset(0)
            make.width.height.equalTo(120)
        }

    }
    // MARK: - 내 위치로 이동기능
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //줌을 축소해도 다시 확대되게 만듬
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest // 최고 정확도로 위치 업데이트
        //locationManager.distanceFilter = 10 // 위치가 10미터 이상 움직였을 때만 업데이트
        locationManager.startUpdatingLocation()
    }
    func setupMoveToCurrentLocationButton() {
        moveToCurrentLocationButton.setImage(UIImage(systemName: "scope"), for: .normal) // 위치 서비스 아이콘으로 설정
        moveToCurrentLocationButton.tintColor = .black
        moveToCurrentLocationButton.backgroundColor = .white
        moveToCurrentLocationButton.layer.cornerRadius = 20
        moveToCurrentLocationButton.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
        view.addSubview(moveToCurrentLocationButton)
        
        moveToCurrentLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(mapView).offset(-100)
            make.trailing.equalTo(mapView).offset(-20)
            make.width.height.equalTo(40)
        }
    }
    @objc func moveToCurrentLocation() {
        if isAtCurrentLocation {
            // 지정된 위치로 이동
            let center = CLLocationCoordinate2D(latitude: 36.5, longitude: 127.8)
            let span = MKCoordinateSpan(latitudeDelta: 10 / 1.6, longitudeDelta: 10 / 1.6)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            isAtCurrentLocation = false
        } else {
            // 현재 위치로 이동
            if let currentLocation = locationManager.location?.coordinate {
                let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 1500, longitudinalMeters: 1500)
                mapView.setRegion(region, animated: true)
                isAtCurrentLocation = true
            }
        }
    }
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    
}

// MARK: - 맵뷰 리뷰화면 띄우기
extension MapViewController {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        //어노테이션이 움직이는 애니메이션 효과
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: -10)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                view.transform = CGAffineTransform.identity
            }
        }
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
        
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

// MARK: - 서치바 확장
extension MapViewController: UISearchBarDelegate {
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "맛집을 검색하면 지도가 확대됩니다!"
        searchBar.tintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.systemFont(ofSize: 13) //플레이스 홀더 글씨 크기
        }
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(53)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)

        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // 검색어가 없을 때 지정된 위치로 돌아오기
            let center = CLLocationCoordinate2D(latitude: 36.5, longitude: 127.8)
            let span = MKCoordinateSpan(latitudeDelta: 10 / 1.6, longitudeDelta: 10 / 1.6)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            return
        }
        
        let reviews = reviewRepository.fetch().filter("storeName CONTAINS[c] %@", searchText)
        guard let review = reviews.first else { return }
        
        if let latitude = Double(review.latitude ?? ""), let longitude = Double(review.longitude ?? "") {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
}




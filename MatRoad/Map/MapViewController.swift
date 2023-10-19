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
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let reviewRepository = ReviewTableRepository()
    let moveToCurrentLocationButton = UIButton()
    let searchBar = UISearchBar()
    var isAtCurrentLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //항상 라이트모드 유지
        self.overrideUserInterfaceStyle = .light
    
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        self.view.addSubview(mapView)
        
        navigationController?.isNavigationBarHidden = true
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setupLocationManager()
        
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 4000000)
        
        loadAnnotations()
        setupSearchBar()
        addLogoToMapView()
        setupMoveToCurrentLocationButton()
        //checkDeviceLocationAuthorization()
        
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
        // 현재 위치의 주석을 기본 주석 뷰로 표시⭐️⭐️⭐️
        if annotation is MKUserLocation {
            return nil
        }
        
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
        let logo = UIImage(named: "투명아이콘")
        let imageView = UIImageView(image: logo)
        mapView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(mapView)
            make.left.equalTo(mapView)
            make.size.equalTo(110)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            mapView.setRegion(region, animated: true)
//        }
//    }
    
        // MARK: - 내 위치로 이동기능
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
                make.bottom.equalTo(mapView).offset(-30)
                make.trailing.equalTo(mapView).offset(-15)
                make.width.height.equalTo(40)
            }
        }
        @objc func moveToCurrentLocation() {
            if isAtCurrentLocation {
                // 지정된 위치로 이동
                moveToDefaultLocation()
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
    
        func moveToDefaultLocation() {
            let center = CLLocationCoordinate2D(latitude: 36.5, longitude: 127.8)
            let span = MKCoordinateSpan(latitudeDelta: 10 / 1.6, longitudeDelta: 10 / 1.6)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    //    // MARK: - 위치 서비스 권한을 확인하는 함수
    //    func checkDeviceLocationAuthorization() {
    //        // iOS 위치 서비스 활성화 체크
    //        // 위치 권한 체크는 비동기로 처리해야함.
    //        DispatchQueue.global().async {
    //            // 위치 서비스가 활성화되어 있는지 확인. 만약 활성화되어 있으면, 권한 확인 및 처리(현재 사용자의 위치 권한 상태를 가지고 옴)를 진행.
    //            if CLLocationManager.locationServicesEnabled() {
    //                //현재 사용자의 위치 권한 상태를 가져옴. iOS 14.0 이상의 경우에는 locationManager.authorizationStatus를 사용하고,
    //                //그 이하 버전에서는 CLLocationManager.authorizationStatus()를 사용하여 상태를 가져옴. 가져온 권한 상태는 authorization 변수에 저장됨.
    //                let authorization: CLAuthorizationStatus
    //
    //                if #available(iOS 14.0, *) {
    //                    authorization = self.locationManager.authorizationStatus
    //                } else {
    //                    authorization = CLLocationManager.authorizationStatus()
    //                }
    //                print(authorization, "77")
    //                //메인 스레드에서 권한 상태를 처리하는 부분. 메인 스레드에서 UI 업데이트 및 사용자 액션을 처리해야 하므로, 백그라운드 스레드에서 확인한 권한 상태를 메인 스레드에서 처리함.
    //                DispatchQueue.main.async {
    //                    self.checkCurrentLocationAuthorization(status: authorization)
    //                }
    //            } else {
    //                print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
    //            }
    //        }
    //    }
    //
    //    // MARK: - 위치 서비스 권한의 상태에 따라 적절한 동작을 수행하는 역할을 하는 함수
    //    /// - Parameter status: status 매개변수로 권한 상태를 전달받음.
    //    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
    //        print("Check", status)
    //        //    @frozen >> 더 이상 열거형에 절대 추가될 케이스가 없다고 확인한다.!!!
    //        switch status {
    //        case .notDetermined: //사용자가 위치 권한을 아직 결정하지 않은 상태
    //            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치 업뎃 정확도 설정
    //            locationManager.requestWhenInUseAuthorization() //권한 허용을 위한 alert(info.plist)창을 표시하도록 요청함. 사용자에게 위치 정보를 사용할 때의 권한을 요청.
    //            setMapViewCenterBasedOnAuthorization()
    //        case .restricted: //앱에 의해 제한된 상태. 일반적으로 부모가 관리하는 계정이나 디바이스 제한.
    //            print("restricted")
    //            setMapViewCenterBasedOnAuthorization()
    //        case .denied: //사용자가 위치 권한을 거부한 상태.
    //            print("denied")
    //            showLocationSetiingAlert() //위치 설정을 변경하도록 유도하는 알림창을 표시
    //            //setMapViewCenterBasedOnAuthorization()
    //
    //        case .authorizedAlways: //항상 위치 사용 권한이 허용된 상태
    //            print("authorizedAlways")
    //            setMapViewCenterBasedOnAuthorization()
    //        case .authorizedWhenInUse: //앱 사용 중에 위치 사용 권한이 허용된 상태
    //            print("authorizedWhenInUse")
    //            locationManager.startUpdatingLocation()
    //            setMapViewCenterBasedOnAuthorization()// 위치 업데이트를 시작. 이후 didUpdateLocation 메서드 호출.
    //        case .authorized: // iOS 14.0 이상에서 deprecated된 상태, .authorizedAlways 또는 .authorizedWhenInUse로 처리됨.
    //            print("authorized")
    //        @unknown default: // 위치 권한 종류가 더 생길 가능성 대비하여 기본 처리를 정의
    //            print("default")
    //        }
    //
    //        // MARK: - 위치 서비스를 사용할 수 없는 상황에서 사용자에게 알림 창을 보여주는 역할
    //        //사용자에게 위치 서비스 활성화를 유도하고, 설정으로 이동할 수 있는 옵션을 제공
    //        func showLocationSetiingAlert() {
    //            let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
    //            let goSetting = UIAlertAction(title: "설정으로 이동", style: .default)  { _ in
    //
    //                // 설정에서 직접적으로 앱 설정 화면에 들어간적이 없다면
    //                // 한번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이라서
    //                // 설정 페이지로 넘어갈 수 는 있어도 설정 상세 페이지로 넘어갈 수는 없다.
    //                if let appSetting = URL(string: UIApplication.openSettingsURLString) { //앱 설정 화면의 URL을 가져옴
    //                    UIApplication.shared.open(appSetting) //앱 설정 화면을 연다.
    //                }
    //            }
    //
    //            let cancel = UIAlertAction(title: "취소", style: .cancel)
    //
    //            alert.addAction(goSetting)
    //            alert.addAction(cancel)
    //            present(alert, animated: true)
    //        }
    //    }
    //
    //    // MARK: - 사용자가 위치 권한을 허용한 경우에는 맵뷰의 중심을 사용자의 현재 위치로 설정 / 거부한 경우 디폴트(새싹)
    //    func setMapViewCenterBasedOnAuthorization() {
    //        let defaultCenter = CLLocationCoordinate2D(latitude: 37.518135, longitude: 126.885853)
    //
    //        if CLLocationManager.locationServicesEnabled() {
    //            switch locationManager.authorizationStatus {
    //            case .authorizedWhenInUse, .authorizedAlways:
    //                if let userLocation = locationManager.location?.coordinate {
    //                    mapView.setCenter(userLocation, animated: true)
    //                } else {
    //                    mapView.setCenter(defaultCenter, animated: true)
    //                }
    //            case .denied, .restricted, .notDetermined:
    //                mapView.setCenter(defaultCenter, animated: true)
    //            @unknown default:
    //                mapView.setCenter(defaultCenter, animated: true)
    //            }
    //        } else {
    //            mapView.setCenter(defaultCenter, animated: true)
    //        }
    //    }
    
    
    
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
        
        // storeName과 memo 모두를 검색가능하게
        let storeNamePredicate = NSPredicate(format: "storeName CONTAINS[c] %@", searchText)
        let memoPredicate = NSPredicate(format: "memo CONTAINS[c] %@", searchText)
        let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [storeNamePredicate, memoPredicate])
        
        let reviews = reviewRepository.fetch().filter(combinedPredicate)
        guard let review = reviews.first else { return }
        
        if let latitude = Double(review.latitude ?? ""), let longitude = Double(review.longitude ?? "") {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    //// MARK: - 위치 관련 이벤트를 처리하는 메서드들을 구현하고 있는 프로토콜 확장. 각 메서드는 사용자의 위치 정보 및 위치 권한 변경에 대한 처리를 담당
    //extension MapViewController {
    //    // 5. 사용자의 위치 정보를 성공적으로 가져왔을 때 호출됨
    //    // 한번만 실행되지 않는다. iOS 위치 업데이트가 필요한 시점에 알아서 여러번 호출
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        print(#function)
    //        if let coordinate = locations.last?.coordinate {
    //            let lat = coordinate.latitude //위도
    //            let lon = coordinate.longitude //경도
    //            print(lat, lon)
    //            print(coordinate)
    //            //날씨api호출
    //        }
    //        locationManager.stopUpdatingLocation()
    //        //stopUpdatingLocation()을 호출하여 위치 업데이트를 중단함. 이렇게 하면 한 번 위치를 가져온 후 업데이트를 중단할 수 있다.
    //    }
    //    // 사용자의 위치를 가지고 오지 못한 경우
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //
    //    }
    //    // 사용자의 권한 상태가 바뀔 때를 알려줌
    //    // 거부했다가 설정에서 변경을 했거나, 혹은 notDetermined 상태에서 허용을 했거나
    //    // 허용해서 위치를 가지고 오는 도중에, 설정에서 거부를 하고 앱으로 다시 돌아올 때 등
    //    // iOS 14 이상
    //    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    //        print(#function)
    //        checkDeviceLocationAuthorization() //위치 권한 상태를 확인하고 처리.
    //
    //    }
    //
    //    func locationManager2(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //        if status == .authorizedWhenInUse || status == .authorizedAlways {
    //            // 위치 정보 접근 권한이 다시 허용되었을 때 처리할 작업
    //        }
    //    }
    //
    //    //사용자의 위치 권한 상태가 변경되었을 때(iOS 14 미만), 호출됨. iOS 14 이상에서는 위의 locationManagerDidChangeAuthorization를 사용하므로
    //    //이 메서드는 deprecated된 상태. 위치 권한 변경에 따른 추가 처리를 이곳에서 구현할 수 있다.
    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //
    //    }
    //}
    //
    //// MARK: - MKMapViewDelegate 프로토콜을 확장, 지도 뷰에 관련된 이벤트를 처리하는 메서드
    //// 지도 영역이 변경되거나 어노테이션을 선택할 때 필요한 로직을 이 메서드들 내에서 구현
    //extension MapViewController {
    //    //지도의 표시 영역이 변경되었을 때 호출
    //    /// - Parameters:
    //    ///   - mapView: 변경된 지도 뷰의 인스턴스
    //    ///   - animated: 지도 표시 영역이 애니메이션으로 변경되었는지 여부를 나타냄
    //    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    //        print(#function)
    //    }
    //
    //    //지도 상에서 어노테이션(annotation)을 선택했을 때 호출
    //    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
    //        print(#function)
    //    }
    //    //  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //    //    print(#function)
    //    //  }
    //}
}

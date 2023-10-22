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
        checkDeviceLocationAuthorization()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reviewUpdated), name: Notification.Name("ReviewUpdated"), object: nil)
    }
    
    //클러스트링을 유지하기 위한 결단의 칼날..
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.viewDidLoad()
        }
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
    
    // MARK: - 지도에서 리뷰를 수정할때
    func loadAnnotations2() {
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
            
            // 기존 어노테이션 제거
            mapView.removeAnnotations(mapView.annotations)
            
            // 어노테이션 다시 로드
            loadAnnotations()
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
    
    @objc func reviewUpdated() {
        mapView.removeAnnotations(mapView.annotations)
        loadAnnotations2()
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
            
            reviewVC.reviewView.visitCountStepper.value = Double(review.visitCount ?? 1)
            
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
            
            // 어노테이션의 선택 상태를 해제 (이동 위치) 그래야 다시 어노테이션을 눌러도 리뷰 창이 뜸⭐️
            mapView.deselectAnnotation(annotation, animated: false)
            
            present(reviewVC, animated: true, completion: nil)
        }
    }
}


    // MARK: - 서치바 확장
extension MapViewController: UISearchBarDelegate {
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "맛집의 이름과 메모의 내용을 검색하면 지도가 확대됩니다!"
        searchBar.tintColor = .white
        searchBar.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        searchBar.searchBarStyle = .minimal
        //searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.layer.cornerRadius = 10
        searchBar.layer.cornerCurve = .continuous
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont(name: "KCC-Ganpan", size: 13.0)//UIFont.systemFont(ofSize: 13) //플레이스 홀더 글씨 크기
        }
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(50)
            //make.horizontalEdges.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
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
    
}

extension MapViewController {
    // MARK: - 위치 서비스를 사용할 수 없는 상황에서 사용자에게 알림 창을 보여주는 역할
    //사용자에게 위치 서비스 활성화를 유도하고, 설정으로 이동할 수 있는 옵션을 제공
    func showLocationSetiingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default)  { _ in

            // 설정에서 직접적으로 앱 설정 화면에 들어간적이 없다면
            // 한번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이라서
            // 설정 페이지로 넘어갈 수 는 있어도 설정 상세 페이지로 넘어갈 수는 없다.
            if let appSetting = URL(string: UIApplication.openSettingsURLString) { //앱 설정 화면의 URL을 가져옴
                UIApplication.shared.open(appSetting) //앱 설정 화면을 연다.
            }
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(goSetting)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    // MARK: - 위치 서비스 권한을 확인하는 함수
    func checkDeviceLocationAuthorization() {
        // iOS 위치 서비스 활성화 체크
        // 위치 권한 체크는 비동기로 처리해야함.
        DispatchQueue.global().async {
            // 위치 서비스가 활성화되어 있는지 확인. 만약 활성화되어 있으면, 권한 확인 및 처리(현재 사용자의 위치 권한 상태를 가지고 옴)를 진행.
            if CLLocationManager.locationServicesEnabled() {
            //현재 사용자의 위치 권한 상태를 가져옴. iOS 14.0 이상의 경우에는 locationManager.authorizationStatus를 사용하고,
            //그 이하 버전에서는 CLLocationManager.authorizationStatus()를 사용하여 상태를 가져옴. 가져온 권한 상태는 authorization 변수에 저장됨.
                let authorization: CLAuthorizationStatus

                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                print(authorization, "77")
            //메인 스레드에서 권한 상태를 처리하는 부분. 메인 스레드에서 UI 업데이트 및 사용자 액션을 처리해야 하므로, 백그라운드 스레드에서 확인한 권한 상태를 메인 스레드에서 처리함.
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            } else {
                print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
            }
        }
    }

    // MARK: - 위치 서비스 권한의 상태에 따라 적절한 동작을 수행하는 역할을 하는 함수
    /// - Parameter status: status 매개변수로 권한 상태를 전달받음.
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        print("Check", status)
        //    @frozen >> 더 이상 열거형에 절대 추가될 케이스가 없다고 확인한다.!!!
        switch status {
        case .notDetermined: //사용자가 위치 권한을 아직 결정하지 않은 상태
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치 업뎃 정확도 설정
            locationManager.requestWhenInUseAuthorization() //권한 허용을 위한 alert(info.plist)창을 표시하도록 요청함. 사용자에게 위치 정보를 사용할 때의 권한을 요청.
        case .restricted: //앱에 의해 제한된 상태. 일반적으로 부모가 관리하는 계정이나 디바이스 제한.
            print("restricted")
        case .denied: //사용자가 위치 권한을 거부한 상태.
            print("denied")
            showLocationSetiingAlert() //위치 설정을 변경하도록 유도하는 알림창을 표시

        case .authorizedAlways: //항상 위치 사용 권한이 허용된 상태
            print("authorizedAlways")

        case .authorizedWhenInUse: //앱 사용 중에 위치 사용 권한이 허용된 상태
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
            // 위치 업데이트를 시작. 이후 didUpdateLocation 메서드 호출.
        case .authorized: // iOS 14.0 이상에서 deprecated된 상태, .authorizedAlways 또는 .authorizedWhenInUse로 처리됨.
            print("authorized")
        @unknown default: // 위치 권한 종류가 더 생길 가능성 대비하여 기본 처리를 정의
            print("default")
        }
    }

}


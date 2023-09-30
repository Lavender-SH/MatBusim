//
//  ViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/25.
//

import UIKit
import MapKit
import Photos

class MapViewController: UIViewController, MKMapViewDelegate {
        let mapView = MKMapView()
    
        override func viewDidLoad() {
            super.viewDidLoad()
    
            mapView.delegate = self
            view.addSubview(mapView)
            mapView.frame = view.bounds
    
            loadPhotos()
        }
    
        func loadPhotos() {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            fetchResult.enumerateObjects { (asset, _, _) in
                if let location = asset.location {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    
        // 지도에 어노테이션 표시 설정
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "photoAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
    
            return annotationView
        }
    }
    




/*
class MapViewController: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapGesture.addTarget(self, action: #selector(addImageAnnotation))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func addImageAnnotation(tapGesture: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        if let asset = info[.phAsset] as? PHAsset, let location = asset.location {
            let annotation = ImageAnnotation(coordinate: location.coordinate, image: image, title: "이미지", subtitle: "리뷰를 입력하세요.", review: "")
            mapView.addAnnotation(annotation)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ImageAnnotation {
            let identifier = "imageAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
            } else {
                annotationView?.annotation = annotation
            }
            
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            annotation.image.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? ImageAnnotation {
            let alert = UIAlertController(title: "맛집 리뷰", message: "리뷰를 입력하세요.", preferredStyle: .alert)
            alert.addTextField()
            let submitAction = UIAlertAction(title: "제출", style: .default) { [unowned alert] _ in
                let textField = alert.textFields![0]
                annotation.review = textField.text!
                annotation.subtitle = textField.text!
            }
            alert.addAction(submitAction)
            present(alert, animated: true)
        }
    }
}

class ImageAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var title: String?
    var subtitle: String?
    var review: String {
        didSet {
            subtitle = review
        }
    }
    
    init(coordinate: CLLocationCoordinate2D, image: UIImage, title: String?, subtitle: String, review: String) {
        self.coordinate = coordinate
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.review = review
    }
}
*/




/*
import UIKit
import CoreLocation // 1. CoreLocation Import
import MapKit
import SnapKit
import Photos

class MapViewController: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    // 2. 위치 매니저 생성: 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapGesture.addTarget(self, action: #selector(addImageAnnotation))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func addImageAnnotation(tapGesture: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        // 사진의 메타데이터에서 위치 정보를 추출
        if let asset = info[.phAsset] as? PHAsset, let location = asset.location {
            let annotation = ImageAnnotation(coordinate: location.coordinate, image: image, title: nil)
            mapView.addAnnotation(annotation)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ImageAnnotation {
            let identifier = "imageAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            // 이미지 크기 조절
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            annotation.image.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKClusterAnnotation {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 2
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }


}



class ImageAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var title: String?

    
    init(coordinate: CLLocationCoordinate2D, image: UIImage, title: String?) {
        self.coordinate = coordinate
        self.image = image
        self.title = title
    }
}
 */

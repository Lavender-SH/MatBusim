//
//  ReviewViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/03.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift
import Cosmos


class ReviewViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let reviewView = ReviewView()
    var placeName: String?
    var placeURL: String?
    
    //Realm 관련 변수
    var reviewItems: Results<ReviewTable>!
    let realm = try! Realm()
    let repository = ReviewTableRepository()
    
    override func loadView() {
        self.view = reviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        reviewView.storeNameLabel.text = placeName
        reviewView.internetButton.setTitle(placeURL, for: .normal)
        reviewView.internetButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        reviewView.imageView1.addGestureRecognizer(tapGesture1)
        reviewView.imageView1.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        reviewView.imageView2.addGestureRecognizer(tapGesture2)
        reviewView.imageView2.isUserInteractionEnabled = true
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture3)
    }
    
    override func configureView() {
        reviewView.dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        reviewView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        reviewView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc func dateButtonTapped() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        
        
        let datePickerSize = datePicker.sizeThatFits(CGSize.zero)
        datePicker.frame = CGRect(x: (alertController.view.bounds.size.width - datePickerSize.width) * 0.5, y: 20, width: datePickerSize.width, height: datePickerSize.height)
        
        alertController.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "저장", style: .default) { _ in
            
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            let dateString = formatter.string(from: selectedDate)
            
            self.reviewView.dateButton.setTitle("  \(dateString)", for: .normal)
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func openWebView() {
        guard var urlString = placeURL else {
            print("Invalid URL")
            return
        }
        if urlString.starts(with: "http://") {
            urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let webVC = WebViewController(url: url)
        //let navVC = UINavigationController(rootViewController: webVC)
        present(webVC, animated: true, completion: nil)
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.view.tag = tappedImageView.tag
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if picker.view.tag == reviewView.imageView1.tag {
                reviewView.imageView1.image = selectedImage
            } else if picker.view.tag == reviewView.imageView2.tag {
                reviewView.imageView2.image = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @objc func cancelButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        // 1. 입력된 정보를 가져옵니다.
        guard let storeName = reviewView.storeNameLabel.text,
              let internetSettle = reviewView.internetButton.title(for: .normal),
              let dateString = reviewView.dateButton.title(for: .normal),
              let memo = reviewView.memoTextView.text else {
            print("Error: Missing data")
            return
        }
        
        // 2. 별점 정보를 가져옵니다.
        let starCount = reviewView.cosmosView.rating
        
        // 3. 날짜 정보를 Date 형식으로 변환합니다.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        guard let reviewDate = formatter.date(from: dateString.trimmingCharacters(in: .whitespaces)) else {
            print("Error: Invalid date format")
            return
        }
        
        // 4. 이미지 정보를 Data 형식으로 변환합니다.
        let imageView1Data = reviewView.imageView1.image?.pngData()
        let imageView2Data = reviewView.imageView2.image?.pngData()
        
        // 5. ReviewTable 객체를 생성합니다.
        let review = ReviewTable(storeName: storeName, internetSettle: internetSettle, starCount: starCount, rateNumber: starCount, reviewDate: reviewDate, memo: memo, imageView1Data: imageView1Data, imageView2Data: imageView2Data)
        
        // 6. Realm에 저장합니다.
        repository.saveReview(review)
        
        // 7. 저장이 완료되면 화면을 닫습니다.
        dismiss(animated: true, completion: nil)
    }

    

}











//    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (String?) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
//            completion(nil)
//            return
//        }
//
//        let storageRef = Storage.storage().reference().child("reviews/\(UUID().uuidString).jpg")
//        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//            if let error = error {
//                print("Failed to upload image to Firebase Storage:", error)
//                completion(nil)
//                return
//            }
//
//            // 이미지 업로드가 성공한 후에만 다운로드 URL을 요청합니다.
//            storageRef.downloadURL { (url, error) in
//                if let error = error {
//                    print("Failed to get download URL:", error)
//                    completion(nil)
//                    return
//                }
//
//                completion(url?.absoluteString)
//            }
//        }
//    }


//        // 사용자 입력 데이터 가져오기
//        guard let storeName = reviewView.storeNameLabel.text,
//              let internetSettle = reviewView.internetButton.titleLabel?.text,
//              let dateString = reviewView.dateButton.titleLabel?.text?.trimmingCharacters(in: .whitespaces) else {
//            print("Error: Missing data")
//            return
//        }
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy년 MM월 dd일"
//        guard let date = formatter.date(from: dateString) else {
//            print("Error: Invalid date format")
//            return
//        }
//
//        let memo = reviewView.memoTextView.text ?? "" // 기본값 설정
//        let starCount = reviewView.cosmosView.rating
//        let rateNumber = Double(reviewView.rateNumberLabel.text ?? "0.0") ?? 0.0
//
//        let imageView1Data = reviewView.imageView1.image?.pngData()
//        let imageView2Data = reviewView.imageView2.image?.pngData()
//
//        // ReviewTable 객체 생성
//        uploadImageToFirebaseStorage(image: reviewView.imageView1.image!) { (url1) in
//            self.uploadImageToFirebaseStorage(image: self.reviewView.imageView2.image!) { (url2) in
//                let review = ReviewTable(storeName: storeName, internetSettle: internetSettle, starCount: starCount, rateNumber: rateNumber, reviewDate: date, memo: memo, imageView1Data: url1, imageView2Data: url2)
//
//                // 렘에 저장
//                do {
//                    try self.realm.write {
//                        self.realm.add(review)
//                    }
//                } catch {
//                    print("Error saving review to Realm: \(error)")
//                    return
//                }
//
//                // 저장 완료 후 화면 닫기
//                self.dismiss(animated: true, completion: nil)
//            }
//        }

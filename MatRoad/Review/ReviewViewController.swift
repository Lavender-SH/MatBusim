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
    var placeLatitude: String?
    var placeLongitude: String?
    var imageView1URL: String?
    var imageView2URL: String?
    var starCount: Double?
    var rateNumber: Double?
    var reviewDate: Date?
    var memo: String?
    
    
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
        //
        reviewView.cosmosView.rating = starCount ?? 0.0
        reviewView.rateNumberLabel.text = "\(rateNumber ?? 0.0)"
        if let date = reviewDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            let dateString = formatter.string(from: date)
            reviewView.dateButton.setTitle("  \(dateString)", for: .normal)
        }
        reviewView.memoTextView.text = memo

        //⭐️
        if let imageUrlString1 = imageView1URL, let imageUrl1 = URL(string: imageUrlString1) {
            reviewView.imageView1.kf.setImage(with: imageUrl1)
        }

        if let imageUrlString2 = imageView2URL, let imageUrl2 = URL(string: imageUrlString2) {
            reviewView.imageView2.kf.setImage(with: imageUrl2)
        }
        //
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
        guard let storeName = placeName,
              let internetSettle = placeURL,
              let reviewDateText = reviewView.dateButton.title(for: .normal),
              let memo = reviewView.memoTextView.text else {
            print("Some fields are missing!")
            return
        }
        
        // 2. 별점 정보를 가져옵니다.
        let starCount = reviewView.cosmosView.rating
        if starCount == 0 {
            showAlert(message: "별점을 입력해주세요!")
            return
        }
        
        let rateNumber = Double(reviewView.rateNumberLabel.text ?? "0.0") ?? 0.0
        
        // 3. 날짜 정보를 Date 형식으로 변환합니다.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        guard let reviewDate = formatter.date(from: reviewDateText) else {
            showAlert(message: "날짜를 입력해주세요!")
            return
        }
        
        // 4. 이미지 유효성 검사
        if reviewView.imageView1.image == nil {
            showAlert(message: "이미지를 넣어주세요!")
            return
        }
        
        // 5. 메모 유효성 검사
        if memo.isEmpty {
            showAlert(message: "메모를 남겨주세요!")
            return
        }
        
        // 6. 이미지 정보
        let imageView1Data = repository.saveImageToDocument(fileName: UUID().uuidString, image: reviewView.imageView1.image ?? UIImage())
        let imageView2Data = repository.saveImageToDocument(fileName: UUID().uuidString, image: reviewView.imageView2.image ?? UIImage())
        
        // 7. ReviewTable 객체를 생성합니다.
        let review = ReviewTable(storeName: storeName, internetSettle: internetSettle, starCount: starCount, rateNumber: rateNumber, reviewDate: reviewDate, memo: memo, imageView1URL: imageView1Data, imageView2URL: imageView2Data, latitude: placeLatitude, longitude: placeLongitude)
        
        // 8. Realm에 저장합니다.
        repository.saveReview(review)
        
        // 9. 저장이 완료되면 화면을 닫습니다.
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}

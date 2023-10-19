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
    //Realm 데이터
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
    var visitCount: Int?
    var memo: String?
    var isEditMode: Bool = false
    var selectedReviewId: ObjectId?
    //Realm 관련 변수
    var reviewItems: Results<ReviewTable>!
    let realm = try! Realm()
    let repository = ReviewTableRepository()
    //AlubmTable alubm 고유 _id
    var selectedAlbumId: ObjectId?
    
    
    override func loadView() {
        self.view = reviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //사이드메뉴바의 셀을 생성할때 받은 AlbumId를 UserDefault로 받아서 가져오기
        if let albumIdString = UserDefaults.standard.string(forKey: "selectedAlbumId"), let albumId = try? ObjectId(string: albumIdString) {
            selectedAlbumId = albumId
        } else {
            selectedAlbumId = nil
        }
        //print("==222==",selectedAlbumId ?? "nil")
        view.backgroundColor = .clear
        //초기 리뷰화면
        reviewView.storeNameLabel.text = placeName
        reviewView.internetButton.setTitle(placeURL, for: .normal)
        reviewView.cosmosView.rating = starCount ?? 0.0
        reviewView.rateNumberLabel.text = "\(rateNumber ?? 0.0)"
        if let date = reviewDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            let dateString = formatter.string(from: date)
            reviewView.dateButton.setTitle("  \(dateString)", for: .normal)
        }
        reviewView.memoTextView.text = memo
        //
        if let imageUrlString1 = imageView1URL, let imageUrl1 = URL(string: imageUrlString1) {
            reviewView.imageView1.kf.setImage(with: imageUrl1)
        }
        if let imageUrlString2 = imageView2URL, let imageUrl2 = URL(string: imageUrlString2) {
            reviewView.imageView2.kf.setImage(with: imageUrl2)
        }
        if let visitCount = visitCount {
            //reviewView.visitCountButton.setTitle("   \(visitCount)", for: .normal)
            reviewView.visitCountLabel.text = "Visits:   \(visitCount)"
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
        //메모에 입력되면 버튼의 색을 바꾸기 위해 델리게이트 설정
        reviewView.memoTextView.delegate = self
        
        //키보드 올라가면 화면 올리기
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func configureView() {
        reviewView.dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        reviewView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        reviewView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        reviewView.visitCountStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    
    }
    
    @objc func dateButtonTapped() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        
        let calendar = Calendar.current
        datePicker.minimumDate = calendar.date(from: DateComponents(year: 1980, month: 1, day: 1))
        datePicker.maximumDate = Date()
        
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
        
        updateSaveButtonBorderColor()
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - 방문횟수 얼럿 스타일
//    @objc func visitCountButtonTapped() {
//        let alertController = UIAlertController(title: "방문 횟수 선택", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        pickerView.dataSource = self
//
//        let pickerViewSize = pickerView.sizeThatFits(CGSize.zero)
//        pickerView.frame = CGRect(x: (alertController.view.bounds.size.width - pickerViewSize.width) * 0.5, y: 20, width:pickerViewSize.width, height: pickerViewSize.height)
//        alertController.view.addSubview(pickerView)
//
//        let okAction = UIAlertAction(title: "저장", style: .default) { _ in
//            let selectedRow = pickerView.selectedRow(inComponent: 0)
//            self.reviewView.visitCountButton.setTitle("   \(selectedRow + 1)", for: .normal)
//        }
//        alertController.addAction(okAction)
//
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @objc func stepperValueChanged(sender: UIStepper) {
        reviewView.visitCountLabel.text = "Visits:   \(Int(sender.value))"
    }

    
    // MARK: - 웹뷰 버튼 함수
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
        
        present(webVC, animated: true, completion: nil)
    }
    // MARK: - 이미지 피커 함수
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
            
            // 이미지 크기 조정
            let targetSize = CGSize(width: 500, height: 500)
            let scaledImage = selectedImage.scale(to: targetSize)
            
            if picker.view.tag == reviewView.imageView1.tag {
                reviewView.imageView1.image = scaledImage
            } else if picker.view.tag == reviewView.imageView2.tag {
                reviewView.imageView2.image = scaledImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 키보드 관련 함수
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3 // Adjust this value as needed
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func cancelButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 저장 ⭐️⭐️⭐️
    @objc func saveButtonTapped() {
        // 1. 입력된 정보를 가져옴.
        guard let storeName = placeName,
              let internetSettle = placeURL,
              let reviewDateText = reviewView.dateButton.title(for: .normal),
              let memo = reviewView.memoTextView.text else {
            print("Some fields are missing!")
            return
        }
        
        // 2. 별점 정보를 가져옴
        let starCount = reviewView.cosmosView.rating
        if starCount == 0 {
            showAlert(message: "별점을 입력해주세요!")
            return
        }
        let rateNumber = Double(reviewView.rateNumberLabel.text ?? "0.0") ?? 0.0
        
        // 3. 날짜 정보를 Date 형식으로 변환
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
        
        //방문횟수
//        let visitCountText = reviewView.visitCountButton.title(for: .normal)
//        guard let visitCount = Int(visitCountText?.trimmingCharacters(in: .whitespaces) ?? "") else {
//            showAlert(message: "방문 횟수를 입력해주세요!")
//            return
//        }
        
//        let visitCountText = reviewView.visitCountButton.title(for: .normal)
//        let visitCountText = "Visits:   \(Int(reviewView.visitCountStepper.value))"
//           guard let visitCount = Int(visitCountText) else {
//               showAlert(message: "방문 횟수를 입력해주세요!")
//               return
//           }
        let visitCount = Int(reviewView.visitCountStepper.value)


        
        // 7. ReviewTable 객체를 생성.
        let review = ReviewTable(storeName: storeName, internetSettle: internetSettle, starCount: starCount, rateNumber: rateNumber, reviewDate: reviewDate, memo: memo, imageView1URL: imageView1Data, imageView2URL: imageView2Data, latitude: placeLatitude, longitude: placeLongitude, visitCount: visitCount)
        
        // 8. Realm에 저장.
        if isEditMode, let id = selectedReviewId, let existingReview = repository.fetch().first(where: { $0._id == id }) {
            // 기존 리뷰를 수정.
            repository.updateOrSaveReview(review: review, isEditMode: true, existingReview: existingReview)
        } else if selectedAlbumId == nil { // selectedAlbumId가 nil일 때만 ReviewTable에 저장
            // 새 리뷰를 저장.
            repository.saveReview(review)
        }
        
        //새로운 앨범에 저장할 경우
        //print("===333===", selectedAlbumId)
        if let albumId = selectedAlbumId, !isEditMode {
            
            if let album = realm.object(ofType: AlbumTable.self, forPrimaryKey: albumId) {
                let newReview = ReviewTable()
                newReview.storeName = storeName
                newReview.internetSettle = internetSettle
                newReview.reviewDate = reviewDate
                newReview.starCount = starCount
                newReview.rateNumber = rateNumber
                newReview.memo = memo
                newReview.imageView1URL = imageView1Data
                newReview.imageView2URL = imageView2Data
                newReview.visitCount = visitCount
                newReview.longitude = placeLongitude
                newReview.latitude = placeLatitude
                
                try! realm.write {
                    album.reviews.append(newReview)
                }
            }
        }
        // 9. 저장이 완료
        dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //조건이 만족되면 저장버튼의 색깔을 바꿈
    func updateSaveButtonBorderColor() {
        if reviewView.cosmosView.rating > 0,
           reviewView.dateButton.title(for: .normal) != "  맛집을 방문한 날짜를 입력해보세요.",
           reviewView.memoTextView.text.count >= 1 {
            reviewView.saveButton.layer.borderColor = UIColor.white.cgColor
            reviewView.saveButton.setTitleColor(.white, for: .normal)
        } else {
            reviewView.saveButton.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    
    
}
//이미지 사이즈 조절
extension UIImage {
    func scale(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
//메모에 입력되면 저장버튼 색 바꾸기
extension ReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonBorderColor()
    }
}

extension ReviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}


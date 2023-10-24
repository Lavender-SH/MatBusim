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
//        if let date = reviewDate {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy년 MM월 dd일"
//            let dateString = formatter.string(from: date)
//            reviewView.dateButton.setTitle("  \(dateString)", for: .normal)
//        }
        
        let currentDate = reviewDate ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = formatter.string(from: currentDate)
        reviewView.dateButton.setTitle("  \(dateString)", for: .normal)
        
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
            reviewView.visitCountLabel.text = "방문횟수:  \(visitCount)"
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
        
        let storeNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebView))
        reviewView.storeNameLabel.isUserInteractionEnabled = true
        reviewView.storeNameLabel.addGestureRecognizer(storeNameTapGesture)

        //메모에 입력되면 버튼의 색을 바꾸기 위해 델리게이트 설정
        reviewView.memoTextView.delegate = self
        //별점이 바뀌면 버튼의 색이 바뀜
        reviewView.onRatingChanged = { [weak self] in
                self?.updateSaveButtonBorderColor()
            }

        
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
        //datePicker.date = Date()
        datePicker.date = reviewDate ?? Date()

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
        reviewView.visitCountLabel.text = "방문횟수:  \(Int(sender.value))"
        updateSaveButtonBorderColor()
    }

    
    // MARK: - 웹뷰 버튼 함수
    @objc func openWebView() {
        guard var urlString = placeURL else {
            //print("Invalid URL")
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
            
            // 회전 방향 선택 액션 시트 표시
            let alertController = UIAlertController(title: "이미지 회전", message: "회전할 방향을 선택하세요.", preferredStyle: .actionSheet)
            
            // 원본 그대로 옵션 추가
            alertController.addAction(UIAlertAction(title: "원본 그대로", style: .default, handler: { _ in
                self.setImage(scaledImage!, forTag: picker.view.tag)
            }))
            
            alertController.addAction(UIAlertAction(title: "오른쪽으로 90도", style: .default, handler: { _ in
                self.setImage(scaledImage!.rotated(by: .pi / 2)!, forTag: picker.view.tag)
            }))
            alertController.addAction(UIAlertAction(title: "왼쪽으로 90도", style: .default, handler: { _ in
                self.setImage(scaledImage!.rotated(by: -.pi / 2)!, forTag: picker.view.tag)
            }))
            alertController.addAction(UIAlertAction(title: "180도", style: .default, handler: { _ in
                self.setImage(scaledImage!.rotated(by: .pi)!, forTag: picker.view.tag)
            }))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            picker.present(alertController, animated: true, completion: nil)
        }
    }


    func setImage(_ image: UIImage, forTag tag: Int) {
        if tag == reviewView.imageView1.tag {
            reviewView.imageView1.image = image
            reviewView.infoLabel.isHidden = true
        } else if tag == reviewView.imageView2.tag {
            reviewView.imageView2.image = image
            reviewView.infoLabel2.isHidden = true
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
                self.view.frame.origin.y -= keyboardSize.height / 1.2
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
    
    @objc func saveButtonTapped() {
        // 1. 입력된 정보를 가져옴.
        let storeName = placeName ?? ""
        let internetSettle = placeURL ?? ""
        let reviewDateText = reviewView.dateButton.title(for: .normal) ?? ""
        let memo = reviewView.memoTextView.text ?? ""
        
        // 2. 별점 정보를 가져옴
        let starCount = reviewView.cosmosView.rating
        let rateNumber = Double(reviewView.rateNumberLabel.text ?? "0.0") ?? 0.0
        
        // 3. 날짜 정보를 Date 형식으로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let reviewDate = formatter.date(from: reviewDateText) ?? Date()
        
        // 4. 이미지 정보
        let imageView1Data = reviewView.imageView1.image != nil ? repository.saveImageToDocument(fileName: UUID().uuidString, image: reviewView.imageView1.image!) : nil
        let imageView2Data = reviewView.imageView2.image != nil ? repository.saveImageToDocument(fileName: UUID().uuidString, image: reviewView.imageView2.image!) : nil
        
        let visitCount = Int(reviewView.visitCountStepper.value)
        
        // 5. ReviewTable 객체를 생성.
        let review = ReviewTable(storeName: storeName, internetSettle: internetSettle, starCount: starCount, rateNumber: rateNumber, reviewDate: reviewDate, memo: memo, imageView1URL: imageView1Data, imageView2URL: imageView2Data, latitude: placeLatitude, longitude: placeLongitude, visitCount: visitCount)
        
        // 6. Realm에 저장.
        if isEditMode, let id = selectedReviewId, let existingReview = repository.fetch().first(where: { $0._id == id }) {
            // 기존 리뷰를 수정.
            repository.updateOrSaveReview(review: review, isEditMode: true, existingReview: existingReview)
        } else if selectedAlbumId == nil { // selectedAlbumId가 nil일 때만 ReviewTable에 저장
            // 새 리뷰를 저장.
            repository.saveReview(review)
        }
        
        //새로운 앨범에 저장할 경우
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
        // 7. 저장이 완료
        dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("ReviewUpdated"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("ReviewSavedFromSearch"), object: nil)
    }

    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateSaveButtonBorderColor() {
        if hasReviewChanged() {
            reviewView.saveButton.layer.borderColor = UIColor(named: "gold")?.cgColor
            reviewView.saveButton.setTitleColor(UIColor(named: "gold"), for: .normal)
            reviewView.saveButton.layer.borderWidth = 2.5
            reviewView.saveButton.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 21.0) //UIFont.boldSystemFont(ofSize: 21)
        } else {
            reviewView.saveButton.layer.borderColor = UIColor.darkGray.cgColor
        }
    }

    
    func hasReviewChanged() -> Bool {
        if reviewView.cosmosView.rating != starCount { return true }
        if let dateTitle = reviewView.dateButton.title(for: .normal), dateTitle != "  \(reviewDate?.description ?? "")" { return true }
        if reviewView.memoTextView.text != memo { return true }
        if Int(reviewView.visitCountStepper.value) != visitCount { return true }
        return false
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


// MARK: - 이미지 회전 확장
extension UIImage {
    func rotated(by radians: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

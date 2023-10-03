//
//  ReviewViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/03.
//

import UIKit

class ReviewViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let reviewView = ReviewView()
    var placeName: String?
    var placeURL: String?
    
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



    
    
    
}

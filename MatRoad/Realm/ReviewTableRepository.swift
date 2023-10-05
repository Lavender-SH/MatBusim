//
//  ReviewTableRepository.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/04.
//

import UIKit
import Foundation
import RealmSwift

protocol ReviewTableRepositoryType: AnyObject {
    func fetch() -> Results<ReviewTable>
    func saveReview(_ review: ReviewTable)
    func deleteReview(_ review: ReviewTable)
    func findFileURL() -> URL?
    func saveImageToDocument(fileName: String, image: UIImage) -> String?
}

class ReviewTableRepository: ReviewTableRepositoryType {
    private let realm = try! Realm()
    
    // 데이터 가져오기
    func fetch() -> Results<ReviewTable> {
        let data = realm.objects(ReviewTable.self).sorted(byKeyPath: "reviewDate", ascending: true)
        return data
    }
    
    // 리뷰 저장
    func saveReview(_ review: ReviewTable) {
        try! realm.write {
            realm.add(review)
        }
    }
    
    // 리뷰 삭제
    func deleteReview(_ review: ReviewTable) {
        try! realm.write {
            realm.delete(review)
        }
    }
    
    // 파일 경로
    func findFileURL() -> URL? {
        let fileURL = realm.configuration.fileURL
        return fileURL
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) -> String? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        do {
            try data.write(to: fileURL)
            return fileURL.absoluteString
        } catch let error {
            print("file save error: ", error)
            return nil
        }
    }
    
    func updateOrSaveReview(review: ReviewTable, isEditMode: Bool, existingReview: ReviewTable?) {
        if isEditMode, let existing = existingReview {
            // Update existing review
            try! realm.write {
                existing.starCount = review.starCount
                existing.rateNumber = review.rateNumber
                existing.reviewDate = review.reviewDate
                existing.memo = review.memo
                existing.imageView1URL = review.imageView1URL
                existing.imageView2URL = review.imageView2URL
            }
        } else {
            // Save new review
            saveReview(review)
        }
    }



}



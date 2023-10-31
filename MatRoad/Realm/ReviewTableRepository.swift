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
    
    //이미지 저장
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
    //리뷰 수정
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
                existing.visitCount = review.visitCount
            }
        } else {
            // Save new review
            saveReview(review)
        }
    }
    
    // 앨범 저장
    func saveAlbum(_ album: AlbumTable) {
        try! realm.write {
            realm.add(album)
        }
    }
    
    //데이터 복사o 이동x ⭐️⭐️⭐️
//    func transferReviews(from currentAlbumName: String?, to targetAlbumName: String, reviews: [ReviewTable]) -> Bool {
//        guard let targetAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", targetAlbumName).first else {
//            return false
//        }
//        
//        try! realm.write {
//            for review in reviews {
//                if let currentAlbumName = currentAlbumName, let currentAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", currentAlbumName).first {
//                    currentAlbum.reviews.remove(at: currentAlbum.reviews.index(of: review)!)
//                }
//                targetAlbum.reviews.append(review)
//            }
//        }
//        return true
//    }
    
    
    //초기화
    func clearAllData() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    

    

    

}



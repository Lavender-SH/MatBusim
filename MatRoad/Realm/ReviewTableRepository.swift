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
    
    // 리뷰를 특정 앨범에 저장
    func saveReviewToAlbum(_ review: ReviewTable, album: AlbumTable) {
        try! realm.write {
            album.reviews.append(review)
        }
    }
    
    
    func fetchReviewById(reviewId: ObjectId) -> ReviewTable? {
        return realm.object(ofType: ReviewTable.self, forPrimaryKey: reviewId)
    }
    
    func saveIDToReviews(_ id: ObjectId) {
        let newReview = ReviewTable()
        newReview._id = id
        try! realm.write {
            realm.add(newReview)
        }
    }
    func saveReviewToSpecificAlbum(_ review: ReviewTable, albumId: ObjectId) {
        guard let album = realm.object(ofType: AlbumTable.self, forPrimaryKey: albumId) else { return }
        try! realm.write {
            album.reviews.append(review)
        }
    }
    
    //Album
    func fetchAlbums() -> Results<AlbumTable> {
        let data = realm.objects(AlbumTable.self)
        return data
    }

    func fetchReviews(from album: AlbumTable) -> List<ReviewTable> {
        return album.reviews
    }
    
    //⭐️데이터 이동 ReviewTable -> AlbumTable
//    func addReviewToAlbum(review: ReviewTable, albumId: ObjectId) {
//        guard let album = realm.object(ofType: AlbumTable.self, forPrimaryKey: albumId) else {
//            return
//        }
//        // Check if the review is already linked to the album
//        if !review.albums.contains(album) {
//            try! realm.write {
//                album.reviews.append(review)
//            }
//        }
//    }
    
    //이름으로 앨범찾기
    func fetchAlbumByName(albumName: String) -> AlbumTable? {
        return realm.objects(AlbumTable.self).filter("albumName == %@", albumName).first
    }
    //앨범끼리의 데이터 이동 AlbumTable -> AlbumTable
    func moveReview(reviewId: ObjectId, fromAlbumName sourceAlbumName: String, toAlbumName targetAlbumName: String) {
        guard let sourceAlbum = fetchAlbumByName(albumName: sourceAlbumName), let targetAlbum = fetchAlbumByName(albumName: targetAlbumName) else {
            return
        }

        guard let review = fetchReviewById(reviewId: reviewId) else {
            return
        }

        try! realm.write {
            if let index = sourceAlbum.reviews.index(of: review) {
                sourceAlbum.reviews.remove(at: index)
                targetAlbum.reviews.append(review)
            }
        }
    }





}

extension ReviewTableRepository {
    // This function moves a review from ReviewTable to a specific Album in AlbumTable
    func moveReviewToAlbum(reviewId: ObjectId, toAlbumId: ObjectId) {
        // Fetch the review from ReviewTable using its _id
        guard let review = fetchReviewById(reviewId: reviewId) else {
            print("Review not found!")
            return
        }
        
        // Fetch the target album from AlbumTable using its _id
        guard let targetAlbum = realm.object(ofType: AlbumTable.self, forPrimaryKey: toAlbumId) else {
            print("Album not found!")
            return
        }
        
        // Associate the fetched review with the fetched album
        try! realm.write {
            targetAlbum.reviews.append(review)
        }
    }
}



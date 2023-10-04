//
//  ReviewTableRepository.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/04.
//

import Foundation
import RealmSwift

protocol ReviewTableRepositoryType: AnyObject {
    func fetch() -> Results<ReviewTable>
    func saveReview(_ review: ReviewTable)
    func deleteReview(_ review: ReviewTable)
    func findFileURL() -> URL?
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
}

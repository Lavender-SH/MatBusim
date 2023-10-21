//
//  RealmModel.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/04.
//

import Foundation
import RealmSwift

class ReviewTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var storeName: String
    @Persisted var internetSettle: String
    @Persisted var starCount: Double
    @Persisted var rateNumber: Double
    @Persisted var reviewDate: Date
    @Persisted var memo: String
    @Persisted var imageView1URL: String?  // 이미지 데이터 대신 이미지의 파일 경로(URL)를 저장
    @Persisted var imageView2URL: String?  // 이미지 데이터 대신 이미지의 파일 경로(URL)를 저장
    @Persisted var latitude: String?  // 위도
    @Persisted var longitude: String? // 경도
    @Persisted var visitCount: Int?
    // In ReviewTable class
    @Persisted var albums: LinkingObjects<AlbumTable> = LinkingObjects(fromType: AlbumTable.self, property: "reviews")





    convenience init(storeName: String, internetSettle: String, starCount: Double, rateNumber: Double, reviewDate: Date, memo: String, imageView1URL: String?, imageView2URL: String?, latitude: String?, longitude: String?, visitCount: Int?) {
        self.init()
        
        self.storeName = storeName
        self.internetSettle = internetSettle
        self.starCount = starCount
        self.rateNumber = rateNumber
        self.reviewDate = reviewDate
        self.memo = memo
        self.imageView1URL = imageView1URL
        self.imageView2URL = imageView2URL
        self.latitude = latitude
        self.longitude = longitude
        self.visitCount = visitCount
    }

}

class AlbumTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var albumName: String
    @Persisted var reviews: List<ReviewTable> // To-Many Relationship
    
    convenience init(albumName: String) {
        self.init()
        self.albumName = albumName
    }
}






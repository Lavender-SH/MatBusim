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
    @Persisted var imageView1Data: Data?
    @Persisted var imageView2Data: Data?

    convenience init(storeName: String, internetSettle: String, starCount: Double, rateNumber: Double, reviewDate: Date, memo: String, imageView1Data: Data?, imageView2Data: Data?) {
        self.init()
        
        self.storeName = storeName
        self.internetSettle = internetSettle
        self.starCount = starCount
        self.rateNumber = rateNumber
        self.reviewDate = reviewDate
        self.memo = memo
        self.imageView1Data = imageView1Data
        self.imageView2Data = imageView2Data
    }
}


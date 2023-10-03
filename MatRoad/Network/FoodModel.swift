//
//  FoodModel.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/02.
//

import Foundation

// MARK: - Welcome
struct Food: Decodable {
    let documents: [Document]
}
// MARK: - Document
struct Document: Decodable {
    let addressName: String?
    //let categoryGroupName: CategoryGroupName
    let categoryName: String?
    let phone: String?
    let placeName: String?
    let placeURL: String?
    let roadAddressName: String?
    let x: String?
    let y: String?

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        //case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x
        case y
    }
    var finalCategory: String? {
        return categoryName?.split(separator: ">").last?.trimmingCharacters(in: .whitespaces) ?? ""
    }
}

//enum CategoryGroupName: String, Decodable {
//    case 음식점 = "음식점"
//    case 카페 = "카페"
//}


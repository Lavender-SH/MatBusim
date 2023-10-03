//
//  NetworkManager.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/02.
//
import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func searchPlaceCallRequest(query: String, page: Int = 1, size: Int = 45, completion: @escaping ([Document]?) -> Void) {
        
        var parameters: [String: Any] = ["query": query]
        
        let baseURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let header: HTTPHeaders = [
            "Authorization": "KakaoAK \(APIKey.key)",
            "Content-Type": "application/json; charset=UTF-8"]
        
        AF.request(baseURL, method: .get, parameters: parameters, headers: header).validate(statusCode: 200...500).responseDecodable(of: Food.self) { response in
            //print("===555===", response.value)
            if let statusCode = response.response?.statusCode {
            //print("===1111===Status Code: \(statusCode)")
            }
            
            switch response.result {
            case .success(let value):
                completion(value.documents)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}





//if let categoryGroupCode = categoryGroupCode {
//    parameters["category_group_code"] = categoryGroupCode
//}
//if let x = x {
//    parameters["x"] = x
//}
//if let y = y {
//    parameters["y"] = y
//}
//if let radius = radius {
//    parameters["radius"] = radius
//}
//if let rect = rect {
//    parameters["rect"] = rect
//}
//if let page = page {
//    parameters["page"] = page
//}
//if let size = size {
//    parameters["size"] = size
//}
//if let sort = sort {
//    parameters["sort"] = sort
//}

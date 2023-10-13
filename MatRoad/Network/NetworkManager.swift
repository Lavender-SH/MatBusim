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
                let filteredDocuments = value.documents.filter { $0.categoryGroupCode == .fd6 || $0.categoryGroupCode == .ce7 }
                        completion(filteredDocuments)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}


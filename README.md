# 맛슐랭 - 나만의 맛집 컬렉션 


<img src="https://github.com/user-attachments/assets/76ed30a0-e006-4cd1-aadb-5dfa34887178" width="25%">


- [맛슐랭 - 나만의 맛집 컬렉션 앱스토어 링크](https://apps.apple.com/kr/app/%EB%A7%9B%EC%8A%90%EB%9E%AD-%EB%82%98%EB%A7%8C%EC%9D%98-%EB%A7%9B%EC%A7%91-%EC%BB%AC%EB%A0%89%EC%85%98/id6470218238)</br>

- [맛슐랭 프로젝트 기획서](https://www.notion.so/130f3da005f180ba966ae83146764414?pvs=4)</br>

- [맛슐랭 개인정보 처리 방침](https://www.notion.so/5830260f9fef4317902134e9362bfcb1?pvs=4)</br>

</br>


## 프로젝트 소개
### 앱 설명
 - 맛슐랭은 맛집을 사랑하는 사용자들을 위해 설계된 앱으로, 방문한 맛집을 기록하고, 나만의 미식 지도를 만들어 특별한 추억을 간직할 수 있도록 돕습니다. 
 - 여러분은 직접 맛집에 "맛슐랭 스타"를 부여하며, 나만의 미식 기준을 만들어갈 수 있습니다. 이 앱은 단순히 정보를 기록하는 것을 넘어, 여러분의 미식 여정을 시각적으로 표현하고, 추억을 공유하며, 새로운 경험을 발견할 수 있도록 설계되었습니다.

 - 사진과 리뷰를 통해 맛집을 한눈에 관리하고, 지도 기반으로 나만의 미식 지도를 만들어보세요. AI 추천 기능은 여러분의 취향에 딱 맞는 새로운 맛집을 소개하며, 미식 여행의 즐거움을 더해줍니다.
 - 맛슐랭과 함께라면, 평범한 하루도 특별한 미식 경험으로 바뀌게 됩니다. 맛있는 순간을 기록하고, 새로운 미식 세계를 탐험해보세요!

<img src="https://github.com/user-attachments/assets/47da9767-ff0f-43cd-bfb9-65dd08e17e58" width="100%">
</br>

### 성과
 - 앱스토어 음식 카테고리 차트 최고 순위 30위
 - MAU 평균 200명, 다운로드 수 1200회
 - 평균 별점 (4.8/5.0)점
</br>

<img src="https://github.com/user-attachments/assets/16ac7c47-c6b3-4fd5-aae5-fc2ee86ac75e" width="100%">

<img src="https://github.com/user-attachments/assets/33e66f98-f950-40c0-b0b7-0c09848bf472" width="100%">

</br>

### 프로젝트 기간
- 2024.10.01 ~ 2024.11.1 (4주) + 현재 진행중 </br>
</br>

### 프로젝트 참여 인원
- 개인(1인) 프로젝트</br>
</br>

### 향후 계획
서버와 AI 기술을 도입하여 맛슐랭 2.0 버전을 개발할 계획입니다.</br>

- [맛슐랭 프로젝트 기획서](https://www.notion.so/130f3da005f180ba966ae83146764414?pvs=4)</br>

- AI 추천 기능 강화: 사용자 리뷰 및 방문 기록을 분석하여 개인화된 맛집 추천 기능을 제공합니다.</br>
- 서버 기반 데이터 관리: 사용자 데이터를 안전하게 저장하고, 여러 기기 간 동기화 기능을 지원합니다.</br>
- 소셜 네트워크 확장: 사용자가 친구와 맛집 정보를 공유하고 서로의 컬렉션을 탐색할 수 있는 소셜 기능을 추가합니다.</br>

</br>

## 기술 스택

- **Framework**
`UIKit`, `RXSwift`, `RealmSwift`, `MapKit`,  `Alamofire`, `Kingfisher`, `WebKit`, `Zip`, `PhotosUI`, `SideMenu` ,`SnapKit`, `MessageUI`, `Cosmos`, `Firebase Analytics`, `Firebase Crashlytics`

- **Design Pattern**
`MVVM`, `MVC`

</br>

## 핵심 기능과 코드 설명

- **1.맛집을 기록하고 관리하는 기능**</br>
`RealmSwift`로 데이터베이스 구성</br>
1-1. Realm 모델에 리뷰로 저장할 내용 정의</br>
1-2. Realm Repository를 활용한 CRUD 구현</br>
1-3. 데이터를 별점순, 시간순, 방문순 정렬하는 기능</br>

- **2.나만의 맛집 앨범을 만들어 카테고리를 분류하는 기능**</br>
 2-1. To-Many Relationship을 활용한 앨범 생성 기능</br>
 2-2. 사이드 메뉴바 라이브러리를 사용하여 카테고리 탐색 지원 </br>

- **3.WebView를 사용하여 음식점 사이트로 바로 이동하는 기능**</br>

- **4.지도위에 나만의 맛집을 볼 수 있는 기능**</br>
 4-1. MapKit의 Annotation을 활용하여 지도에 핀을 사진으로 표현</br>
 4-2. SearchBar를 사용하여 저장한 맛집을 검색할 수 있는 기능</br>

- **5. 백업 파일 생성 및 공유/복구 기능**</br>

- **6.앱에서 직접 이메일을 통해 문의나 의견을 수집할 수 있는 기능**</br>

</br>

 ### 1. 맛집을 기록하고 관리하는 기능
 이 기능은 사용자가 맛집 리뷰를 체계적으로 기록하고, 데이터를 직관적으로 관리할 수 있도록 설계되었습니다. RealmSwift 기반의 데이터베이스와 직관적인 정렬/검색 기능은 사용자 경험을 극대화하며, 앨범 관리와 이미지 파일 처리 등 상세한 기능은 앱의 유용성을 한층 더 높였습니다.</br>
 
 ### 1-1. Realm 모델에 리뷰로 저장할 내용 정의
  - 맛집 리뷰를 저장할 ReviewTable과 앨범 관리를 위한 AlbumTable 클래스 정의</br>
  - 리뷰 데이터에는 별점, 방문 횟수, 메모, 이미지 경로, 위치 정보(위도/경도) 등이 포함됨</br>
  - 앨범과 리뷰 간의 To-Many 관계를 설정하여 앨범별 리뷰를 관리</br>
  
``` swift
class ReviewTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var storeName: String
    @Persisted var starCount: Double
    @Persisted var reviewDate: Date
    @Persisted var memo: String
    @Persisted var imageView1URL: String?  // 이미지 경로
    @Persisted var visitCount: Int?
    @Persisted var album: LinkingObjects<AlbumTable> = LinkingObjects(fromType: AlbumTable.self, property: "reviews")
}

class AlbumTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var albumName: String
    @Persisted var reviews: List<ReviewTable>  // To-Many 관계
}

```
</br>

 ### 1-2. Realm Repository를 활용한 CRUD 구현</br>
 ReviewTableRepository는 맛집 리뷰 데이터를 효율적으로 관리하기 위해 설계되었습니다. CRUD 작업 외에도 이미지 파일 저장 및 삭제, 데이터 초기화와 같은 유틸리티 기능을 포함하여 사용자의 편리한 데이터 관리를 지원합니다. 이러한 세부 구현은 앱이 데이터를 신뢰성 있게 처리하고, 사용자 경험을 향상시키는 데 기여합니다.</br>
  </br>
 
 1. 읽기(Read)
 - 모든 리뷰 데이터를 불러오거나 특정 조건에 맞는 데이터를 필터링</br>
 - 데이터를 정렬(별점순, 리뷰 날짜순, 방문 횟수순)하여 제공</br>
 2. 생성 및 저장 (Create)
 - 새 리뷰를 저장하고 앨범과 연계</br>
 3. 수정(Update)
 - 기존 리뷰 데이터를 업데이트</br>
 4. 삭제(Delete)
 - 리뷰 삭제 시 관련 이미지 파일도 함께 제거</br>
 5. 유틸리티 기능
 - 데이터 초기화, 이미지 저장/관리, 파일 경로 검색 기능</br>
    
 ``` swift
 class ReviewTableRepository: ReviewTableRepositoryType {
    private let realm = try! Realm()
    
    // **읽기 (Read)**
    func fetch() -> Results<ReviewTable> {
        return realm.objects(ReviewTable.self).sorted(byKeyPath: "reviewDate", ascending: false)
    }

    // **생성 및 저장 (Create)**
    func saveReview(_ review: ReviewTable) {
        try! realm.write {
            realm.add(review)
        }
    }

    // **수정 (Update)**
    func updateReview(_ existingReview: ReviewTable, with updatedReview: ReviewTable) {
        try! realm.write {
            existingReview.starCount = updatedReview.starCount
            existingReview.memo = updatedReview.memo
            existingReview.reviewDate = updatedReview.reviewDate
            existingReview.imageView1URL = updatedReview.imageView1URL
            existingReview.visitCount = updatedReview.visitCount
        }
    }

    // **삭제 (Delete)**
    func deleteReview(_ review: ReviewTable) {
        try! realm.write {
            // 리뷰 삭제 전에 관련 이미지 제거
            if let imageURL = review.imageView1URL {
                removeImageFromDocument(imageURL: imageURL)
            }
            realm.delete(review)
        }
    }

    // **이미지 파일 저장**
    func saveImageToDocument(fileName: String, image: UIImage) -> String? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        do {
            try data.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            print("Image save error: \(error)")
            return nil
        }
    }

    // **이미지 파일 삭제**
    func removeImageFromDocument(imageURL: String) {
        if let filePath = URL(string: imageURL)?.path {
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }

    // **데이터 초기화**
    func clearAllData() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

``` 
</br>

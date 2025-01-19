# 맛슐랭 - 나만의 맛집 컬렉션 


<img src="https://github.com/user-attachments/assets/76ed30a0-e006-4cd1-aadb-5dfa34887178" width="25%">


- [맛슐랭 - 나만의 맛집 컬렉션 앱스토어 링크](https://apps.apple.com/kr/app/%EB%A7%9B%EC%8A%90%EB%9E%AD-%EB%82%98%EB%A7%8C%EC%9D%98-%EB%A7%9B%EC%A7%91-%EC%BB%AC%EB%A0%89%EC%85%98/id6470218238)</br>

- [맛슐랭 - 2.0 서버 버전 유튜브 영상](https://youtu.be/B3ehN8v3Gq0)</br>

- [맛슐랭 - 2.0 서버 버전 깃허브 링크](https://github.com/Lavender-SH/MatchelinServer-RX-MVVM)</br>

- [맛슐랭 프로젝트 기획서](https://windy-elf-2bc.notion.site/130f3da005f180ba966ae83146764414)</br>

- [맛슐랭 개인정보 처리 방침](https://www.notion.so/5830260f9fef4317902134e9362bfcb1?pvs=4)</br>

</br>


## 맛슐랭 프로젝트 소개
### 앱 설명
 - 맛슐랭은 맛집을 사랑하는 사용자들을 위해 설계된 앱으로, 방문한 맛집을 기록하고, 나만의 미식 지도를 만들어 특별한 추억을 간직할 수 있도록 돕습니다.
 
 - 여러분은 직접 맛집에 "맛슐랭 스타"를 부여하며, 나만의 미식 기준을 만들어갈 수 있습니다. 이 앱은 단순히 정보를 기록하는 것을 넘어, 여러분의 미식 여정을 시각적으로 표현하고, 추억을 공유하며, 새로운 경험을 발견할 수 있도록 설계되었습니다.

 - 사진과 리뷰를 통해 맛집을 한눈에 관리하고, 지도 기반으로 나만의 미식 지도를 만들어보세요.
 
 - 맛슐랭과 함께라면, 평범한 하루도 특별한 미식 경험으로 바뀌게 됩니다. 맛있는 순간을 기록하고, 새로운 미식 세계를 탐험해보세요!

<img src="https://github.com/user-attachments/assets/47da9767-ff0f-43cd-bfb9-65dd08e17e58" width="100%">
</br>

### 성과
 - 앱스토어 음식 카테고리 차트 최고 순위 30위
 - MAU 평균 200명, 다운로드 수 1200회
 - 평균 별점 (4.8/5.0)점
</br>

<img src="https://github.com/user-attachments/assets/16ac7c47-c6b3-4fd5-aae5-fc2ee86ac75e" width="100%">

</br>

<img src="https://github.com/user-attachments/assets/33e66f98-f950-40c0-b0b7-0c09848bf472" width="100%">

</br>

### 프로젝트 기간
- 2024.10.01 ~ 2024.11.1 (4주) + 현재 진행중 </br>
</br>

### 프로젝트 참여 인원
- 개인(1인) 프로젝트</br>
</br>

### 맛슐랭 2.0 서버 버전 ⭐️
현재 맛슐랭은 1.0의 성공을 기반으로, 서버와 AI 기술을 도입하여 더욱 발전된 2.0 버전을 개발 중입니다.</br>

- [맛슐랭 프로젝트 기획서](https://www.notion.so/130f3da005f180ba966ae83146764414?pvs=4)</br>

- 서버 기반 데이터 관리: 사용자 데이터를 안전하게 저장하고, 여러 기기 간 동기화 기능을 지원합니다.</br>
- 소셜 네트워크 확장: 사용자가 친구와 맛집 정보를 공유하고 서로의 컬렉션을 탐색할 수 있는 소셜 기능을 추가합니다.</br>
- AI 추천 기능 강화: 사용자 리뷰 및 방문 기록을 분석하여 개인화된 맛집 추천 기능을 제공합니다.</br>
</br>

<img src="https://github.com/user-attachments/assets/69c06379-6443-499b-98cd-5ee024f28471" width="100%">

</br>

## 기술 스택

- **Framework**
`UIKit`, `RXSwift`, `RealmSwift`, `MapKit`,  `Alamofire`, `Kingfisher`, `WebKit`, `Zip`, `PhotosUI`, `SideMenu` ,`SnapKit`, `MessageUI`, `Cosmos`, `Firebase Analytics`, `Firebase Crashlytics`

- **Design Pattern**
`MVVM`, `MVC`

</br>

## 맛슐랭 1.0 핵심 기능과 코드 설명

- **1. 맛집을 기록하고 관리하는 기능**</br>
`RealmSwift`로 데이터베이스 구성</br>
1-1. Realm 모델에 리뷰로 저장할 내용 정의</br>
1-2. Realm Repository를 활용한 CRUD 구현</br>
1-3. 데이터를 별점순, 시간순, 방문순 정렬하는 기능</br>

- **2. 나만의 맛집 앨범을 만들어 카테고리를 분류하는 기능**</br>
 2-1. To-Many Relationship을 활용한 앨범 생성 기능</br>
 2-2. 사이드 메뉴바 라이브러리를 사용하여 카테고리 탐색 지원 </br>
 
- **3. 음식점 검색 기능**</br>
 [3-1. 카카오 로컬 API 활용](https://developers.kakao.com/docs/latest/ko/local/dev-guide)</br>

- **4. WebView를 사용하여 음식점 사이트로 바로 이동하는 기능**</br>

- **5. 지도위에 나만의 맛집을 볼 수 있는 기능**</br>
 5-1. MapKit의 Annotation을 활용하여 지도에 핀을 사진으로 표현</br>
 5-2. 지도위의 핀을 클러스터링으로 구현</br>
 5-3. SearchBar를 사용하여 저장한 맛집을 검색할 수 있는 기능</br>

- **6. 백업 파일 생성 및 공유/복구 기능**</br>
 6-1. 백업 파일 생성 및 ZIP 파일로 압축</br>
 6-2. 백업 파일 복구 및 ZIP 해제</br>
 6-3. 백업 파일 공유</br>
 6-4. 백업 파일 삭제</br>

- **7. 앱에서 직접 이메일을 통해 문의나 의견을 수집할 수 있는 기능**</br>
 7-1. 이메일 작성 및 전송</br>
 7-2. 이메일 전송 결과 처리</br>
</br>

 ### 1. 맛집을 기록하고 관리하는 기능
 이 기능은 사용자가 맛집 리뷰를 체계적으로 기록하고, 데이터를 직관적으로 관리할 수 있도록 설계되었습니다. RealmSwift 기반의 데이터베이스와 직관적인 정렬/검색 기능은 사용자 경험을 극대화하며, 앨범 관리와 이미지 파일 처리 등 상세한 기능은 앱의 유용성을 한층 더 높였습니다.</br>
 
  <img src="https://github.com/user-attachments/assets/f4491b79-9c75-43fe-a793-af027d14738a" width="100%">
 
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

 ### 1-3. 데이터를 별점순, 시간순, 방문순 정렬하는 기능</br>

 - byKeyPath: starCount, reviewDate, visitCount 입력</br>

``` swift
func fetchSortedReviews(by key: String, ascending: Bool) -> Results<ReviewTable> {
    return realm.objects(ReviewTable.self).sorted(byKeyPath: key, ascending: ascending)
}

```
 </br>

 ### 2. 나만의 맛집 앨범을 만들어 카테고리를 분류하는 기능

이 기능은 사용자가 개인적으로 소중한 맛집 리뷰를 정리하는 데 강력한 도구를 제공하며, 이를 통해 사용자 만족도를 극대화하고 카테고리 기반 데이터 관리를 더욱 직관적으로 만듦으로써 사용자가 데이터를 쉽게 탐색하고 관리할 수 있도록 돕습니다.
 
 <img src="https://github.com/user-attachments/assets/6415e36a-2d8e-45a8-af5d-1ed37af758bf" width="50%">

 ### 2-1. To-Many Relationship을 활용한 앨범 생성 기능</br>
 1. 새로운 AlbumTable 인스턴스를 생성</br>
 2. Realm 데이터베이스에 저장</br>
 3. 새로운 앨범이 생성되면 사이드 메뉴와 연동되어 UI에 실시간 반영</br>
 
``` swift

class AlbumTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var albumName: String
    @Persisted var reviews: List<ReviewTable> // To-Many Relationship
    
    convenience init(albumName: String) {
        self.init()
        self.albumName = albumName
    }


@objc func addAlbumButtonTapped() {
    let alertController = UIAlertController(title: "새로운 앨범", message: "앨범 이름을 입력하세요.", preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = "앨범 이름"
    }
    let addAction = UIAlertAction(title: "추가", style: .default) { _ in
        guard let albumName = alertController.textFields?.first?.text, !albumName.isEmpty else { return }
        let newAlbum = AlbumTable(albumName: albumName)
        try! self.realm.write {
            self.realm.add(newAlbum)
        }
        self.sideMenuTableViewController.tableView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    alertController.addAction(addAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
}

```
 
 
### 2-2. 사이드 메뉴바 라이브러리를 사용하여 카테고리 탐색 지원 </br>
 - `SideMenu` 라이브러리를 사용하여 사용자 경험 향상
 - 사이드 메뉴에 표시되는 카테고리 목록(앨범 이름)
 - "+ 앨범 추가" 버튼을 통해 새로운 카테고리 생성 가능
 - `UITableView`를 사용하여 앨범 목록 표시
 

``` swift
func setupSideMenu() {
    sideMenuTableViewController = UITableViewController()
    sideMenuTableViewController.tableView.delegate = self
    sideMenuTableViewController.tableView.dataSource = self
    sideMenu = SideMenuNavigationController(rootViewController: sideMenuTableViewController)
    sideMenu?.leftSide = true
    SideMenuManager.default.leftMenuNavigationController = sideMenu
}

```
</br>
 
 - 선택한 앨범에 속한 리뷰만 필터링하여 표시
 - "모두 보기"를 선택하면 모든 리뷰를 보여줌
 - `UserDefaults`와 `Realm` 데이터베이스를 활용해 선택한 앨범 상태를 유지

``` swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedAlbum = albumNames[indexPath.row]
    if selectedAlbum == "모두 보기" {
        reviewItems = repository.fetch()
    } else if let matchingAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", selectedAlbum).first {
        reviewItems = repository.fetch().filter("ANY album._id == %@", matchingAlbum._id)
    }
    mainView.collectionView.reloadData()
    sideMenu?.dismiss(animated: true)
}

``` 
</br>

 ### 3. 음식점 검색 기능

 카카오 로컬 API를 활용하여 사용자가 원하는 음식점을 손쉽게 검색할 수 있는 기능을 구현했습니다. 검색된 음식점의 이름, 주소, 전화번호, 카테고리 정보, 위치 좌표 등을 받아와 직관적으로 정보를 제공합니다. 이를 통해 사용자는 필요한 정보를 빠르게 확인하고, 앱 내에서 효율적으로 음식점을 탐색할 수 있습니다.</br>
 
 <video src="https://github.com/user-attachments/assets/921fd520-05fd-42b6-abe3-3b34107233b7"></video>
 
  1. 카카오 로컬 API 연동
  - `Alamofire`를 사용하여 카카오 로컬 API와 통신
  - 검색어를 기반으로 API요청을 보내고, 음식점 정보를 JSON 형태로 받아와 디코딩
</br>

  2. 검색 결과 처리
  - 검색 결과는 Document 모델로 디코딩하여, 음식점 이름, 주소, 전화번호 등 필요한 정보를 구조화
</br>

  3. API 요청 최적화
  - 공통 헤더 및 파라미터를 구성하여 간결한 코드 유지
  - 상태 코드 검증 및 에러 핸들링 추가로 안정적인 통신 구현
</br>

  4. 확장 가능성 고려
  - API 응답 데이터는 responseDecodable을 활용하여 Food와 Document 구조체로 매핑
  - 데이터 모델 설계 시 확장 가능한 형태로 작성하여, 새로운 요구사항에 쉽게 대응 가능
</br>

```swift
func searchPlaceCallRequest(query: String, page: Int = 1, size: Int = 45, completion: @escaping ([Document]?) -> Void) {
    let baseURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    let header: HTTPHeaders = [
        "Authorization": "KakaoAK \(APIKey.key)",
        "Content-Type": "application/json; charset=UTF-8"
    ]
    let parameters: [String: Any] = ["query": query]
    
    AF.request(baseURL, method: .get, parameters: parameters, headers: header)
        .validate(statusCode: 200...500)
        .responseDecodable(of: Food.self) { response in
            switch response.result {
            case .success(let value):
                completion(value.documents) // 성공 시 음식점 데이터 반환
            case .failure(let error):
                print("Error: \(error)") // 실패 시 에러 로그 출력
                completion(nil)
            }
        }
}

```
</br>

 - 사용된 데이터 모델
 
```swift
struct Food: Decodable {
    let documents: [Document]
}

struct Document: Decodable {
    let addressName: String?
    let categoryName: String?
    let phone: String?
    let placeName: String?
    let placeURL: String?
    let roadAddressName: String?
    let x: String?  // 경도
    let y: String?  // 위도

    var finalCategory: String? {
        return categoryName?.split(separator: ">").last?.trimmingCharacters(in: .whitespaces)
    }
}

```
</br>

### 4. WebView를 사용하여 음식점 사이트로 바로 이동하는 기능</br>

 WebView 기능은 `WebKit`을 활용하여 맛집 리뷰와 관련된 외부 정보를 쉽게 접근할 수 있도록 설계되었습니다. 이를 통해 사용자는 별도의 브라우저 없이도 앱 내에서 링크된 사이트를 탐색할 수 있습니다.</br>

<video src="https://github.com/user-attachments/assets/f7f40801-f138-4ed5-bc8a-e4c56350831d"></video>
 
 - `WKWebView`는 `WebKit` 프레임워크를 기반으로 외부 웹 페이지를 앱 내부에서 로드하는 데 사용</br>
 - 리뷰 데이터에서 음식점의 URL을 placeURL 변수에 저장</br>
 - internetButton 클릭 시 openWebView 메서드 실행</br>
 - URL 유효성 검사 후 WebViewController를 생성하여 화면 전환</br>
 
``` swift
class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    var urlToLoad: URL
    
    init(url: URL) {
        self.urlToLoad = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WebView 설정
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        // URL 요청 및 로드
        let request = URLRequest(url: urlToLoad)
        webView.load(request)
    }
}


@objc func openWebView() {        
        // URL 유효성 검사
        guard var urlString = placeURL else { return }
        if urlString.starts(with: "http://") {
            urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        }
        guard let url = URL(string: urlString) else { return }
        
        // WebViewController로 전환
        let webVC = WebViewController(url: url)
        present(webVC, animated: true, completion: nil)
    }

``` 
</br>

### 5. 지도 위에 나만의 맛집을 볼 수 있는 기능</br>
사용자가 저장한 맛집 정보를 지도에 표시하여 시각적으로 표현하고, 검색 기능을 통해 맛집을 쉽게 탐색할 수 있는 기능을 설명합니다.</br>

 <img src="https://github.com/user-attachments/assets/0db41b04-7759-4042-b609-38558e8d4339" width="100%">
 </br>
 
 ### 5-1. MapKit의 Annotation을 활용하여 지도에 핀을 사진으로 표현
 - MapKit 활용: MKMapView와 MKAnnotation을 사용하여 맛집 정보를 지도에 표시
 - Custom Annotation View: 맛집의 대표 이미지를 보여주기 위해 MKAnnotationView를 커스터마이징하여 ImageAnnotationView를 구현
</br>

```swift
func loadAnnotations() {
    let reviews = reviewRepository.fetch()
    var newAnnotations: [MKPointAnnotation] = []
    
    for review in reviews {
        if let latitude = Double(review.latitude ?? ""), let longitude = Double(review.longitude ?? "") {
            let annotation = MKPointAnnotation()
            annotation.title = review.storeName
            annotation.subtitle = review.imageView1URL
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            newAnnotations.append(annotation)
        }
    }
    
    mapView.addAnnotations(newAnnotations)
}

``` 
</br>

 ### 5-2. 지도 위의 핀을 클러스터링으로 구현
 - 클러스터링 지원: 여러 핀이 모여 있을 경우, ImageClusterView를 사용하여 클러스터링된 핀과 맛집 개수를 시각적으로 표현

```swift
class ImageClusterView: MKAnnotationView {
    private var imageView: UIImageView!
    private var countLabel: UILabel!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 58, height: 58)
        self.backgroundColor = .clear
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.textColor = .white
        countLabel.backgroundColor = UIColor(named: "countGold")
        countLabel.layer.cornerRadius = 10
        countLabel.clipsToBounds = true
        self.addSubview(countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.right.equalToSuperview().inset(2)
            make.width.height.equalTo(20)
        }
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                countLabel.text = "\(cluster.memberAnnotations.count)"
                
                if let firstAnnotation = cluster.memberAnnotations.first as? MKPointAnnotation,
                   let imageUrlString = firstAnnotation.subtitle,
                   let imageUrl = URL(string: imageUrlString) {
                    imageView.kf.setImage(with: imageUrl) // 대표 이미지 로드
                }
            }
        }
    }
}

```
</br>

 ### 5-3. SearchBar를 사용하여 저장한 맛집을 검색할 수 있는 기능
UISearchBar를 이용해 지도 위에 표시되어 있는 맛집을 음식점의 이름과 메모장에 적힌 내용을 바탕으로 빠르게 저장된 맛집을 찾을 수 있습니다.</br>

```swift
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else { return }
    
    let storeNamePredicate = NSPredicate(format: "storeName CONTAINS[c] %@", searchText)
    let memoPredicate = NSPredicate(format: "memo CONTAINS[c] %@", searchText)
    let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [storeNamePredicate, memoPredicate])
    
    let results = reviewRepository.fetch().filter(combinedPredicate)
    guard let firstResult = results.first,
          let latitude = Double(firstResult.latitude ?? ""),
          let longitude = Double(firstResult.longitude ?? "") else { return }
    
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
}

```
</br>

### 6. 백업 파일 생성 및 공유/복구 기능
맛슐랭은 사용자 데이터를 안전하게 보관하고, 다른 디바이스로 쉽게 복구할 수 있도록 백업 및 복구 기능을 제공합니다.</br>
백업은 앱 내부 데이터(default.realm)를 압축하여 ZIP 파일로 저장하며, 공유와 복구가 용이합니다.</br>

<video src="https://github.com/user-attachments/assets/57e259d0-5bb2-4ee3-8f95-467742af1912"></video>

### 6-1. 백업 파일 생성 및 ZIP 압축
 - 앱 내부 데이터(default.realm)를 ZIP 파일로 압축
 - 현재 날짜와 시간을 기반으로 파일명 생성


```swift
@objc func backupButtonTapped() {
    Analytics.logEvent("backup_initiated", parameters: nil)
    var urlPaths = [URL]()
    
    guard let path = documentDirectoryPath() else {
        print("도큐먼트 위치에 오류가 있습니다.")
        return
    }
    
    let realmFile = path.appendingPathComponent("default.realm")
    
    guard FileManager.default.fileExists(atPath: realmFile.path) else {
        print("백업할 파일이 없습니다.")
        return
    }
    urlPaths.append(realmFile)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd_HH:mm:ss"
    let currentDateTime = dateFormatter.string(from: Date())
    let fileName = "matchelin_\(currentDateTime)"
    
    do {
        let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: fileName)
        print("Backup location: \(zipFilePath)")
        backUpView.backupTableView.reloadData()
    } catch {
        print("백업 실패: \(error)")
    }
}

```
</br>

### 6-2. 백업 파일 복구 및 ZIP 해제
 - 사용자로부터 ZIP 파일을 선택받아 데이터를 복구
 - 기존 데이터를 덮어쓰기 전 사용자에게 경고 메시지를 표시


```swift
@objc func restoreButtonTapped() {
    Analytics.logEvent("restore_initiated", parameters: nil)
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
    documentPicker.delegate = self
    present(documentPicker, animated: true)
}

func unzipAndRestore(fileURL: URL) {
    guard let destinationPath = documentDirectoryPath() else {
        print("복구 경로 오류")
        return
    }
    do {
        try Zip.unzipFile(fileURL, destination: destinationPath, overwrite: true, password: nil)
        print("복구 완료!")
    } catch {
        print("복구 실패: \(error)")
    }
}

```
</br>

### 6-3. 백업 파일 공유
 - ZIP 파일을 다른 앱이나 클라우드 서비스로 공유


```swift
func showActivityViewController(fileName: String) {
    guard let path = documentDirectoryPath() else {
        print("도큐먼트 위치에 오류가 있습니다.")
        return
    }
    let backupFileURL = path.appendingPathComponent(fileName)
    
    let activityVC = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil)
    present(activityVC, animated: true)
}

```
</br>

### 6-4. 백업 파일 삭제
 - 테이블 뷰에서 슬라이드 동작으로 백업 파일 삭제
 - 삭제 전 사용자 확인 대화 상자 표시
 
```swift
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let fileName = fetchZipList()[indexPath.row].name
        Analytics.logEvent("backup_file_deleted", parameters: ["fileName": fileName])
        guard let path = documentDirectoryPath() else { return }
        let fileURL = path.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("파일 삭제 실패: \(error)")
        }
    }
}

```
</br>

### 7. 앱에서 직접 이메일을 통해 문의나 의견을 수집할 수 있는 기능
맛슐랭은 사용자의 피드백을 수집하기 위해 이메일을 통한 간편한 문의/의견 수집 기능을 제공합니다. 이 기능은 `MessageUI` 프레임워크를 사용하여 앱 내부에서 이메일을 작성하고 보낼 수 있도록 설계되었습니다.</br>

<video src="https://github.com/user-attachments/assets/3d3c7350-39db-48af-b6b2-f1feabb56729"></video>
</br>

### 7-1. 이메일 작성 및 전송
 - 이메일 작성 및 전송은 MFMailComposeViewController를 사용하여 구현
 - 디바이스 모델, 디바이스 OS 버전, 앱 버전을 기기에서 입력없이 자동으로 가져옵니다.
 
 ```swift
 func sendEmail() {
    let bodyString = """
                     문의 사항 및 의견을 작성해주세요.
                     
                     
                     
                     -------------------
                     Device Model : \(Utils.getDeviceModelName())
                     Device OS : \(UIDevice.current.systemVersion)
                     App Version : \(Utils.getAppVersion())
                     -------------------
                     """
    
    if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["susie204@naver.com"]) // 문의 이메일 주소
        mail.setSubject("맛슐랭 / 문의,의견")
        mail.setMessageBody(bodyString, isHTML: false)
        present(mail, animated: true)
    } else {
        // 이메일 설정이 되어 있지 않은 경우
        let alert = UIAlertController(title: "이메일 전송 불가", message: "이메일 계정 설정 후 다시 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

```
</br>

### 7-2. 이메일 전송 결과 처리

``` swift
func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    isEmailBeingSent = false
    switch result {
    case .sent:
        print("이메일 전송 완료")
    case .cancelled:
        print("이메일 전송 취소")
    case .failed:
        print("이메일 전송 실패")
    case .saved:
        print("이메일 임시 저장")
    @unknown default:
        break
    }
    controller.dismiss(animated: true)
}

```
</br>

</br>

## 맛슐랭 2.0 핵심 기능과 코드 설명 ⭐️
맛슐랭 2.0은 회원 관리, 게시글 작성, 댓글, 프로필 관리와 같은 다양한 기능을 제공하며, 이를 통해 사용자 경험을 극대화합니다. 이 과정에서 MVVM 디자인 패턴, `Alamofire`, `RxSwift`, 그리고 프로토콜 지향 설계를 활용하여 효율적이고 유지보수 가능한 네트워크 계층을 구성했습니다. 아래는 이 프로젝트의 핵심 설계와 구현 방식입니다.</br>
</br>

- **1. MVVM 디자인 패턴**</br>

- **2. RxSwift와 Alamofire를 활용한 비동기 네트워크 처리**</br>

- **3. 공통 로직과 프로토콜을 활용한 네트워크 계층 설계**</br>

- **4. 상태 코드와 에러 처리**</br>
</br>

<성과>
- 코드 재사용성 및 확장성 향상: 공통 로직과 프로토콜 설계를 통해 API 추가가 용이
- 효율적인 비동기 처리: RxSwift를 사용한 MVVM 아키텍처로 데이터 흐름 관리
- 유지보수성 강화: 프로토콜과 공통 로직 분리로 코드 수정 및 기능 추가 비용 감소
- 테스트 가능성: 네트워크 계층 추상화를 통해 단위 테스트 가능
- 맛슐랭 2.0의 설계는 클린 코드와 유지보수성을 중시하며, 사용자와 개발자가 모두 만족할 수 있는 서비스를 제공합니다.
</br>

### 1. MVVM 디자인 패턴
 - 맛슐랭 2.0은 Model-View-ViewModel(MVVM) 패턴을 적용하여 로직과 UI를 명확히 분리
 - Model: 데이터와 API 요청을 처리하는 네트워크 계층을 포함
 - ViewModel: 비즈니스 로직을 담당하며, RxSwift를 사용해 View와 데이터를 바인딩
 - View: 사용자 인터페이스(UI)를 담당하며, ViewModel의 상태 변화를 구독하여 UI를 업데이트
 </br>
 
 ### 2. RxSwift와 Alamofire를 활용한 비동기 네트워크 처리
 - Alamofire를 통해 API 요청을 처리하고, RxSwift로 결과를 Observable로 변환하여 데이터 흐름을 간결하게 관리
 - 네트워크 요청의 성공/실패 상태를 RxSwift의 PublishSubject로 View에 전달
 - RxSwift로 데이터 바인딩하여 비동기 작업의 복잡성을 감소
 
```swift
class LoginViewModel {
    private var networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()

    // RxSwift Subjects
    let loginSuccess = PublishSubject<Void>()
    let loginFailure = PublishSubject<String>()

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func login(email: String, password: String) {
        Observable.create { [weak self] observer in
            self?.networkManager.login(email: email, password: password) { success, accessToken, refreshToken, message in
                if success {
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message ?? "Login failed"]))
                }
            }
            return Disposables.create()
        }
        .subscribe(
            onNext: { [weak self] _ in self?.loginSuccess.onNext(()) },
            onError: { [weak self] error in self?.loginFailure.onNext(error.localizedDescription) }
        )
        .disposed(by: disposeBag)
    }
}

```
</br>

 - View는 ViewModel의 상태를 구독하여 UI를 업데이트
 
 ```swift
 private func setupViewModelBindings() {
    viewModel.loginSuccess
        .subscribe(onNext: { [weak self] _ in self?.navigateToMain() })
        .disposed(by: disposeBag)

    viewModel.loginFailure
        .subscribe(onNext: { [weak self] message in self?.showAlert(with: message, navigateToMain: false) })
        .disposed(by: disposeBag)
}

 ```
</br>

 ### 3. 프로토콜을 활용하고 공통 로직을 분리한 네트워크 계층 설계
 NetworkManagerProtocol과 다양한 API 요청 구조체(SignUpRequest, LoginRequest)를 정의하여 코드 재사용성과 테스트 가능성을 높였습니다.</br>
 
 - NetworkManagerProtocol 정의
 - APIRequest 프로토콜 정의
 - 프로토콜을 기반으로 개별 API 요청 구조체를 정의하여 확장성 강화
 
```swift
protocol NetworkManagerProtocol {
    func signUp(email: String, password: String, nick: String, phoneNum: String?, birthDay: String?, completion: @escaping (Bool, String?, Int?) -> Void)
    func validateEmail(email: String, completion: @escaping (Bool, String?, Int?) -> Void)
    func login(email: String, password: String, completion: @escaping (Bool, String?, String?, String?) -> Void)
    func refreshToken(completion: @escaping (Bool, String?) -> Void)
    func withdraw(accessToken: String, completion: @escaping (Bool, String?) -> Void)
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
}

-----------------------------------------------------------------------------------------
struct SignUpRequest: APIRequest {
    let email: String
    let password: String
    let nick: String

    var method: HTTPMethod { .post }
    var path: String { "/join" }
    var parameters: Parameters? { ["email": email, "password": password, "nick": nick] }
    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
}

```
</br>

 - 공통로직을 분리하여 모든 API 요청과 상태 코드를 처리하는 로직을 분리하여 중복 코드를 최소화
 
```swift
// MARK: - 공통로직
private func performRequest(_ request: APIRequest, completion: @escaping (AFDataResponse<Any>, Error?) -> Void) {
        do {
            let urlRequest = try request.asURLRequest(baseURL: baseURL)
            AF.request(urlRequest).validate().responseJSON { response in
                completion(response, response.error)
            }
        } catch {
            completion(AFDataResponse<Any>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(error as! AFError)), error)
        }
    }
    
```
</br>

### 4. 상태 코드와 에러 처리
 - 서버에서 반환된 상태 코드를 공통적으로 처리하여 클라이언트에서 동일한 방식으로 에러를 관리
 
```swift
    // MARK: - 상태코드 공통로직
    private func processResponse(_ response: AFDataResponse<Any>, completion: (Bool, String?, Int?) -> Void) {
        guard let statusCode = response.response?.statusCode else {
            print("응답 코드를 받지 못했습니다.")
            completion(false, "응답 코드를 받지 못했습니다.", nil)
            return
        }
        
        let message = parseResponseMessage(response.data)
        
        print("상태 코드: \(statusCode), 메시지: \(message ?? "메시지 없음")")
        
        switch statusCode {
        case 200:
            completion(true, "성공", statusCode)
        case 400:
            completion(false, "필수 값이 누락됐습니다", statusCode)
        case 401:
            completion(false, "접근이 거부되었습니다", statusCode)
        case 403:
            completion(false, "금지된 접근입니다", statusCode)
        case 409:
            completion(false, "이미 가입한 유저입니다.", statusCode)
        case 418:
            completion(false, "리프레시 토큰이 만료되었습니다. 다시 로그인해주세요", statusCode)
        case 419:
            completion(false, "액세스 토큰이 만료되었습니다", statusCode)
        case 420:
            completion(false, "잘못된 SesacKey입니다", statusCode)
        case 429:
            completion(false, "요청이 너무 많습니다", statusCode)
        case 444:
            completion(false, "잘못된 URL입니다", statusCode)
        case 500:
            completion(false, "서버 에러", statusCode)
        default:
            completion(false, message ?? "알 수 없는 에러", statusCode)
        }
    }
```
</br>

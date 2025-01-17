# 맛슐랭 - 나만의 맛집 컬렉션 


<img src="https://github.com/user-attachments/assets/76ed30a0-e006-4cd1-aadb-5dfa34887178" width="25%">


- [맛슐랭 - 나만의 맛집 컬렉션 앱스토어 링크](https://apps.apple.com/kr/app/%EB%A7%9B%EC%8A%90%EB%9E%AD-%EB%82%98%EB%A7%8C%EC%9D%98-%EB%A7%9B%EC%A7%91-%EC%BB%AC%EB%A0%89%EC%85%98/id6470218238)</br>

- [맛슐랭 - 2.0 서버 버전 유튜브 영상](https://youtu.be/B3ehN8v3Gq0)</br>

- [맛슐랭 - 2.0 서버 버전 깃허브 링크](https://github.com/Lavender-SH/MatchelinServer-RX-MVVM)</br>

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

- **1. 맛집을 기록하고 관리하는 기능**</br>
`RealmSwift`로 데이터베이스 구성</br>
1-1. Realm 모델에 리뷰로 저장할 내용 정의</br>
1-2. Realm Repository를 활용한 CRUD 구현</br>
1-3. 데이터를 별점순, 시간순, 방문순 정렬하는 기능</br>

- **2. 나만의 맛집 앨범을 만들어 카테고리를 분류하는 기능**</br>
 2-1. To-Many Relationship을 활용한 앨범 생성 기능</br>
 2-2. 사이드 메뉴바 라이브러리를 사용하여 카테고리 탐색 지원 </br>

- **3. WebView를 사용하여 음식점 사이트로 바로 이동하는 기능**</br>

- **4. 지도위에 나만의 맛집을 볼 수 있는 기능**</br>
 4-1. MapKit의 Annotation을 활용하여 지도에 핀을 사진으로 표현</br>
 4-2. SearchBar를 사용하여 저장한 맛집을 검색할 수 있는 기능</br>

- **5. 백업 파일 생성 및 공유/복구 기능**</br>

- **6. 앱에서 직접 이메일을 통해 문의나 의견을 수집할 수 있는 기능**</br>

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

 <img src=" https://github.com/user-attachments/assets/8b6b0c6d-9838-423f-a34c-0fe358701146"></br>

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

### 3. WebView를 사용하여 음식점 사이트로 바로 이동하는 기능</br>

<video src="https://github.com/user-attachments/assets/f7f40801-f138-4ed5-bc8a-e4c56350831d"></video>

 WebView 기능은 `WebKit`을 활용하여 맛집 리뷰와 관련된 외부 정보를 쉽게 접근할 수 있도록 설계되었습니다. 이를 통해 사용자는 별도의 브라우저 없이도 앱 내에서 링크된 사이트를 탐색할 수 있습니다.</br>
 
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
   

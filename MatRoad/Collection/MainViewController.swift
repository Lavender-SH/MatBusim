//
//  CollectionViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//


import UIKit
import SnapKit
import RealmSwift
import Kingfisher
import SideMenu

class MainViewController: BaseViewController {
    
    let mainView = CollectionView()
    //Realm 관련 변수
    var reviewItems: Results<ReviewTable>!
    var albumItems: Results<AlbumTable>!
    let realm = try! Realm()
    let repository = ReviewTableRepository()
    var notificationToken: NotificationToken?
    //삭제
    var isDeleteMode = false
    var selectedItemsToDelete: Set<ReviewTable> = []
    // 삭제 및 완료 버튼 추가
    var deleteBarButton: UIBarButtonItem!
    var doneBarButton: UIBarButtonItem!
    //이동 //⭐️이동 ver2
    var isTransferMode = false
    var selectedItemsToTranse: Set<ReviewTable> = []
    // 이동 및 완료 버튼 추가 //⭐️이동 ver2
    var transBarButton: UIBarButtonItem!
    var transDoneBarButton: UIBarButtonItem!
    // 사이드 메뉴 변수
    var sideMenu: SideMenuNavigationController?
    var sideMenuTableViewController: UITableViewController!
    var albumNames: [String] {
        let albums = realm.objects(AlbumTable.self).map { $0.albumName }
        return ["All"] + albums + ["+ 앨범 추가"]
    }
    var selectedReview: ReviewTable?
    var isAllSelected: Bool = false
    var selectedSideMenuIndexPath: IndexPath? = IndexPath(row: 0, section: 0)
    var isAscendingOrder: Bool = true //별점 내림차순 오름차순
    var transButton: UIBarButtonItem! //변수로 사용하기 위함 (삭제모드일때 이동버튼 누르기 막아야함)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "White")
        
        // reviewItems 초기화
        reviewItems = repository.fetch().sorted(byKeyPath: "reviewDate", ascending: false)
        makeNavigationUI()
        setupBarButtonItems()
        setupSideMenu()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchBar.delegate = self
        // Realm 데이터베이스의 변경을 감지하는 옵저버를 추가
        notificationToken = reviewItems.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // 초기 데이터 로딩 시
                self?.mainView.collectionView.reloadData()
            case .update(_, _, _, _):
                // 데이터베이스 변경 시
                self?.mainView.collectionView.reloadData()
            case .error(let error):
                print("Error: \(error)")
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("didRestoreBackup"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        print(realm.configuration.fileURL)
        
        mainView.timeButton.setTitleColor(UIColor(named: "gold"), for: .normal)
        mainView.timeButton.layer.borderColor = UIColor(named: "gold")?.cgColor
        
        //메인의 뷰디드로드에 선택한 테마를 전달해줘야 해결됨 sceneDelegate가 아님⭐️
        let savedTheme = loadThemeFromRealm()
        print(savedTheme)
        applyTheme(savedTheme)
        
    }
    func loadThemeFromRealm() -> String {
        let realm = try! Realm()
        return realm.objects(UserTheme.self).first?.selectedTheme ?? "라이트모드"
    }
    
    func applyTheme(_ theme: String) {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let windows = window.windows.first
        windows?.overrideUserInterfaceStyle = theme == "라이트모드" ? .light : .dark
    }
    
    @objc func refreshData() {
        reviewItems = repository.fetch()
        mainView.collectionView.reloadData()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func configureView() {
        mainView.ratingButton.addTarget(self, action: #selector(sortByRating), for: .touchUpInside)
        mainView.visitsButton.addTarget(self, action: #selector(sortByLatest), for: .touchUpInside)
        mainView.timeButton.addTarget(self, action: #selector(sortByPast), for: .touchUpInside)
        
        mainView.ratingButton.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
        mainView.visitsButton.addTarget(self, action: #selector(latestButtonTapped), for: .touchUpInside)
        mainView.timeButton.addTarget(self, action: #selector(pastButtonTapped), for: .touchUpInside)
        
//        if let cancelButton = mainView.searchBar.value(forKey: "cancelButton") as? UIButton {
//            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: UIControl.Event.touchUpInside)
//        }
    }
    
    // MARK: - 네비게이션UI
    func makeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Navigation")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(reviewPlusButtonTapped))
        plusButton.tintColor = UIColor(named: "gold")
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "minus.square"), style: .plain, target: self, action: #selector(reviewDeleteButtonTapped))
        
        let albumButton = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled"), style: .plain, target: self, action: #selector(albumButtonTapped))
        //⭐️ 이동 ver2
        transButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left.arrow.right.square"), style: .plain, target: self, action: #selector(transModeButtonTapped))
        //let albumButton3 = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(albumButtonTapped))
        //let albumButton4 = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(albumButtonTapped))
        
        navigationItem.rightBarButtonItems = [plusButton, deleteButton]
        navigationItem.leftBarButtonItems = [albumButton, transButton]
        
        
        let logo = UIImage(named: "newLogo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func setupBarButtonItems() {
        let customFont = UIFont(name: "KCC-Ganpan", size: 16.0)
        let customColor = UIColor(named: "textColor")
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont as Any,
            .foregroundColor: customColor as Any
        ]
        // 삭제 및 완료 버튼 초기화
        deleteBarButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteSelectedItems))
        deleteBarButton.setTitleTextAttributes(attributes, for: .normal)
        
        doneBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(endEditMode))
        doneBarButton.setTitleTextAttributes(attributes, for: .normal)
        //⭐️이동 ver2
        transBarButton = UIBarButtonItem(title: "이동", style: .plain, target: self, action: #selector(transSelectedItems))
        transBarButton.setTitleTextAttributes(attributes, for: .normal)
        
        transDoneBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(endTransferMode))
        transDoneBarButton.setTitleTextAttributes(attributes, for: .normal)
    }
    
    // MARK: - 사이드 메뉴바 세팅
    func setupSideMenu() {
        sideMenuTableViewController = UITableViewController()
        sideMenuTableViewController.tableView.delegate = self
        sideMenuTableViewController.tableView.dataSource = self
        sideMenuTableViewController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuCell")
        
        // 테이블 뷰와 셀의 배경색을 black으로 설정
        sideMenuTableViewController.tableView.backgroundColor = UIColor(named: "TabBarTintColor")
        sideMenuTableViewController.tableView.separatorColor = .darkGray // 구분선을 흰색으로 설정
        
        // 셀 구분선이 왼쪽 끝까지 보이게 설정
        sideMenuTableViewController.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 네비게이션 바의 배경색을 DarkGray로 설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "test")
        //appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
        appearance.shadowColor = .clear
        appearance.configureWithOpaqueBackground()
        
        sideMenuTableViewController.navigationController?.navigationBar.standardAppearance = appearance
        sideMenuTableViewController.navigationController?.navigationBar.compactAppearance = appearance
        //sideMenuTableViewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        sideMenuTableViewController.navigationController?.navigationBar.tintColor = .blue
        
        
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuTableViewController)
        sideMenu?.navigationBar.barTintColor = .black //UIColor(named: "TabBarTintColor") //⭐️
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        sideMenuTableViewController.edgesForExtendedLayout = [.top]
        
    }
    
    // MARK: - 데이터추가 버튼
    @objc func reviewPlusButtonTapped() {
        let alertController = UIAlertController(title: nil, message: "맛집을 찾으셨습니까?", preferredStyle: .actionSheet)
        
        let registerAction = UIAlertAction(title: "맛집 등록", style: .default) { (action) in
            
            let searchVC = SearchViewController()
            let searchNavController = UINavigationController(rootViewController: searchVC)
            searchNavController.modalPresentationStyle = .fullScreen
            self.present(searchNavController, animated: true, completion: nil)
        }
        alertController.addAction(registerAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - 데이터 삭제
    @objc func reviewDeleteButtonTapped() {
        isDeleteMode.toggle()
        if isDeleteMode {
            // 삭제 모드 시작
            tabBarController?.tabBar.isHidden = false
            navigationItem.rightBarButtonItems = [deleteBarButton, doneBarButton]
            
            let alertController = UIAlertController(title: nil, message: "삭제할 데이터를 선택하고 \n삭제 버튼을 눌러주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            transButton.isEnabled = false
            tabBarController?.tabBar.isHidden = true
        } else {
            // 삭제 모드 종료
            transButton.isEnabled = true
            endEditMode()
        }
        mainView.collectionView.reloadData()
    }
    
    //⭐️이동 ver2
    @objc func transModeButtonTapped() {
        isTransferMode.toggle()
        if isTransferMode {
            // 이동 모드 시작
            tabBarController?.tabBar.isHidden = false
            navigationItem.rightBarButtonItems = [transBarButton, transDoneBarButton]
            // 현재 선택된 리뷰 항목을 이동 세트에 추가합니다.
            if let selectedIndexPaths = mainView.collectionView.indexPathsForSelectedItems {
                for indexPath in selectedIndexPaths {
                    selectedItemsToTranse.insert(reviewItems[indexPath.row])
                }
            }

            // 얼럿창 표시
            let alertController = UIAlertController(title: nil, message: "이동할 데이터를 선택하고 \n이동 버튼을 눌러주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            tabBarController?.tabBar.isHidden = true
        } else {
            // 이동 모드 종료
            endTransferMode()
        }
        mainView.collectionView.reloadData()
    }

    
    
    @objc func albumButtonTapped() {
        present(sideMenu!, animated: true)
    }
    // MARK: - 정렬버튼
    @objc func sortByRating() {
        isAscendingOrder.toggle()
        if let selectedAlbumIdString = UserDefaults.standard.string(forKey: "selectedAlbumId"),
           let selectedAlbumId = try? ObjectId(string: selectedAlbumIdString) {
            reviewItems = repository.fetch().filter("ANY album._id == %@", selectedAlbumId).sorted(byKeyPath: "starCount", ascending: isAscendingOrder)
        } else {
            reviewItems = repository.fetch().sorted(byKeyPath: "starCount", ascending: isAscendingOrder)
        }

        mainView.collectionView.reloadData()
    }

    @objc func sortByLatest() {
        isAscendingOrder.toggle()
        if let selectedAlbumIdString = UserDefaults.standard.string(forKey: "selectedAlbumId"),
           let selectedAlbumId = try? ObjectId(string: selectedAlbumIdString) {
            reviewItems = repository.fetch().filter("ANY album._id == %@", selectedAlbumId).sorted(byKeyPath: "visitCount", ascending: isAscendingOrder)
        } else {
            reviewItems = repository.fetch().sorted(byKeyPath: "visitCount", ascending: isAscendingOrder)
        }

        mainView.collectionView.reloadData()
    }

    @objc func sortByPast() {
        isAscendingOrder.toggle()
        if let selectedAlbumIdString = UserDefaults.standard.string(forKey: "selectedAlbumId"),
           let selectedAlbumId = try? ObjectId(string: selectedAlbumIdString) {
            reviewItems = repository.fetch().filter("ANY album._id == %@", selectedAlbumId).sorted(byKeyPath: "reviewDate", ascending: isAscendingOrder)
        } else {
            reviewItems = repository.fetch().sorted(byKeyPath: "reviewDate", ascending: isAscendingOrder)
        }

        mainView.collectionView.reloadData()
    }


    
    @objc func ratingButtonTapped() {
        updateButtonStyles(selected: mainView.ratingButton, others: [mainView.visitsButton, mainView.timeButton])
    }
    
    @objc func latestButtonTapped() {
        updateButtonStyles(selected: mainView.visitsButton, others: [mainView.ratingButton, mainView.timeButton])
    }
    
    @objc func pastButtonTapped() {
        updateButtonStyles(selected: mainView.timeButton, others: [mainView.ratingButton, mainView.visitsButton])
    }
    
    func updateButtonStyles(selected: UIButton, others: [UIButton]) {
        selected.setTitleColor(UIColor(named: "gold"), for: .normal)
        selected.layer.borderColor = UIColor(named: "gold")?.cgColor
        
        for button in others {
            button.setTitleColor(.gray, for: .normal)
            button.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    
    @objc func endEditMode() {
        isDeleteMode = false
        tabBarController?.tabBar.isHidden = false
        makeNavigationUI()
        selectedItemsToDelete.removeAll()
        transButton.isEnabled = true
        mainView.collectionView.reloadData()
    }
    //⭐️이동 ver2
    @objc func endTransferMode() {
        isTransferMode = false
        tabBarController?.tabBar.isHidden = false
        makeNavigationUI()
        selectedItemsToTranse.removeAll()
        mainView.collectionView.reloadData()
    }
    
    @objc func deleteSelectedItems() {
        for review in selectedItemsToDelete {
            repository.deleteReview(review)
        }
        selectedItemsToDelete.removeAll()
        mainView.collectionView.reloadData()
    }
    //⭐️이동 ver2
    @objc func transSelectedItems() {
        let alertController = UIAlertController(title: nil, message: "데이터를 이동할 앨범을 선택해주세요!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.present(self!.sideMenu!, animated: true)
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("didRestoreBackup"), object: nil)
    }
    
    
}

// MARK: - 확장: 컬렉션뷰 관련 함수
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = selectedReview {
            return 1
        } else {
            let count = reviewItems.count
            mainView.emptyImageView.isHidden = count != 0
            
            if !isSearchActive {
                mainView.emptyImageLabel.isHidden = count != 0
            }
            
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        
        let review = selectedReview ?? reviewItems[indexPath.row]
        
        cell.titleLabel.text = review.storeName
        cell.cosmosView.rating = review.starCount
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: review.reviewDate)
        cell.dateLabel.text = dateString
        
        if let imageUrlString = review.imageView1URL, let imageUrl = URL(string: imageUrlString) {
            cell.imageView.kf.setImage(with: imageUrl) // Kingfisher 라이브러리를 사용하여 이미지를 로드합니다.
        }
        
        //삭제할때
        cell.deleteCheckmark.isHidden = !isDeleteMode
        cell.deleteCheckmark.tintColor = selectedItemsToDelete.contains(review) ? UIColor(named: "checkColor") : .lightGray
        //이동할때 //⭐️이동 ver2
        cell.transCheckmark.isHidden = !isTransferMode
        cell.transCheckmark.tintColor = selectedItemsToTranse.contains(reviewItems[indexPath.row]) ? UIColor(named: "gold") : .lightGray
        return cell
    }
    // MARK: - 메인화면 컬렉션뷰에서 리뷰수정하기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isDeleteMode {
            let review = reviewItems[indexPath.row]
            if selectedItemsToDelete.contains(review) {
                selectedItemsToDelete.remove(review)
            } else {
                selectedItemsToDelete.insert(review)
            }
            collectionView.reloadItems(at: [indexPath])
        } else if isTransferMode {
            if selectedItemsToTranse.contains(reviewItems[indexPath.row]) {
                selectedItemsToTranse.remove(reviewItems[indexPath.row])
            } else {
                selectedItemsToTranse.insert(reviewItems[indexPath.row])
            }
            collectionView.reloadItems(at: [indexPath])
        } else {
            let review = reviewItems[indexPath.row]
            let reviewVC = ReviewViewController()
            
            reviewVC.reviewView.visitCountStepper.value = Double(review.visitCount ?? 1)
            
            reviewVC.isEditMode = true //수정할때
            reviewVC.selectedReviewId = review._id
            
            reviewVC.placeName = review.storeName
            reviewVC.placeURL = review.internetSettle
            reviewVC.starCount = review.starCount
            reviewVC.rateNumber = review.rateNumber
            reviewVC.reviewDate = review.reviewDate
            reviewVC.memo = review.memo
            reviewVC.imageView1URL = review.imageView1URL
            reviewVC.imageView2URL = review.imageView2URL
            reviewVC.visitCount = review.visitCount
            
            present(reviewVC, animated: true, completion: nil)
        }
    }
    
    
}
// MARK: - 확장: 사이드 메뉴 테이블 뷰 관련 함수
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
        cell.textLabel?.text = albumNames[indexPath.row]
        cell.backgroundColor = UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.3))
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "KCC-Ganpan", size: 16.0)
        //체크표시
        if indexPath == selectedSideMenuIndexPath {
            cell.accessoryType = .checkmark
            cell.tintColor = .white
        } else {
            cell.accessoryType = .none
        }
        // "+ 앨범 추가" 셀에 버튼 추가
        if indexPath.row == albumNames.count - 1 {
            let addButton = UIButton(frame: CGRect(x: 15, y: 8, width: 200, height: 30))
            addButton.contentHorizontalAlignment = .center
            addButton.setTitle(albumNames[indexPath.row], for: .normal)
            addButton.setTitleColor(.white, for: .normal)
            addButton.backgroundColor = .clear
            addButton.addTarget(self, action: #selector(addAlbumButtonTapped), for: .touchUpInside)
            addButton.layer.borderColor = UIColor.white.cgColor
            addButton.layer.borderWidth = 2.0
            addButton.layer.cornerRadius = 10
            addButton.clipsToBounds = true
            addButton.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 17.0)
            
            cell.addSubview(addButton)
            cell.textLabel?.text = nil // 기존 텍스트 레이블 숨기기
        } else {
            //다른 셀에서 "+ 앨범 추가" 버튼이 표시x
            for subview in cell.subviews {
                if subview is UIButton {
                    subview.removeFromSuperview()
                }
            }
        }
        return cell
    }
    
    // MARK: - 사이드메뉴바의 셀을 누를떄마다 데이터 가져오기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let selectedAlbum = albumNames[indexPath.row]
        
        if selectedAlbum == "All" {
            isAllSelected = true
            reviewItems = repository.fetch()
            UserDefaults.standard.removeObject(forKey: "selectedAlbumId")
        } else if selectedAlbum == "+ 앨범 추가" {
            return
        } else {
            isAllSelected = false
            if let matchingAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", selectedAlbum).first {
                reviewItems = repository.fetch().filter("ANY album._id == %@", matchingAlbum._id)
                
                UserDefaults.standard.set(matchingAlbum._id.stringValue, forKey: "selectedAlbumId")
                print("===111===", matchingAlbum._id)
            }
        }
        
        mainView.collectionView.reloadData()
        sideMenu?.dismiss(animated: true, completion: nil)
        
        selectedSideMenuIndexPath = indexPath
        
        // 체크마크 관련 로직 추가
        if let previousSelectedIndexPath = selectedSideMenuIndexPath {
            tableView.cellForRow(at: previousSelectedIndexPath)?.accessoryType = .none
        }
        
        // "+ 앨범 추가" 셀을 제외하고 체크마크 표시
        if selectedAlbum != "+ 앨범 추가" {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedSideMenuIndexPath = indexPath
        }
        
        tableView.reloadData()
        
        
        //⭐️이동 ver2
        // 이동 모드에서 앨범 선택 시 데이터 이동
        if isTransferMode {
            let targetAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", selectedAlbum).first
            if let targetAlbum = targetAlbum {
                try! realm.write {
                    for review in selectedItemsToTranse {
                        if let currentAlbum = review.album.first {
                            currentAlbum.reviews.remove(at: currentAlbum.reviews.index(of: review)!)
                        }
                        targetAlbum.reviews.append(review)
                    }
                }
                // 이동 모드 종료 및 선택 항목 초기화
                isTransferMode = false
                selectedItemsToTranse.removeAll()
                mainView.collectionView.reloadData()
                endTransferMode()
                
                // 데이터 이동 완료 얼럿창 표시
                let alertController = UIAlertController(title: nil, message: "데이터 이동이 완료되었습니다!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    
    // MARK: - 사이드메뉴바 헤더 구현
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeight: CGFloat = 50
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight))
        headerView.backgroundColor = .darkGray
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 60, height: headerHeight))
        titleLabel.text = "My Album"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "KCC-Ganpan", size: 18.0)
        headerView.addSubview(titleLabel)
        
        let editButton = UIButton(frame: CGRect(x: tableView.bounds.width - 60, y: 10, width: 50, height: 30))
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 18.0)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 2.0
        editButton.layer.cornerRadius = 10
        editButton.clipsToBounds = true
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        headerView.addSubview(editButton)
        
        // Adjust the table view's content inset
        tableView.contentInset = UIEdgeInsets(top: -26, left: 0, bottom: 0, right: 0)
        
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func editButtonTapped() {
        isDeleteMode.toggle()
        sideMenuTableViewController.tableView.setEditing(isDeleteMode, animated: true)
        
    }
    
    @objc func addAlbumButtonTapped() {
        sideMenu?.dismiss(animated: true, completion: {
            // 얼럿창
            let alertController = UIAlertController(title: "새로운 앨범", message: "이 앨범의 이름을 입력해주세요.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = " "
            }
            // "추가"
            let addAction = UIAlertAction(title: "추가", style: .default) { _ in
                if let newAlbumName = alertController.textFields?.first?.text, !newAlbumName.isEmpty {
                    let newAlbum = AlbumTable(albumName: newAlbumName)
                    
                    let newAlbumId = newAlbum._id
                    UserDefaults.standard.set(newAlbumId.stringValue, forKey: "newAlbumId")
                    UserDefaults.standard.set(newAlbumName, forKey: "newAlbumName")
                    
                    self.repository.saveAlbum(newAlbum)
                    self.sideMenuTableViewController.tableView.reloadData()
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            // 얼럿창 표시
            self.present(alertController, animated: true, completion: nil)
        })
    }
    // MARK: - 슬라이드 메뉴 바 셀 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.row != 0 && indexPath.row != albumNames.count - 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let albumNameToDelete = albumNames[indexPath.row]
            if let albumToDelete = realm.objects(AlbumTable.self).filter("albumName == %@", albumNameToDelete).first {
                try! realm.write {
                    realm.delete(albumToDelete)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func handleTapOutside() {
        if sideMenuTableViewController.tableView.isEditing {
            sideMenuTableViewController.tableView.setEditing(false, animated: true)
        }
    }
    
}
// MARK: - 서치바 관련함수
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            reviewItems = repository.fetch()
            mainView.collectionView.reloadData()
            return
        }
        
        let storeNamePredicate = NSPredicate(format: "storeName CONTAINS[c] %@", searchText)
        let memoPredicate = NSPredicate(format: "memo CONTAINS[c] %@", searchText)
        let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [storeNamePredicate, memoPredicate])
        
        if isAllSelected {
            reviewItems = repository.fetch().filter(combinedPredicate)
        } else {
            if let albumId = UserDefaults.standard.string(forKey: "selectedAlbumId"), let matchingAlbumId = try? ObjectId(string: albumId) {
                let albumPredicate = NSPredicate(format: "ANY album._id == %@", matchingAlbumId)
                let finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [albumPredicate, combinedPredicate])
                reviewItems = repository.fetch().filter(finalPredicate)
            }
        }
        
        mainView.collectionView.reloadData()
        updateEmptyStateVisibility()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let storeNamePredicate = NSPredicate(format: "storeName CONTAINS[c] %@", searchText)
        let memoPredicate = NSPredicate(format: "memo CONTAINS[c] %@", searchText)
        let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [storeNamePredicate, memoPredicate])
        
        if searchText.isEmpty {
            if !isAllSelected && UserDefaults.standard.string(forKey: "selectedAlbumId") == nil {
                reviewItems = repository.fetch()
            } else if let albumId = UserDefaults.standard.string(forKey: "selectedAlbumId"), let matchingAlbumId = try? ObjectId(string: albumId) {
                let albumPredicate = NSPredicate(format: "ANY album._id == %@", matchingAlbumId)
                reviewItems = repository.fetch().filter(albumPredicate)
            } else {
                reviewItems = repository.fetch()
            }
        } else {
            if !isAllSelected && UserDefaults.standard.string(forKey: "selectedAlbumId") == nil {
                reviewItems = repository.fetch().filter(combinedPredicate)
            } else if isAllSelected {
                reviewItems = repository.fetch().filter(combinedPredicate)
            } else if let albumId = UserDefaults.standard.string(forKey: "selectedAlbumId"), let matchingAlbumId = try? ObjectId(string: albumId) {
                let albumPredicate = NSPredicate(format: "ANY album._id == %@", matchingAlbumId)
                let finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [albumPredicate, combinedPredicate])
                reviewItems = repository.fetch().filter(finalPredicate)
            }
        }
        mainView.collectionView.reloadData()
        updateEmptyStateVisibility()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.searchBar.text = ""
        updateEmptyStateVisibility()
    }
}

// MARK: - 메인뷰에서 서치바 검색했을때 검색결과 없으면 +버튼을 눌러주세요 없애기
extension MainViewController {
    var isSearchActive: Bool {
        return mainView.searchBar.text?.isEmpty == false
    }
    
    func updateEmptyStateVisibility() {
        let isEmpty = reviewItems.isEmpty
        
        if isSearchActive {
            
            mainView.emptyImageLabel.isHidden = true
        } else {
            
            mainView.emptyImageLabel.isHidden = !isEmpty
        }
    }
}
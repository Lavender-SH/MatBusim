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
        return ["모두 보기"] + albums + ["+ 앨범 추가"]
    }
    var sideMenuPanGesture: UIGestureRecognizer?
    
    var selectedReview: ReviewTable?
    var isAllSelected: Bool = false
    var selectedSideMenuIndexPath: IndexPath? = IndexPath(row: 0, section: 0)
    var isAscendingOrder: Bool = true //별점 내림차순 오름차순
    var transButton: UIBarButtonItem! //변수로 사용하기 위함 (삭제모드일때 이동버튼 누르기 막아야함)
    var albumButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    var isSlideGesture: Bool = true
    var activityIndicator: UIActivityIndicatorView!
    
    
    
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
        setupSideMenu2()
        IndiatorViewBasic()
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
        
        //print(realm.configuration.fileURL)
        
        mainView.timeButton.setTitleColor(UIColor(named: "gold"), for: .normal)
        mainView.timeButton.layer.borderColor = UIColor(named: "gold")?.cgColor
        
        //메인의 뷰디드로드에 선택한 테마를 전달해줘야 해결됨 sceneDelegate가 아님⭐️
        let savedTheme = loadThemeFromRealm()
        //print(savedTheme)
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
    func IndiatorViewBasic() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .red
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(mainView)
        }
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
        plusButton.tintColor = UIColor(named: "memoGold")
        deleteButton = UIBarButtonItem(image: UIImage(systemName: "minus.square"), style: .plain, target: self, action: #selector(reviewDeleteButtonTapped))
        deleteButton.tintColor = UIColor(named: "memoGold")
        
        albumButton = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle.angled"), style: .plain, target: self, action: #selector(albumButtonTapped))
        albumButton.tintColor = UIColor(named: "memoGold")
        //⭐️ 이동 ver2
        transButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left.arrow.right.square"), style: .plain, target: self, action: #selector(transModeButtonTapped))
        transButton.tintColor = UIColor(named: "memoGold")
        //let albumButton3 = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(albumButtonTapped))
        //let albumButton4 = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(albumButtonTapped))
        
        navigationItem.rightBarButtonItems = [plusButton, deleteButton]
        navigationItem.leftBarButtonItems = [albumButton, transButton]
        
        
        let logo = UIImage(named: "투명로고")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true  // imageView에 제스쳐를 추가하기 위해 활성화
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refreshViewContents))
        imageView.addGestureRecognizer(tapGesture)
        navigationItem.titleView = imageView
    }
    
    //    @objc func refreshViewContents() {
    //        // "모두 보기" 셀이 눌린 것과 같은 로직 추가
    //        isAllSelected = true
    //        reviewItems = repository.fetch().sorted(byKeyPath: "reviewDate", ascending: false)
    //        UserDefaults.standard.removeObject(forKey: "selectedAlbumId")
    //        mainView.collectionView.reloadData()
    //        pastButtonTapped()
    //        isAscendingOrder = true
    //
    //        selectedSideMenuIndexPath = IndexPath(row: 0, section: 0)
    //        sideMenuTableViewController.tableView.reloadData()
    //
    //        let alertController = UIAlertController(title: nil, message: "로고를 누르면 \n처음 화면으로 이동합니다!", preferredStyle: .alert)
    //        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    //        alertController.addAction(okAction)
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    @objc func refreshViewContents() {
        // 인디케이터 시작
        activityIndicator.startAnimating()
        
        // 1초의 지연 후에 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // 인디케이터 중지
            self?.activityIndicator.stopAnimating()
            
            // 원래의 refresh 로직 실행
            self?.isAllSelected = true
            self?.reviewItems = self?.repository.fetch().sorted(byKeyPath: "reviewDate", ascending: false)
            UserDefaults.standard.removeObject(forKey: "selectedAlbumId")
            self?.mainView.collectionView.reloadData()
            self?.pastButtonTapped()
            self?.isAscendingOrder = true
            self?.mainView.searchBar.placeholder = "모두 보기 앨범"
            
            self?.selectedSideMenuIndexPath = IndexPath(row: 0, section: 0)
            self?.sideMenuTableViewController.tableView.reloadData()
        }
    }
    
    
    
    func borderedButton(title: String, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(named: "realGold"), for: .normal)
        button.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 16.0)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor(named: "realGold")?.cgColor
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func setupBarButtonItems() {
        // 삭제 및 완료 버튼 초기화
        deleteBarButton = borderedButton(title: "삭제", action: #selector(deleteSelectedItems))
        doneBarButton = borderedButton(title: "취소", action: #selector(endEditMode))
        
        //⭐️이동 ver2
        transBarButton = borderedButton(title: "이동", action: #selector(transSelectedItems))
        transDoneBarButton = borderedButton(title: "취소", action: #selector(endTransferMode))
    }
    
    //스테이터스바 색깔 변경
    //    private func setStatusBarBackgroundColor() {
    //           let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
    //           statusBar.backgroundColor = .red
    //           UIApplication.shared.keyWindow?.addSubview(statusBar)
    //
    //       }
    
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
        sideMenuTableViewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        sideMenuTableViewController.navigationController?.navigationBar.tintColor = .blue
        
        
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuTableViewController)
        sideMenu?.navigationBar.barTintColor = .clear //UIColor(named: "TabBarTintColor") //⭐️
        sideMenu?.leftSide = true //왼쪽방향에서 나오기
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        //        let statusBar = UIView(frame: sideMenu?.view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        //            statusBar.backgroundColor = .red
        //            sideMenu?.view.addSubview(statusBar)
        
        sideMenuTableViewController.edgesForExtendedLayout = [.top]
    }
    
    func setupSideMenu2() {
        // Remove existing pan gesture
        if let gestures = self.view.gestureRecognizers {
            for gesture in gestures {
                if let gesture = gesture as? UIPanGestureRecognizer {
                    self.view.removeGestureRecognizer(gesture)
                }
            }
        }
        
        // Only add the gesture when both modes are false
        if !isDeleteMode && !isTransferMode && isSlideGesture {
            SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        }
    }
    
    
    
    // MARK: - 데이터추가 버튼
    @objc func reviewPlusButtonTapped() {
        
        //얼럿창 있는 버전
        //        let alertController = UIAlertController(title: nil, message: "맛집을 찾으셨습니까?", preferredStyle: .actionSheet)
        //
        //        let registerAction = UIAlertAction(title: "맛집 등록", style: .default) { (action) in
        //
        //            let searchVC = SearchViewController()
        //            let searchNavController = UINavigationController(rootViewController: searchVC)
        //            searchNavController.modalPresentationStyle = .fullScreen
        //            self.present(searchNavController, animated: true, completion: nil)
        //        }
        //        alertController.addAction(registerAction)
        //
        //        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        //        alertController.addAction(cancelAction)
        //
        //        self.present(alertController, animated: true, completion: nil)
        
        //얼럿창 없는 버전
        let searchVC = SearchViewController()
        let searchNavController = UINavigationController(rootViewController: searchVC)
        searchNavController.modalPresentationStyle = .fullScreen
        self.present(searchNavController, animated: true, completion: nil)
    }
    
    // MARK: - 데이터 삭제
    @objc func reviewDeleteButtonTapped() {
        isDeleteMode.toggle()
        if isDeleteMode {
            // 삭제 모드 시작
            tabBarController?.tabBar.isHidden = true
            //self.hidesBottomBarWhenPushed = false
            navigationItem.rightBarButtonItems = [deleteBarButton, doneBarButton]
            
            let alertController = UIAlertController(title: nil, message: "삭제할 데이터를 선택하고 \n삭제 버튼을 눌러주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            transButton.isEnabled = false
            albumButton.isEnabled = false
            isSlideGesture = false
            setupSideMenu2()
            //deleteButton.isEnabled = true
            
        } else {
            // 삭제 모드 종료
            transButton.isEnabled = true
            albumButton.isEnabled = true
            endEditMode()
        }
        
        mainView.collectionView.reloadData()
    }
    
    
    //⭐️이동 ver2
    @objc func transModeButtonTapped() {
        // 이동 모드 시작
        isTransferMode.toggle()
        if isTransferMode {
            // 앨범 존재 확인
            if albumNames.count <= 2 { // "모두 보기"와 "+ 앨범 추가"만 있을 경우
                let alertController = UIAlertController(title: nil, message: "이동할 새로운 앨범을 먼저 만들어주세요!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                isTransferMode = false // 이동 모드 종료
                return
            }
            
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
            albumButton.isEnabled = false
            transButton.isEnabled = false
            tabBarController?.tabBar.isHidden = true
            
            isSlideGesture = false
            setupSideMenu2()
            
        } else {
            // 이동 모드 종료
            endTransferMode()
            
            
        }
        
        mainView.collectionView.reloadData()
    }
    
    
    @objc func albumButtonTapped() {
        present(sideMenu!, animated: true)
    }
    
    //    @objc func albumButtonTapped() {
    //        // 슬라이드 메뉴바 열기/닫기
    //        if let sideMenu = sideMenu {
    //            if self.presentedViewController == sideMenu {
    //                sideMenu.dismiss(animated: true, completion: nil)
    //            } else {
    //                present(sideMenu, animated: true, completion: nil)
    //            }
    //        }
    //    }
    
    // MARK: - 정렬버튼
    @objc func sortByRating() {
        
        isAscendingOrder.toggle()
        if let selectedAlbumIdString = UserDefaults.standard.string(forKey: "selectedAlbumId"),
           let selectedAlbumId = try? ObjectId(string: selectedAlbumIdString) {
            reviewItems = repository.fetch().filter("ANY album._id == %@", selectedAlbumId).sorted(byKeyPath: "starCount", ascending: isAscendingOrder)
        } else {
            reviewItems = repository.fetch().sorted(byKeyPath: "starCount", ascending: isAscendingOrder)
        }
        
        //로고를 눌렀을때 정렬
        if isAllSelected == true {
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
        
        //로고를 눌렀을때 정렬
        if isAllSelected == true {
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
        
        //로고를 눌렀을때 정렬
        if isAllSelected == true {
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
        //deleteButton.isEnabled = true
        mainView.collectionView.reloadData()
        isSlideGesture = true
        setupSideMenu2()
    }
    //⭐️이동 ver2
    @objc func endTransferMode() {
        isTransferMode = false
        tabBarController?.tabBar.isHidden = false
        makeNavigationUI()
        selectedItemsToTranse.removeAll()
        albumButton.isEnabled = true
        transButton.isEnabled = true
        mainView.collectionView.reloadData()
        isSlideGesture = true
        setupSideMenu2()
    }
    
    //⭐️⭐️⭐️ 데이터 삭제
    @objc func deleteSelectedItems() {
        //tabBarController?.tabBar.isHidden = true
        let deleteCount = selectedItemsToDelete.count
        
        if isAllSelected {
            // All셀에서 삭제할때는 전체 삭제
            //print("777", selectedItemsToDelete.count)
            for review in selectedItemsToDelete {
                repository.deleteReview(review)
            }
            
            // 'All'에서 삭제할 때의 알림
            let alertController = UIAlertController(title: nil, message: "모든 앨범내에서 \n\(deleteCount)개의 데이터가 삭제 되었습니다!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            endEditMode()
            
        } else if let selectedAlbumIdString = UserDefaults.standard.string(forKey: "selectedAlbumId"),
                  let selectedAlbumId = try? ObjectId(string: selectedAlbumIdString),
                  let album = realm.object(ofType: AlbumTable.self, forPrimaryKey: selectedAlbumId) {
            
            // 앨범에서 삭제할때는 해당 앨범의 데이터만 삭제하고 다른 앨범, all셀에 있는 데이터는 살림
            try! realm.write {
                for review in selectedItemsToDelete {
                    if let index = album.reviews.index(of: review) {
                        album.reviews.remove(at: index)
                    }
                }
            }
            
            // 특정 앨범에서 삭제할 때의 알림
            let alertController = UIAlertController(title: nil, message: "\(album.albumName) 앨범에서 \n\(deleteCount)개의 데이터가 삭제 되었습니다!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            endEditMode()
        } else {
            // isAllSelected도 아니고 특정 앨범에서도 아닐 경우 전체 삭제(처음 뷰디드로드화면)
            for review in selectedItemsToDelete {
                repository.deleteReview(review)
            }
            
            
            let alertController = UIAlertController(title: nil, message: "모든 앨범내에서 \n\(deleteCount)개의 데이터가 삭제 되었습니다!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            endEditMode()
        }
    }
    
    //⭐️이동 ver2
    @objc func transSelectedItems() {
        
        tabBarController?.tabBar.isHidden = false
        
        let alertController = UIAlertController(title: nil, message: "데이터를 이동할 앨범을 선택해주세요!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.present(self!.sideMenu!, animated: true)
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
            cell.imageView.kf.setImage(with: imageUrl)
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
            
            reviewVC.reviewView.infoLabel.isHidden = true
            reviewVC.reviewView.infoLabel2.isHidden = true
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
        cell.prepareForReuse()
        cell.textLabel?.text = albumNames[indexPath.row]
        cell.backgroundColor = UIColor(named: "slideCell") //UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.3))
        cell.textLabel?.textColor = UIColor(named: "goldCellText")
        cell.textLabel?.font = UIFont(name: "KCC-Ganpan", size: 16.0)
        //체크표시
        if indexPath == selectedSideMenuIndexPath {
            //cell.accessoryType = .checkmark
            //cell.tintColor = .white
            cell.backgroundColor = UIColor(named: "logoBack")
        } else {
            //cell.accessoryType = .none
        }
        
        // "+ 앨범 추가" 셀에 버튼 추가
        if indexPath.row == albumNames.count - 1 {
            let addButton = UIButton(frame: CGRect(x: 5, y: 5, width: 230, height: 35))
            //let addButton = UIButton(frame: CGRect(x: 15, y: 8, width: 200, height: 30))
            addButton.contentHorizontalAlignment = .center
            addButton.setTitle(albumNames[indexPath.row], for: .normal)
            addButton.setTitleColor(UIColor(named: "gold"), for: .normal)
            addButton.backgroundColor = .clear
            addButton.addTarget(self, action: #selector(addAlbumButtonTapped), for: .touchUpInside)
            addButton.layer.borderColor = UIColor(named: "gold")?.cgColor
            //addButton.layer.borderColor = UIColor(named: "goldCellText")?.cgColor //UIColor.white.cgColor
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
        //⭐️
        handleAlbumSelection(with: albumNames[indexPath.row], at: indexPath)
        
        let selectedAlbum = albumNames[indexPath.row]
        
        if selectedAlbum == "모두 보기" {
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
            }
        }
        
        mainView.collectionView.reloadData()
        sideMenu?.dismiss(animated: true, completion: nil)
        
        selectedSideMenuIndexPath = indexPath
        tableView.reloadData()
        
        //⭐️이동 ver2 ReviewTableRepository 담기 전 데이터 이동o, 복사x
        if isTransferMode {
            let reviewsArray = Array(selectedItemsToTranse)
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
                let alertController = UIAlertController(title: nil, message: "\(selectedAlbum) 앨범으로 \n\(reviewsArray.count)개의 데이터가 이동되었습니다!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        //⭐️⭐️⭐️ 데이터 복사o, 이동x
        //        if isTransferMode {
        //            let repository = ReviewTableRepository()
        //            let reviewsArray = Array(selectedItemsToTranse) // Set을 Array로 변환
        //            let success = repository.transferReviews(from: nil, to: selectedAlbum, reviews: reviewsArray)
        //
        //            if success {
        //                // 이동 모드 종료 및 선택 항목 초기화
        //                isTransferMode = false
        //                selectedItemsToTranse.removeAll()
        //                mainView.collectionView.reloadData()
        //                endTransferMode()
        //
        //                // 데이터 이동 완료 얼럿창 표시
        //                let alertController = UIAlertController(title: nil, message: "\(selectedAlbum) 앨범으로 \n\(reviewsArray.count)개의 데이터가 이동되었습니다!", preferredStyle: .alert)
        //                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        //                alertController.addAction(okAction)
        //                self.present(alertController, animated: true, completion: nil)
        //            }
        //        }
        
        
        
        
        
    }
    
    
    // MARK: - 사이드메뉴바 헤더 구현
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeight: CGFloat = 50
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight))
        headerView.backgroundColor = UIColor(named: "slideHeader")
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 60, height: headerHeight))
        titleLabel.text = "나의 앨범"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "KCC-Ganpan", size: 18.0)
        headerView.addSubview(titleLabel)
        
        let editButton = UIButton(frame: CGRect(x: tableView.bounds.width - 60, y: 10, width: 50, height: 30))
        editButton.setTitle("편집", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "KCC-Ganpan", size: 18.0)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 2.0
        editButton.layer.cornerRadius = 10
        editButton.clipsToBounds = true
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        headerView.addSubview(editButton)
        
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
    
    //    @objc func addAlbumButtonTapped() {
    //        sideMenu?.dismiss(animated: true, completion: {
    //            // 얼럿창
    //            let alertController = UIAlertController(title: "새로운 앨범", message: "이 앨범의 이름을 입력해주세요.", preferredStyle: .alert)
    //            alertController.addTextField { (textField) in
    //                textField.placeholder = " "
    //            }
    //            // "추가"
    //            let addAction = UIAlertAction(title: "추가", style: .default) { _ in
    //                if let newAlbumName = alertController.textFields?.first?.text, !newAlbumName.isEmpty {
    //                    let newAlbum = AlbumTable(albumName: newAlbumName)
    //
    //                    let newAlbumId = newAlbum._id
    //                    UserDefaults.standard.set(newAlbumId.stringValue, forKey: "newAlbumId")
    //                    UserDefaults.standard.set(newAlbumName, forKey: "newAlbumName")
    //
    //                    self.repository.saveAlbum(newAlbum)
    //                    self.sideMenuTableViewController.tableView.reloadData()
    //
    //                    // 새로운 앨범을 컬렉션 뷰에 추가
    //                    self.reviewItems = self.repository.fetch().filter("ANY album._id == %@", newAlbum._id)
    //                    self.mainView.collectionView.reloadData()
    //                }
    //            }
    //            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    //            alertController.addAction(addAction)
    //            alertController.addAction(cancelAction)
    //            // 얼럿창 표시
    //            self.present(alertController, animated: true, completion: nil)
    //        })
    //    }
    @objc func addAlbumButtonTapped() {
        sideMenu?.dismiss(animated: true, completion: {
            // 얼럿창
            let alertController = UIAlertController(title: "새로운 앨범", message: "이 앨범의 이름을 입력해주세요.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = " "
            }
            
            // "추가" 액션
            let addAction = UIAlertAction(title: "추가", style: .default) { _ in
                let newAlbumName = alertController.textFields?.first?.text ?? ""
                
                if !newAlbumName.isEmpty {
                    let newAlbum = AlbumTable(albumName: newAlbumName)
                    let newAlbumId = newAlbum._id
                    UserDefaults.standard.set(newAlbumId.stringValue, forKey: "newAlbumId")
                    UserDefaults.standard.set(newAlbumName, forKey: "newAlbumName")
                    
                    self.repository.saveAlbum(newAlbum)
                    self.sideMenuTableViewController.tableView.reloadData()
                    
                    // 새로운 앨범을 컬렉션 뷰에 나타내기
                    self.reviewItems = self.repository.fetch().filter("ANY album._id == %@", newAlbum._id)
                    self.mainView.collectionView.reloadData()
                    
                    //새로운 앨범 생성시 셀의 배경과 데이터 관련
                    let newIndex = self.albumNames.count - 2
                    let newIndexPath = IndexPath(row: newIndex, section: 0)
                    self.handleAlbumSelection(with: newAlbumName, at: newIndexPath)
                    self.sideMenuTableViewController.tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .none)
                    self.mainView.searchBar.placeholder = "  \(newAlbumName) 앨범"
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            
            // 얼럿창 표시
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    //⭐️
    //    func handleAlbumSelection(with albumName: String, at indexPath: IndexPath) {
    //        if albumName == "모두 보기" {
    //            isAllSelected = true
    //            reviewItems = repository.fetch()
    //            UserDefaults.standard.removeObject(forKey: "selectedAlbumId")
    //        } else if albumName == "+ 앨범 추가" {
    //            return
    //        } else {
    //            isAllSelected = false
    //            if let matchingAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", albumName).first {
    //                reviewItems = repository.fetch().filter("ANY album._id == %@", matchingAlbum._id)
    //                UserDefaults.standard.set(matchingAlbum._id.stringValue, forKey: "selectedAlbumId")
    //            }
    //        }
    //
    //        mainView.collectionView.reloadData()
    //        sideMenu?.dismiss(animated: true, completion: nil)
    //        selectedSideMenuIndexPath = indexPath
    //    }
    
    func handleAlbumSelection(with albumName: String, at indexPath: IndexPath) {
        if albumName == "모두 보기" {
            isAllSelected = true
            reviewItems = repository.fetch()
            UserDefaults.standard.removeObject(forKey: "selectedAlbumId")
            mainView.searchBar.placeholder = "  모두 보기 앨범"
        } else if albumName == "+ 앨범 추가" {
            return
        } else {
            isAllSelected = false
            if let matchingAlbum = realm.objects(AlbumTable.self).filter("albumName == %@", albumName).first {
                reviewItems = repository.fetch().filter("ANY album._id == %@", matchingAlbum._id)
                UserDefaults.standard.set(matchingAlbum._id.stringValue, forKey: "selectedAlbumId")
            }
            mainView.searchBar.placeholder = "  \(albumName) 앨범"
        }
        
        mainView.collectionView.reloadData()
        sideMenu?.dismiss(animated: true, completion: nil)
        selectedSideMenuIndexPath = indexPath
    }
    
    
    
    
    // MARK: - 슬라이드 메뉴 바 셀 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.row != 0 && indexPath.row != albumNames.count - 1
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //
    //            let albumNameToDelete = albumNames[indexPath.row]
    //            if let albumToDelete = realm.objects(AlbumTable.self).filter("albumName == %@", albumNameToDelete).first {
    //                try! realm.write {
    //                    realm.delete(albumToDelete)
    //                }
    //            }
    //
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let albumNameToDelete = albumNames[indexPath.row]
            
            // Create an alert to confirm the deletion
            let alertController = UIAlertController(title: "알림", message: "\(albumNameToDelete) 앨범의 데이터를 삭제하시겠습니까?", preferredStyle: .alert)
            
            // "확인" action
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                // Delete the album from the realm
                if let albumToDelete = self.realm.objects(AlbumTable.self).filter("albumName == %@", albumNameToDelete).first {
                    try! self.realm.write {
                        self.realm.delete(albumToDelete)
                    }
                    // Update the table view
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            // Close the SideMenu before presenting the alert
            sideMenu?.dismiss(animated: true, completion: {
                // Show the alert
                self.present(alertController, animated: true, completion: nil)
            })
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

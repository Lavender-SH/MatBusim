//
//  SettingViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit
import MessageUI
import RealmSwift

enum Section: Int, CaseIterable {
    case theme = 0
    case backupRestore
    case about
    case reset
    
    var title: String {
        switch self {
        case .theme: return "테마"
        case .backupRestore: return "백업/복구/공유"
        case .about: return "맛슐랭"
        case .reset: return "초기화"
        }
    }
    
    var items: [String] {
        switch self {
        case .theme: return ["라이트모드", "다크모드"]
        case .backupRestore: return ["백업/복구/공유하기", "데이터 초기화"]
        case .about: return ["문의/의견", "맛슐랭 \(Utils.getAppVersion()) Version"]
        case .reset: return ["데이터 초기화"]
        }
    }
}

class SettingsViewController: UIViewController, UITableViewDelegate, UIDocumentPickerDelegate, MFMailComposeViewControllerDelegate {
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, String>!
    private var selectedTheme: String = "라이트모드"
    var isEmailBeingSent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "logoBack")
        
        makeNavigationUI()
        configureTableView()
        configureDataSource()
        applyInitialSnapshots()
        addLogoToView()
        
        selectedTheme = loadThemeFromRealm()
        
        let initialSnapshot = createInitialSnapshot()
        dataSource.apply(initialSnapshot, animatingDifferences: true)
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
        // "matlogo" 이미지를 네비게이션 제목 타이틀에 추가
        let logo = UIImage(named: "투명로고")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "settingBack")
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func addLogoToView() {
        let logo = UIImage(named: "투명아이콘")
        let imageView2 = UIImageView(image: logo)
        view.addSubview(imageView2)
        
        imageView2.snp.makeConstraints { make in
            make.top.equalTo(view).offset(-25)
            make.centerX.equalTo(view)
            make.size.equalTo(150)
        }
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item
            cell.backgroundColor = UIColor(named: "settingCell")
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name: "KCC-Ganpan", size: 14.0)
            
            if item == self.selectedTheme {
                cell.accessoryType = .checkmark
                cell.tintColor = .white
            } else {
                cell.accessoryType = .none
            }
            
            if item == "맛슐랭 1.0.0 Version" {
                cell.isUserInteractionEnabled = false
            }
            
            return cell
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(section.items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createInitialSnapshot() -> NSDiffableDataSourceSnapshot<Section, String> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(section.items)
        }
        return snapshot
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Section.allCases.map { $0.title }
    }
    
    // MARK: - 테이블뷰 헤더
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "settingTableHeader")
        let titleLabel = UILabel()
        titleLabel.text = Section(rawValue: section)?.title
        titleLabel.font = UIFont(name: "KCC-Ganpan", size: 16.0)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerView).offset(16)
            make.trailing.equalTo(headerView).offset(-16)
            make.top.bottom.equalTo(headerView)
        }
        
        return headerView
    }
    
    func visibleSectionHeaders(in tableView: UITableView) -> [UITableViewHeaderFooterView] {
        return (0..<tableView.numberOfSections).compactMap { section in
            let rect = tableView.rectForHeader(inSection: section)
            if tableView.bounds.intersects(rect) {
                return tableView.headerView(forSection: section)
            }
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    
    // MARK: - 다크모드&화이트모드
    func applyTheme(_ theme: String) {
        if theme == "라이트모드" {
            UserDefaults.standard.set("light", forKey: "appTheme")
        } else {
            UserDefaults.standard.set("dark", forKey: "appTheme")
        }
        //window에도 적용
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let windows = window.windows.first
        windows?.overrideUserInterfaceStyle = theme == "라이트모드" ? .light : .dark
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .theme:
            let selectedItem = dataSource.itemIdentifier(for: indexPath)
            selectedTheme = selectedItem ?? "라이트모드"
            saveThemeToRealm(selectedTheme)
            applyTheme(selectedTheme)
            var snapshot = dataSource.snapshot()
            snapshot.reloadSections([section])
            dataSource.apply(snapshot, animatingDifferences: true)
        case .backupRestore:
            if indexPath.row == 0 {
                let backUpVC = BackUpViewController()
                navigationController?.pushViewController(backUpVC, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        case .about:
            if indexPath.row == 0 { // "문의/의견" 항목을 선택했을 때
                isEmailBeingSent = true
                sendEmail()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        case .reset:
            if indexPath.row == 0 {  // "데이터 초기화" 셀을 선택했을 때
                let alert = UIAlertController(title: "초기화 경고", message: "모든 데이터가 삭제됩니다. 정말로 계속하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
                    // 데이터 삭제 함수 호출
                    ReviewTableRepository().clearAllData()
                    
                    //실행되지 않음
//                    if let navController = self.navigationController,
//                       let mainVC = navController.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
//                        mainVC.refreshViewContents()
//                    }
                    // 데이터 삭제 후 새로운 얼럿 표시
                    let completionAlert = UIAlertController(title: "초기화 완료", message: "초기화가 완료되었습니다! \n앱을 다시 실행해 주시기 바랍니다.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "확인", style: .default)
                    completionAlert.addAction(okayAction)
                    self.present(completionAlert, animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
        }
        
        
    }
    // 앱을 껏다 켜도 테마를 저장하기 위해 Realm 이용
    func saveThemeToRealm(_ theme: String) {
        let realm = try! Realm()
        if let userTheme = realm.objects(UserTheme.self).first {
            try! realm.write {
                userTheme.selectedTheme = theme
            }
        } else {
            let newUserTheme = UserTheme()
            newUserTheme.selectedTheme = theme
            try! realm.write {
                realm.add(newUserTheme)
            }
        }
    }
    
    func loadThemeFromRealm() -> String {
        let realm = try! Realm()
        return realm.objects(UserTheme.self).first?.selectedTheme ?? "라이트모드"
    }
    
    
    // MARK: - Email
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
            mail.setToRecipients(["susie204@naver.com"])
            mail.setSubject("맛슐랭 / 문의,의견")
            mail.setMessageBody(bodyString, isHTML: false)
            present(mail, animated: true)
        } else {
            print("Email services are not available")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        isEmailBeingSent = false
        controller.dismiss(animated: true)
    }
    
}

// MARK: - Email Utils
final class Utils {
    static func getAppVersion() -> String {
        let fullVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        let regexPattern = #"^(\d+\.\d+\.\d+)"#
        if let regex = try? NSRegularExpression(pattern: regexPattern),
           let match = regex.firstMatch(in: fullVersion, options: [], range: NSRange(location: 0, length: fullVersion.utf16.count)),
           let range = Range(match.range(at: 1), in: fullVersion) {
            return String(fullVersion[range])
        }
        return fullVersion
    }
    
    static func getBuildVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    static func getDeviceModelName() -> String {
        let device = UIDevice.current
        let modelName = device.name
        if modelName.isEmpty {
            return "알 수 없음"
        } else {
            return modelName
        }
    }
    
}

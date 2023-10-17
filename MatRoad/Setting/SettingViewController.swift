//
//  SettingViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/30.
//

import UIKit
import SnapKit
import MessageUI

enum Section: Int, CaseIterable {
    case theme = 0
    case backupRestore
    case about
    
    var title: String {
        switch self {
        case .theme: return "테마"
        case .backupRestore: return "백업/복구"
        case .about: return "맛슐랭"
        }
    }
    
    var items: [String] {
        switch self {
        case .theme: return ["라이트모드", "다크모드"]
        case .backupRestore: return ["백업/복구하기"]
        case .about: return ["문의/의견", "맛슐랭 1.0 Version"]
        }
    }
}

class SettingsViewController: UIViewController, UITableViewDelegate, UIDocumentPickerDelegate, MFMailComposeViewControllerDelegate {
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, String>!
    private var selectedTheme: String = "라이트모드"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationUI()
        configureTableView()
        configureDataSource()
        applyInitialSnapshots()
        
        let initialSnapshot = createInitialSnapshot()
        dataSource.apply(initialSnapshot, animatingDifferences: true)
    }
    
    func makeNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(cgColor: .init(red: 0.333, green: 0.333, blue: 0.333, alpha: 1))
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        // "matlogo" 이미지를 네비게이션 제목 타이틀에 추가
        let logo = UIImage(named: "matlogo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.backgroundColor = UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1))
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item
            cell.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
            cell.textLabel?.textColor = .white
            
            if item == self.selectedTheme {
                cell.accessoryType = .checkmark
                cell.tintColor = .white
            } else {
                cell.accessoryType = .none
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
        headerView.backgroundColor = UIColor(named: "White")//UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1))
        
        let titleLabel = UILabel()
        titleLabel.text = Section(rawValue: section)?.title
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
            applyTheme(selectedTheme)
            var snapshot = dataSource.snapshot()
            snapshot.reloadSections([section])
            dataSource.apply(snapshot, animatingDifferences: true)
        case .backupRestore:
            if indexPath.row == 0 {
                let backUpVC = BackUpViewController()
                navigationController?.pushViewController(backUpVC, animated: true)
            }
        case .about:
            if indexPath.row == 0 { // "문의/의견" 항목을 선택했을 때
                sendEmail()
            }
            //default: break
        }
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
        controller.dismiss(animated: true)
    }
    
}

// MARK: - Email Utils
final class Utils {
    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
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
        let selName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selName)
        
        if device.responds(to: selector) { // [옵셔널 체크 실시]
            let modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
            return modelName
        }
        return "알 수 없음"
    }
}

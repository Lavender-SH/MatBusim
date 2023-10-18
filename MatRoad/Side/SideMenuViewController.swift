//
//  SideMenuViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/17.
//

import UIKit
import SnapKit
import RealmSwift
import SideMenu

class SideMenuViewController: BaseViewController {
    //Realm 관련 변수
    var reviewItems: Results<ReviewTable>!
    var albumItems: Results<AlbumTable>!
    let realm = try! Realm()
    let repository = ReviewTableRepository()
    //사이드메뉴 관련 변수
    var menuTableView = UITableView()
    var albumNames: [String] {
        let albums = realm.objects(AlbumTable.self).map { $0.albumName }
        return ["All"] + albums + ["+ 앨범 추가"]
    }
    var selectedSideMenuIndexPath: IndexPath? = IndexPath(row: 0, section: 0)
    var isAllSelected: Bool = false
    var isTransferMode = false
    var isDeleteMode = false
    
    override func configureView() {
        view.addSubview(menuTableView)
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.rowHeight = 50
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuCell")
        menuTableView.separatorStyle = .none
        setupSideMenu()
    }
    
    override func setConstraints() {
        menuTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupSideMenu() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.rowHeight = 50
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuCell")
        menuTableView.separatorStyle = .none
        // 테이블 뷰와 셀의 배경색을 black으로 설정
        menuTableView.backgroundColor = .black
        menuTableView.separatorColor = .darkGray // 구분선을 흰색으로 설정
        // 셀 구분선이 왼쪽 끝까지 보이게 설정
        menuTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
        cell.textLabel?.text = albumNames[indexPath.row]
        cell.backgroundColor = UIColor(cgColor: .init(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.3))
        cell.textLabel?.textColor = .white
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
            addButton.layer.borderWidth = 1.0
            addButton.layer.cornerRadius = 10
            addButton.clipsToBounds = true
            
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
        let mainVC = MainViewController()
        mainVC.mainView.collectionView.reloadData()
        
        let sideMenuViewController = SideMenuViewController()
        let menu = SideMenuNavigation(rootViewController: sideMenuViewController)
        menu.dismiss(animated: true, completion: nil)
        
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
        if isTransferMode {
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeight: CGFloat = 50
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight))
        headerView.backgroundColor = .darkGray
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 60, height: headerHeight))
        titleLabel.text = "My Album"
        titleLabel.textColor = .white
        headerView.addSubview(titleLabel)
        
        let editButton = UIButton(frame: CGRect(x: tableView.bounds.width - 60, y: 10, width: 50, height: 30))
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 1.0
        editButton.layer.cornerRadius = 10
        editButton.clipsToBounds = true
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        headerView.addSubview(editButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func editButtonTapped() {
        isDeleteMode.toggle()
        menuTableView.setEditing(isDeleteMode, animated: true)
        
    }
    
    @objc func addAlbumButtonTapped() {
        let sideMenuViewController = SideMenuViewController()
        let menu = SideMenuNavigation(rootViewController: sideMenuViewController)
        menu.dismiss(animated: true, completion: {
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
                    self.menuTableView.reloadData()
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
    
    
    
}

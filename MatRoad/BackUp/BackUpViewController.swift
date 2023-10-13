//
//  BackUpViewController.swift
//  PhotoGramRealm
//
//  Created by 이승현 on 2023/09/07.
//

import UIKit
import SnapKit
import Zip

class BackUpViewController: BaseViewController {
    
    let backUpView = BackUpView()
    var selectedFileURL: URL?
    
    override func loadView() {
        self.view = backUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationUI()
        backUpView.backupTableView.delegate = self
        backUpView.backupTableView.dataSource = self
        backUpView.backupTableView.register(BackUpTableViewCell.self, forCellReuseIdentifier: "BackUpTableViewCell")
        view.backgroundColor = UIColor(cgColor: .init(red: 0.07, green: 0.07, blue: 0.07, alpha: 1))
        
        backUpView.backUpButton.addTarget(self, action: #selector(backupButtonTapped), for: .touchUpInside)
        backUpView.restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
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
 
        let logo = UIImage(named: "matlogo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    
    @objc func backupButtonTapped() {
        //1. 백업하고자 하는 파일들의 경로 배열 생성
        var urlPaths = [URL]()
        
        //2. 도큐먼트 위치
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        //3. 백업하고자 하는 파일 경로 ex ~~~/~~/~~~/Document/default.realm
        let realmFile = path.appendingPathComponent("default.realm")
        
        //4. 3번 경로가 유효한 지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            print("백업할 파일이 없습니다.")
            return
        }
        //5. 압축하고자 하는 파일을 배열에 추가
        urlPaths.append(realmFile)
        
        // 현재 날짜와 시간을 가져와서 파일명 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd_HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())
        let fileName = "matchelin_\(currentDateTime)"
        
        //6. 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: fileName)
            print("location: \(zipFilePath)")
            backUpView.backupTableView.reloadData()
        } catch {
            print("압축을 실패했어요")
        }
    }
    
    //⭐️⭐️⭐️
    func unzipAndRestore(fileURL: URL) {
        guard let destinationPath = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        do {
            try Zip.unzipFile(fileURL, destination: destinationPath, overwrite: true, password: nil)
            print("복구 완료!")
        } catch {
            print("압축 해제 실패: \(error)")
        }
    }
    
    @objc func restoreButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
}
//⭐️⭐️⭐️
extension BackUpViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function, urls)
        
        guard let selectFileURL = urls.first else { // 파일앱에서의 URL
            print("선택한 파일에 오류가 있어요")
            return
        }
        
        let alertController = UIAlertController(title: "맛슐랭 복구", message: "복구하실 경우 기존에 저장된 내용은 완전히 소실되니 주의해주세요. 복구할 데이터의 양에 따라 1~3분이 소요될 수 있습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.proceedWithRestore(using: selectFileURL)
        }
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func proceedWithRestore(using fileURL: URL) {
        
        guard let path = documentDirectoryPath() else { // 앱 도큐먼트 path
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        
        // 도큐먼트 폴더 내 저장할 경로 설정
        let sandboxFileURL = path.appendingPathComponent(fileURL.lastPathComponent)
        
        // 경로에 복구할 파일(zip)이 이미 있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            do {
                print("fileURL: \(sandboxFileURL)")
                // 압축 해제
                try Zip.unzipFile(sandboxFileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료: \(unzippedFile)")
                    NotificationCenter.default.post(name: NSNotification.Name("didRestoreBackup"), object: nil)
                    let completionAlert = UIAlertController(title: "복구 완료", message: "복구되었습니다.\n반드시 앱을 재부팅 시켜주세요!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    completionAlert.addAction(okAction)
                    self.present(completionAlert, animated: true, completion: nil)
                })
            } catch {
                print(123123)
                print(error)
                print("압축 해제 실패")
            }
        } else {
            // 경로에 복구할 파일이 없을 경우
            do {
                try FileManager.default.copyItem(at: fileURL, to: sandboxFileURL)
                try Zip.unzipFile(sandboxFileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료: \(unzippedFile)")
                    NotificationCenter.default.post(name: NSNotification.Name("didRestoreBackup"), object: nil)
                })
            } catch {
                print(456456456)
                print(error)
                print("압축 해제 실패")
            }
        }
    }
    
}

extension BackUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func fetchZipList() -> [(name: String, size: String)] {
        var list: [(name: String, size: String)] = []
        
        do {
            guard let path = documentDirectoryPath() else { return list }
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            let zipFiles = docs.filter { $0.pathExtension  == "zip" }
            
            for fileURL in zipFiles {
                let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                let fileSize = attributes[.size] as! Int64
                let fileSizeKB = Double(fileSize) / 1024.0
                let formattedSize = String(format: "%.2f KB", fileSizeKB)
                list.append((name: fileURL.lastPathComponent, size: formattedSize))
            }
        } catch {
            print("Error")
        }
        return list
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BackUpTableViewCell", for: indexPath) as? BackUpTableViewCell else {
            return UITableViewCell()
        }
        let zipInfo = fetchZipList()[indexPath.row]
        cell.setCellData(fileName: zipInfo.name, fileSize: zipInfo.size)
        cell.backgroundColor = UIColor(cgColor: .init(red: 0.07, green: 0.07, blue: 0.07, alpha: 1))
        cell.tintColor = .white
        return cell
    }
    
    //⭐️⭐️⭐️
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivityViewController(fileName: fetchZipList()[indexPath.row].name)
    }
    
    func showActivityViewController(fileName: String)  {
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        let backupFileURL = path.appendingPathComponent(fileName)
        
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    
    // MARK: - 테이블뷰 슬라이드 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // zip 파일 삭제
            let fileName = fetchZipList()[indexPath.row].name
            guard let path = documentDirectoryPath() else {
                print("도큐먼트 위치에 오류가 있어요")
                return
            }
            let fileURL = path.appendingPathComponent(fileName)
            
            do {
                try FileManager.default.removeItem(at: fileURL)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("파일 삭제 실패: \(error)")
            }
        }
    }
    
}

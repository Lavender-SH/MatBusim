# 칠하다 - 상상한 것을 색칠하고 프린트하다. 

<p>
<img src="https://github.com/user-attachments/assets/3c36be2f-3ea8-4a90-92c7-4a125d153fa6" width="25%">
<img src="https://github.com/user-attachments/assets/142cc510-254d-4923-988c-d79681e214e7" width="15%">


<img src="https://github.com/user-attachments/assets/deef0ce2-a9cf-4c02-9a60-f654711c439b" width="23%">
<p>

- [News Article - EPSON Innovation Chanllenge 공식 뉴스 기사](http://www.mediagb.kr/news/view.php?idx=35219)</br>

- [한국 엡손 EPSON 공식 블로그 기사](https://blog.naver.com/epsonstory/223554685463)</br>

- [실제 글로벌 기업 EPSON 홍보에 쓰인 유튜브 영상 링크](https://youtu.be/ldD-e7rh5Lo)</br>


## 프로젝트 소개
### 앱 설명
 - 칠하다 앱은 AI 기술을 활용하여 아이가 상상한 그림을 음성으로 입력하면 해당 도안을 생성하고, 이를 프린트하여 색칠 놀이를 즐길 수 있는 앱입니다. 색칠이 완료된 후에는 도안을 스캔하여, 색칠한 캐릭터와 함께 사진을 찍어 추억을 남길 수 있습니다.
 
 <img src="https://github.com/user-attachments/assets/d8854ab6-c450-47ee-a990-11f3066264e8" width="100%">
 
<img src="https://github.com/user-attachments/assets/57dc5614-bf74-4578-8909-1bc9dd3bd91c" width="100%">

### 성과
 - 엡손 Epson Innovation Challenge 최우수상(1위) 수상, 상금 1,000만 원</br>
 - 국내 최초 개최 및 세계 3번째로 열린 글로벌 대회에서 우승
 - 엡손 Epson과 파트너쉽 체결, 글로벌 앱 런칭 진행중</br>
 
 <img src="https://github.com/user-attachments/assets/582d07ce-41ed-4ea7-888f-feac27aa24e5" width="90%"></br>
    한국엡손(주) 대표이사 후지이 시게오(CEO)
 
### 프로젝트 기간
- 2024.06.01 ~ 2024.6.29 (4주) </br>

### 프로젝트 참여 인원
- iOS Developer 1명, Back-end 2명, Design 1명, PM 1명

</br>

## 기술 스택
- **Framework**
`UIKit`, `Speech`, `Alamofire`, `Kingfisher`, `SnapKit`, `Photos`, `AVFoundation`, `Gifu`, `Lottie`

- **Design Pattern**
`MVC`

- **전체 시스템 아키텍처**
 <img src="https://github.com/user-attachments/assets/ee45f724-b13b-4777-8ed1-6c282a5266a3" width="100%"></br>

</br>

## 핵심 기능과 코드 설명

- **1.음성인식을 활용한 텍스트 추출 및 도안 생성**</br>
- **2.생성된 도안 인쇄하기(EPSON Connect API)**</br>
- **3.스캔한 도안을 스캔함에서 관리하고 갤러리에 저장**</br>
- **4.스캔된 캐릭터에 모션을 적용하여 움직이게 만들기**</br>
- **5.스캔된 캐릭터를 활용한 스티커 사진 촬영**</br>


 ### 1.음성인식을 활용한 텍스트 추출 및 도안 생성
칠하다 앱은 음성인식(Speech Recognition)을 활용하여 사용자의 음성을 실시간으로 텍스트로 변환합니다. 변환된 텍스트는 AI 기반 도안 생성 API와 연동되어, 사용자가 상상한 내용을 도안으로 시각화합니다. 음성인식의 효율성을 높이기 위해 iOS의 SFSpeechRecognizer를 사용하고, 비동기 네트워크 요청으로 사용자 경험을 향상시켰습니다.</br>

    
 <img src="https://github.com/user-attachments/assets/019a628a-62e5-4273-8114-55c8a9237037" width="99%"></br>

1. [`Speech` 프레임 워크 사용](https://developer.apple.com/documentation/speech/)</br>
2. `speechRecognizer`: 한국어 음성 인식을 담당
3. `recognitionRequest`: 음성 데이터를 SFSpeechRecognizer로 전달하는 요청 객체
4. `audioEngine`: 마이크 입력 데이터를 관리

 ``` swift
let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
var recognitionTask: SFSpeechRecognitionTask?
let audioEngine = AVAudioEngine()
 ```
</br>

### 1-1. 음성인식 시작
 - 사용자가 버튼을 누르면 음성 입력이 시작되며 audioEngine이 마이크 데이터를 수집</br>
 - 인식 중간에 버튼을 다시 누르면 음성 입력 종료</br>
 
``` swift
@objc func startRecording() {
    if audioEngine.isRunning {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        voiceView.recordButton.isEnabled = false
    } else {
        startSpeechRecognition()
        voiceView.recordButton.setTitle("Stop", for: [])
        showBottomSheet()
    }
}
```
 ### 1-2. 음성 데이터를 텍스트로 변환
  - 입력 데이터: audioEngine이 마이크 데이터를 수집해 recognitionRequest로 전달</br>
  - 텍스트 변환: 음성 데이터는 SFSpeechRecognizer로 변환되며, bestTranscription 속성에서 최적화된 텍스트를 가져옴</br>
  - 중간결과 처리: shouldReportPartialResults를 활성화하여 실시간으로 변환된 텍스트 표시</br>
  
``` swift
func startSpeechRecognition() {
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    let inputNode = audioEngine.inputNode

    recognitionRequest?.shouldReportPartialResults = true

    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
        if let result = result {
            self.recognizedText = result.bestTranscription.formattedString
            self.bottomSheetView.updateText(self.recognizedText)
        }
        if error != nil || result?.isFinal == true {
            self.audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
    }

    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
        self.recognitionRequest?.append(buffer)
    }
    audioEngine.prepare()
    try? audioEngine.start()
}

```
 </br>
 
 ### 1-3. 변환된 텍스트를 기반으로 도안 생성
 - 변환된 테스트를 서버에 전달</br>
 - Alamofire로 통신 네트워크 요청을 비동기로 처리하여 UI가 멈추지 않도록 설정</br>
 - 도안 생성: 서버에서 생성된 도안의 URL과 ID를 반환</br>
 - JSON 형식으로 변환된 데이터를 간편하게 서버로 전송</br>
 - 생성된 도안 결과 표시: 도안을 로드하여 새로운 화면에서 사용자에게 시각화</br>

```swift
@objc func generateDrawing() {
    let prompt = voiceView.textView.text ?? ""
    let parameters: [String: Any] = ["prompt": prompt]

    AF.request("https://api.zionhann.com/chillin/drawings/gen", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let drawingId = json["drawingId"] as? Int,
                   let urlString = json["url"] as? String,
                   let url = URL(string: urlString) {
                    let createDrawingVC = CreateDrawingViewController()
                    createDrawingVC.loadImage(from: url)
                    createDrawingVC.drawingId = drawingId
                    self.navigationController?.pushViewController(createDrawingVC, animated: true)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
}


```
</br>

### 2.생성된 도안 인쇄하기(EPSON Connect API)
칠하다 앱은 Epson Connect API를 활용하여 생성된 도안을 인쇄하는 기능을 제공합니다. 사용자는 출력물의 크기를 선택한 후, 프린터와의 통신을 통해 원하는 크기로 도안을 인쇄할 수 있습니다. 이 과정은 사용자의 선택을 기반으로 서버와 비동기로 통신하며, 안정적인 사용자 경험을 보장합니다.</br>

 <img src="https://github.com/user-attachments/assets/531725e3-b311-440a-977b-8750901e9eb8" width="99%"></br>

 1. Epson Connect API: Epson 프린터와의 통신을 통해 인쇄를 처리</br>
 2. Alamofire: 서버와의 네트워크 통신 처리</br>
 3. UIAlertController: 사용자 확인 메시지 표시</br>
 4. JSON Encoding: 데이터 전송을 위한 JSON 형식 변환</br>
 
 ### 2-1. 크기 선택 및 사용자 확인
  - 사용자가 출력물 크기를 선택하면, 선택된 크기가 서버로 전달되어 인쇄 준비를 진행합니다. 크기 선택은 버튼을 통해 이루어지며, 선택된 크기는 `selectedSize` 변수에 저장됩니다.</br>

 ```swift
 @objc func sizeButtonTapped(_ sender: UIButton) {
    let buttons = [createDrawingView.largeSizeButton, createDrawingView.mediumSizeButton, createDrawingView.smallSizeButton]
    buttons.forEach { button in
        if button == sender {
            button.backgroundColor = .lightGray
            switch button {
            case createDrawingView.largeSizeButton:
                selectedSize = "LARGE"
            case createDrawingView.mediumSizeButton:
                selectedSize = "MEDIUM"
            case createDrawingView.smallSizeButton:
                selectedSize = "SMALL"
            default:
                selectedSize = "LARGE"
            }
        } else {
            button.backgroundColor = .white
        }
    }
}

```
</br>
 
 ### 2-2. 서버로 인쇄 요청
  - Epson Connect API를 통해 도안 ID와 크기 데이터를 JSON 형식으로 서버에 전달합니다. 네트워크 요청은 Alamofire를 사용하여 처리하며, 성공 여부에 따라 사용자에게 결과를 알립니다.</br>

``` swift
func printDrawing() {
    guard let drawingId = drawingId else { return }
    let parameters: [String: Any] = ["drawingId": drawingId, "scale": selectedSize]
    
    AF.request("https://api.zionhann.com/chillin/drawings/print", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
        if let statusCode = response.response?.statusCode {
            if statusCode == 200 {
                print("Print Success: \(response)")
                self.showPrintSuccessAlert()
            } else {
                print("Print Failure: \(response)")
                self.showPrintFailureAlert()
            }
        } else {
            print("Error: \(response.error ?? AFError.explicitlyCancelled)")
            self.showPrintFailureAlert()
        }
        self.createDrawingView.printSuccessReturnUI(false)
    }
}


```
</br>

### 3. 스캔한 도안을 스캔함에서 관리하고 갤러리에 저장
 - 칠하다 앱은 사용자가 스캔한 도안을 스캔함에서 확인할 수 있는 기능을 제공합니다. 이 기능은 서버와의 통신을 통해 사용자가 생성한 도안을 불러와 깔끔한 UI로 표시합니다. 페이지네이션을 통해 한 번에 많은 데이터를 불러오지 않고, 스크롤 시 추가 데이터를 로드하는 방식으로 효율적으로 데이터를 관리합니다.</br>
 
  <img src="https://github.com/user-attachments/assets/04b5181b-2b7b-4d8f-8784-b60cc10bfb7b" width="99%"></br>

 1. Alamofire: 서버에서 스캔 데이터를 비동기로 가져오기</br>
 2. UICollectionView: 사용자 인터페이스에서 도안을 정렬 및 표시</br>
 3. Kingfisher: 서버에서 받은 이미지 URL을 빠르게 렌더링</br>
 4. Pagination: 데이터 요청을 효율적으로 관리하기 위해 페이지 단위로 데이터 로드</br>

### 3-1. 스캔함의 도안 데이터 불러오기
 - 스캔함에 저장된 도안을 불러오기 위해 서버에 GET 요청을 보냅니다. 요청 시, 현재 페이지 정보와 데이터를 필터링하기 위한 매개변수를 전달합니다. 데이터를 받아오는 동안 로딩 상태를 유지하며, 서버 응답에 따라 UI를 업데이트합니다.</br>
 
``` swift
func fetchDrawings(page: Int) {
    guard !isLoading, hasMoreData else { return }
    isLoading = true
    
    let url = "https://api.zionhann.com/chillin/drawings"
    let parameters: [String: Any] = ["type": "GENERATED", "page": page]
    
    AF.request(url, method: .get, parameters: parameters).responseJSON { response in
        self.isLoading = false
        switch response.result {
        case .success(let value):
            if let json = value as? [String: Any], let data = json["data"] as? [[String: Any]] {
                let newDrawings = data.compactMap { Drawing(dictionary: $0) }
                if newDrawings.isEmpty {
                    self.hasMoreData = false
                } else {
                    self.drawings.append(contentsOf: newDrawings)
                    self.scanView.collectionView.reloadData()
                }
            }
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}

```
</br>

### 3-2. 스캔 도안의 UI 표시
 - 불러온 도안 데이터를 `UICollectionView`를 사용해 표시합니다. 각 도안은 `CollectionViewCell`에 이미지와 함께 깔끔하게 렌더링되며, 사용자가 스캔함의 도안을 쉽게 탐색할 수 있습니다.</br>
 
```swift
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return drawings.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    let drawing = drawings[indexPath.item]
    cell.configure(with: drawing)
    return cell
}

```
</br>

### 3-3. 페이지네이션 구현
 - 스크롤 위치를 감지해 추가 데이터를 요청합니다. 사용자가 스크롤을 내려 끝에 도달하면 다음 페이지 데이터를 서버에서 요청하고, 기존 데이터와 병합하여 표시합니다.</br>
 
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height

    if offsetY > contentHeight - height * 2 {
        currentPage += 1
        fetchDrawings(page: currentPage)
    }
}

```
</br>

### 3-4. 스캔 도안 상세보기 및 저장하기
 - 스캔함에서 도안을 선택하면, 해당 도안의 상세 화면으로 이동합니다. 상세 화면에서는 선택한 도안을 확대하거나, 인쇄 및 저장과 같은 추가 작업을 수행할 수 있습니다.</br>
 
 - **1. `Photos` Framework 활용**</br>
 - `PHPhotoLibrary`를 사용하여 사진 라이브러리에 접근 권한을 요청하고, 저장 작업을 수행합니다.</br>
 
 - **2. 권한 요청 및 이미지 저장**</br>
 - 사용자가 권한을 허용하면, 선택한 도안 이미지를 갤러리에 저장합니다.</br>
 - 저장 완료 후 알림 창으로 사용자에게 피드백을 제공합니다.</br>
 
``` swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let drawing = drawings[indexPath.item]
    let scanCheckVC = ScanCheckViewController()
    scanCheckVC.drawing = drawing
    scanCheckVC.drawingId = drawing.drawingId
    
    let scanCheckNaviController = UINavigationController(rootViewController: scanCheckVC)
    scanCheckNaviController.modalPresentationStyle = .overFullScreen
    self.present(scanCheckNaviController, animated: true, completion: nil)
}

```
</br>
 
``` swift
@objc func saveImageButtonTapped() {
    guard let image = scanCheckView.resultImageView.image else { return }
    
    PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            print("Authorization denied")
        }
    }
}

@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
        print("Error saving image: \(error.localizedDescription)")
    } else {
        print("Image saved successfully")
        let alert = UIAlertController(title: "저장 완료", message: "이미지가 갤러리에 저장되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
 ```
 </br>

### 4. 스캔된 캐릭터에 모션을 적용하여 움직이게 만들기
 - 사용자는 스캔된 캐릭터를 선택하여 다양한 모션 효과를 적용할 수 있으며, 생성된 애니메이션은 GIF로 저장하여 간직할 수 있습니다. 캐릭터와 모션의 조합으로 창의적이고 재미있는 사용자 경험을 제공합니다.</br>
 
 <img src="https://github.com/user-attachments/assets/b9dd4030-9483-436a-99c6-3d9e8ce008cc" width="100%">

### 4-1. 캐릭터 선택 및 모션 타입 지정
 - 사용자는 UICollectionView를 통해 스캔된 캐릭터를 선택합니다.</br>
 - 이후 모션 타입 버튼(댄스, 안녕, 점프, 좀비 등) 중 하나를 선택하여 움직임을 설정합니다.</br>
 - 선택된 모션 타입은 서버 요청 시 전달되어 애니메이션 처리에 반영됩니다.</br>
 
 ``` swift
 @objc func motionButtonTapped(_ sender: UIButton) {
    let buttons = [motionCheckView.danceButton, motionCheckView.helloButton, motionCheckView.jumpButton, motionCheckView.zombieButton]
    buttons.forEach { button in
        if button == sender {
            button.backgroundColor = .lightGray
            switch button {
            case motionCheckView.danceButton:
                motionSelected = "dance"
            case motionCheckView.helloButton:
                motionSelected = "hello"
            case motionCheckView.jumpButton:
                motionSelected = "jump"
            case motionCheckView.zombieButton:
                motionSelected = "zombie"
            default:
                break
            }
        } else {
            button.backgroundColor = .white
        }
    }
}

 ``` 
 </br>
 
### 4-2. 서버 요청을 통해 GIF 애니메이션 생성
 - Alamofire를 사용하여 선택된 캐릭터와 모션 타입을 서버에 전달합니다.</br>
 - 서버는 요청받은 데이터를 기반으로 GIF 파일을 생성하고, 결과 URL을 반환합니다.</br>
 
``` swift
@objc func motionStartButtonTapped() {
    guard let drawing = drawing else { return }
    guard let motionSelected = motionSelected else { return }

    let url = "https://api.zionhann.com/chillin/motion/\(drawing.drawingId)"
    let parameters: [String: Any] = ["motionType": motionSelected]

    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
        switch response.result {
        case .success(let value):
            if let json = value as? [String: Any], let gifUrlString = json["url"] as? String, let gifUrl = URL(string: gifUrlString) {
                self.presentMotionResultViewController(with: gifUrl)
            } else {
                self.showAlert(message: "해당 그림은 움직이게 할 수 없습니다!")
            }
        case .failure:
            self.showAlert(message: "모션 적용에 실패했습니다.")
        }
    }
}
  
```
</br>

### 4-3. GIF 결과 보기 및 저장
 - 서버에서 반환된 GIF URL을 사용해 `Gifu` 라이브러리로 애니메이션을 UI에 표시합니다.</br>
 - GIF 파일은 `Photos` Framework를 통해 사용자의 갤러리에 저장할 수 있습니다. 저장 후에는 알림을 통해 저장 성공 여부를 알려줍니다.</br>

``` swift
func saveGifToLibrary(data: Data) {
    PHPhotoLibrary.requestAuthorization { status in
        guard status == .authorized else { return }
        PHPhotoLibrary.shared().performChanges({
            let options = PHAssetResourceCreationOptions()
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: data, options: options)
        }) { success, error in
            if success {
                self.showSaveSuccessAlert()
            } else {
                self.showSaveErrorAlert(error: error)
            }
        }
    }
}

```
</br>

### 5. 스캔된 캐릭터를 활용한 스티커 사진 촬영
 - 스캔된 캐릭터를 사진 촬영에 활용하여 사용자 맞춤형 스티커 이미지를 생성할 수 있도록 구현되었습니다.</br>
 - 사용자는 카메라 화면에 캐릭터 이미지를 오버레이하여 실시간 미리보기 상태에서 촬영할 수 있습니다.</br>
 - 촬영된 이미지는 스티커가 포함된 형태로 사용자 갤러리에 저장됩니다.</br>
 
<img src="https://github.com/user-attachments/assets/b9dd4030-9483-436a-99c6-3d9e8ce008cc" width="100%">
 
 ### 5-1. 카메라 오버레이 설정
  - 스캔된 캐릭터 이미지를 카메라 화면에 오버레이하여 스티커처럼 배치합니다.</br>
  - 사용자는 드래그(이동)와 핀치 제스처(크기 조절)를 통해 스티커의 위치와 크기를 조정할 수 있습니다.</br>
  
``` swift
func createOverlayView() -> UIView {
    let overlayView = UIView(frame: view.bounds)
    overlayView.backgroundColor = .clear
    overlayView.isUserInteractionEnabled = true

    let removeImageViewFrame = motionCheckView.convert(motionCheckView.removeImageView.frame, to: overlayView)
    let removeImageView = UIImageView(frame: removeImageViewFrame)
    removeImageView.image = motionCheckView.removeImageView.image
    removeImageView.contentMode = .scaleAspectFill
    removeImageView.isUserInteractionEnabled = true

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    removeImageView.addGestureRecognizer(panGesture)

    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
    removeImageView.addGestureRecognizer(pinchGesture)

    overlayView.addSubview(removeImageView)
    return overlayView
}

@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    guard let view = gesture.view else { return }
    let translation = gesture.translation(in: view.superview)
    view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
    gesture.setTranslation(.zero, in: view.superview)
}

@objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
    guard let view = gesture.view else { return }
    view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
    gesture.scale = 1.0
}

```
</br>

 ### 5-2. 사진 촬영 및 스티커 포함 이미지 생성
  - 사진 촬영 시 오버레이된 스티커를 포함하여 이미지를 캡처합니다.</br>
  - 결과 이미지는 스티커가 사진 위에 배치된 형태로 사용자 갤러리에 저장됩니다.</br>
  
``` swift
@objc func shutterButtonTapped() {
    if let imagePickerController = self.presentedViewController as? UIImagePickerController {
        imagePickerController.takePicture()
    }
}

func takeSnapshotWithOverlayAndSave(capturedImage: UIImage, isFrontCamera: Bool) {
    var imageToSave = capturedImage
    if isFrontCamera {
        imageToSave = UIImage(cgImage: capturedImage.cgImage!, scale: capturedImage.scale, orientation: .leftMirrored)
    }

    UIGraphicsBeginImageContextWithOptions(imageToSave.size, false, imageToSave.scale)
    imageToSave.draw(in: CGRect(origin: .zero, size: imageToSave.size))

    if let overlayImage = motionCheckView.removeImageView.image {
        overlayImage.draw(in: CGRect(x: 100, y: 100, width: 200, height: 200))
    }

    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    if let combinedImage = combinedImage {
        UIImageWriteToSavedPhotosAlbum(combinedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
        print("Error saving image: \(error.localizedDescription)")
    } else {
        print("Image saved successfully")
    }
}

```
</br>

### 5-3. 커스텀 카메라 인터페이스
 - 기본 카메라 UI를 숨기고 커스텀 버튼(촬영, 전환, 취소)을 추가하여 사용자 경험을 향상시켰습니다.</br>
 - 카메라 화면은 정사각형 비율로 조정되어 스티커 사진 촬영에 적합합니다.</br>
 
 ``` swift
 func presentCameraWithOverlay() {
    let cameraVC = UIImagePickerController()
    cameraVC.delegate = self
    cameraVC.sourceType = .camera
    cameraVC.cameraOverlayView = createOverlayView()
    cameraVC.showsCameraControls = false

    let scale = UIScreen.main.bounds.width / UIScreen.main.bounds.width
    cameraVC.cameraViewTransform = CGAffineTransform(scaleX: scale, y: scale)

    present(cameraVC, animated: true, completion: nil)
}

```
 </br>

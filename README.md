# Piverlay

## Specification

### 사용언어: Swift
### Deployment Target: iOS 12.1
### 디자인패턴: MVP
### 3rd Party Library: SVGKit(url로 svg파일 가져오기 위해 사용)
 
## Optional

### 여러 해상도로 Export
- width, height를 사용자 input을 받아 여러 해상도로 Export 가능하도록 구현

### SVG리소스 번들 이외의 저장소에서 읽어 올수 있는 방법
- AWS S3에 해당이미지를 업로드 하여 url로 가져와 collectionView에 데이터를 보여주는 방법 사용
- https://mysvgimage.s3.ap-northeast-2.amazonaws.com/001.svg
- 리소스 번들 방법으로도 구현

### TDD
- UITest를 사용하여 User Scenario 테스트 구현(PiverlayUITests)

## 스크린캡처
 
 <img src="https://screenshotwc.s3.ap-northeast-2.amazonaws.com/IMG_2392.PNG" alt="drawing" width="200"/> 
 <img src="https://screenshotwc.s3.ap-northeast-2.amazonaws.com/IMG_2387.PNG" alt="drawing" width="200"/> 
    <img src="https://screenshotwc.s3.ap-northeast-2.amazonaws.com/IMG_2388.PNG" alt="drawing" width="200"/> 
    <img src="https://screenshotwc.s3.ap-northeast-2.amazonaws.com/IMG_2389.PNG" alt="drawing" width="200"/> 
    

## pf) Signing 정보
- Xcode 계정: fornew21c@gmail.com
- 비밀번호: Uib50s8a1!

![](https://screenshotwc.s3.ap-northeast-2.amazonaws.com/codeSigning.png)
      
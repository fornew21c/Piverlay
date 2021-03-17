//
//  ResizeInputView.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/09.
//

import UIKit

// 이미지 해상도 변경하는 뷰
class ResizeInputView: UIView {

    @IBOutlet weak var inputValueView: UIView!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var outsideButton: UIButton!
    
    var tap : UITapGestureRecognizer?
    var beforeImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TextField layer 세팅
        widthTextField.layer.cornerRadius = 17.5
        widthTextField.layer.borderWidth = 1
        heightTextField.layer.cornerRadius = 17.5
        heightTextField.layer.borderWidth = 1
        
        widthTextField.delegate = self
        heightTextField.delegate = self
        
        inputValueView.layer.masksToBounds = false
        inputValueView.layer.borderColor = UIColor.white.cgColor
        inputValueView.layer.shadowOffset = CGSize(width: 0, height: 12)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    // InputValueView 외부 터치
    @IBAction func touchOutside(_ sender: UIButton) {
        //뷰 제거
        removeFromSuperview()
    }
    
    //OK 버튼 터치
    @IBAction func OKButtonTouched(_ sender: UIButton) {
        if widthTextField.text == "" || heightTextField.text == "" {
            PLUtil.showToastBlackBottomWith(message: "Please input Value!", bottomHeight: 60)
            return
        }
        if let width = widthTextField?.text, let height = heightTextField?.text {
            // 이미지 해상도 변경
            let resizedImage = resizeImage(image: beforeImage, targetSize: CGSize(width: Int(width)!, height: Int(height)!))
            UIImageWriteToSavedPhotosAlbum(resizedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        //화면에서 뷰제거
        removeFromSuperview()
        
        //키보드 제거
        dismissKeyboard()
    }
    
    //이미지 저장 후 처리
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            PLUtil.showToastBlackWith(message: "Resized Photo Save Error! " + error.localizedDescription)
        } else {
            if let width = widthTextField?.text, let height = heightTextField?.text {
                PLUtil.showToastBlackWith(message: width + "*" + height + " Resized Photo Save Done!")
            }
        }
    }
    
    //image 사이즈 조절 함수
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        // 새롭게 변경될 사이즈
        var newSize: CGSize
        if(widthRatio > heightRatio){
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio) }
        else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // 새로운 사이즈의 rect
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // 리사이징 작업
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        // 리사이징한 이미지
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

// MARK: - UITextFieldDelegate
extension ResizeInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        outsideButton.isUserInteractionEnabled = false
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        outsideButton.isUserInteractionEnabled = true
        if textField == widthTextField {
            widthTextField.resignFirstResponder()
            heightTextField.becomeFirstResponder()
        }
        else {
            heightTextField.resignFirstResponder()
        }
        removeGestureRecognizer(tap!)
        return true
    }
    
    //키보드 dismiss
    @objc func dismissKeyboard() {
        outsideButton.isUserInteractionEnabled = true
        widthTextField.resignFirstResponder()
        heightTextField.resignFirstResponder()
        
        if let tap = tap {
            removeGestureRecognizer(tap)
        }
    }
}

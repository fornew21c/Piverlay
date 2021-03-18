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
    
    private let photoOverlayPresenter = PhotoOverlayPresenter(photoOverlayService: PhotoOverlayService())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TextField layer 세팅
        widthTextField.layer.cornerRadius = 17.5
        widthTextField.layer.borderWidth = 1
        widthTextField.setLeftPaddingPoints(10)
        
        heightTextField.layer.cornerRadius = 17.5
        heightTextField.layer.borderWidth = 1
        heightTextField.setLeftPaddingPoints(10)
        
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
            PLUtil.showToastBlackBottomWith(message: "Please input Value!", bottomHeight: 250)
            return
        }
        if let width = widthTextField?.text, let height = heightTextField?.text {
            // 이미지 해상도 변경
            let resizedImage = photoOverlayPresenter.resizeImage(image: beforeImage, targetSize: CGSize(width: Int(width)!, height: Int(height)!))
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

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

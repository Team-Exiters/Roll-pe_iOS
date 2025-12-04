//
//  TextView.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/2/25.
//

import UIKit
import SnapKit

class BaseTextView: UITextView, UITextViewDelegate {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // 글자 수 제한
    var maxLength = 50 {
        didSet {
            self.delegate = self
        }
    }
    
    private func setup() {
        self.delegate = self
        
        // 입력 설정
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
    }
    
    // 글자 수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxLength
    }
}

class VerticallyCenteredTextView: BaseTextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}

class HeartTextView: VerticallyCenteredTextView {
    private let placeholderLabel: UILabel = UILabel()
    
    var placeholder: String? {
        didSet {
            self.delegate = self
            setupPlaceholder()
        }
    }
    
    var placeholderColor: UIColor = .rollpeGray {
        didSet {
            self.delegate = self
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    override var text: String? {
        didSet {
            self.delegate = self
            if text != nil && !text!.isEmpty {
                placeholderLabel.removeFromSuperview()
            }
        }
    }
    
    private func setupPlaceholder() {
        if text == nil || text!.isEmpty {
            placeholderLabel.text = placeholder
            placeholderLabel.font = self.font
            placeholderLabel.textAlignment = self.textAlignment
            placeholderLabel.numberOfLines = 0
            placeholderLabel.isUserInteractionEnabled = false
            
            self.addSubview(placeholderLabel)
            
            placeholderLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.textContainerInset.top)
            }
        }
    }
    
    // placeholder 설정
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.removeFromSuperview()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    // 글자 수 제한 + 줄바꿈 제한
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxLength && !text.contains("\n")
    }
}

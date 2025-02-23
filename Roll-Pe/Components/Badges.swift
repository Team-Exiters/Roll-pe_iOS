//
//  Badges.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/27/25.
//

import UIKit

// d-day
class BadgeDDay: UILabel {
    private let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        if let font = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 12) {
            self.font = font
        }
        else{
            self.font = UIFont.systemFont(ofSize: 12)
        }
        self.textColor = .rollpePrimary
        self.textAlignment = .center
        self.backgroundColor = .rollpeMain
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right

        return contentSize
    }
}

// 공개
class BadgePublic: UILabel {
    private let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 12)
        self.textColor = .rollpeMain
        self.textAlignment = .center
        self.backgroundColor = .rollpeWhite
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.rollpeMain.cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.text = "공개"
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right

        return contentSize
    }
}

// 비공개
class BadgePrivate: UILabel {
    private let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 12)
        self.textColor = .rollpeGray
        self.textAlignment = .center
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.text = "비공개"
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right

        return contentSize
    }
}

//
//  RollpeListItem.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/27/25.
//

import UIKit


func RollpeListItem(_ model: RollpeListItemModel) -> UIStackView {
    let view: UIStackView = UIStackView()
    view.axis = .vertical
    view.spacing = 12
    view.alignment = .leading
    
    // MARK: - 상태
    
    let statusesView: UIStackView = UIStackView()
    statusesView.axis = .horizontal
    statusesView.spacing = 4
    statusesView.alignment = .center
    
    view.addArrangedSubview(statusesView)
    
    // 공개 야부
    let privacy: UILabel = model.isPublic ? BadgePublic() : BadgePrivate()
    
    statusesView.addArrangedSubview(privacy)
    
    // d-day
    let dday = BadgeDDay()
    dday.text = dateToDDay(model.receiverDate)
    
    statusesView.addArrangedSubview(dday)
    
    
    // MARK: - 정보
    
    let contentView: UIStackView = UIStackView()
    contentView.axis = .horizontal
    contentView.spacing = 12
    contentView.alignment = .center
    
    view.addArrangedSubview(contentView)
    
    // 테마
    let theme: UIView = {
        switch model.theme {
        case "화이트":
            return themeWhite()
        case "블랙":
            return themeBlack()
        case "생일":
            return themeBirthday()
        default:
            return themeWhite()
        }
    }()
    
    contentView.addArrangedSubview(theme)
    
    // 정보
    let infoView: UIStackView = UIStackView()
    infoView.axis = .vertical
    infoView.spacing = 8
    infoView.alignment = .leading
    infoView.clipsToBounds = true
    
    contentView.addArrangedSubview(infoView)
    
    // 제목
    let title: UILabel = UILabel()
    title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
    title.textColor = .rollpeSecondary
    title.textAlignment = .left
    title.text = model.title
    title.numberOfLines = 0
    title.lineBreakMode = .byTruncatingTail
    
    infoView.addArrangedSubview(title)
    
    // 내용
    let description: UILabel = UILabel()
    description.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
    description.textColor = .rollpeGray
    description.textAlignment = .left
    description.text = "\(model.createdUser) 주최 | \(dateToYYYYMD(model.createdAt)) 생성"
    
    infoView.addArrangedSubview(description)
    
    return view
}

/*
class RollpeListItem: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let statusesView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        
        return sv
    }()
    
    private let dday = BadgeDDay()
    
    private let contentView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        
        return sv
    }()
    
    private let infoView: UIStackView = {
        let sv: UIStackView = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.clipsToBounds = true
        
        return sv
    }()
    
    private let title: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private let desc: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textColor = .rollpeGray
        label.textAlignment = .left
        
        return label
    }()
    
    private func setup() {
        self.axis = .vertical
        self.spacing = 12
        self.alignment = .leading
    }
    
    func configure(model: RollpeDataModel) {
        self.addArrangedSubview(statusesView)
        statusesView.addArrangedSubview(model.viewStat ? BadgePublic() : BadgePrivate())
        
        dday.text = dateToDDay(convertYYYYMMddToDate(model.receivingDate))
        statusesView.addArrangedSubview(dday)
        
        self.addArrangedSubview(contentView)
        
        switch model.theme {
        case "화이트": contentView.addArrangedSubview(themeWhite())
        case "블랙": contentView.addArrangedSubview(themeBlack())
        case "생일": contentView.addArrangedSubview(themeBirthday())
        default: contentView.addArrangedSubview(themeWhite())
        }
        
        contentView.addArrangedSubview(infoView)
        
        title.text = model.title
        infoView.addArrangedSubview(title)
 
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
         
        desc.text = "\(model.host.name) 주최 | \(dateToYYYYMd(dateFormatter.date(from: model.createdAt)!)) 생성"
        infoView.addArrangedSubview(desc)
    }
}
 */

class RollpeSearchListItem: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // 정보
    private let infoView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        
        return sv
    }()
    
    // 상단 뷰
    private let topStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.clipsToBounds = true
        
        return sv
    }()
    
    // d-day
    private let dday = BadgeDDay()
    
    // 제목
    private let title = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    // 내용
    private let desc = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textColor = .rollpeGray
        label.textAlignment = .left
        
        return label
    }()
    
    private func setup() {
        self.axis = .horizontal
        self.spacing = 12
        self.alignment = .center
    }
    
    func configure(model: RollpeDataModel) {
        switch model.theme {
        case "화이트": self.addArrangedSubview(themeWhite())
        case "블랙": self.addArrangedSubview(themeBlack())
        case "생일": self.addArrangedSubview(themeBirthday())
        default: self.addArrangedSubview(themeWhite())
        }
        
        self.addArrangedSubview(infoView)
        
        dday.text = dateToDDay(convertYYYYMMddToDate(model.receivingDate))
        topStackView.addArrangedSubview(dday)
        
        title.text = model.title
        topStackView.addArrangedSubview(title)
        infoView.addArrangedSubview(topStackView)
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        desc.text = "\(model.host.name) 주최 | \(dateToYYYYMd(dateFormatter.date(from: model.createdAt)!)) 생성"
        infoView.addArrangedSubview(desc)
    }
}

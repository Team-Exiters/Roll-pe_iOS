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

func RollpeSearchListItem(_ model: RollpeSearchListItemModel) -> UIStackView {
    let view: UIStackView = UIStackView()
    view.axis = .horizontal
    view.spacing = 12
    view.alignment = .center
    
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
    
    view.addArrangedSubview(theme)
    
    // 정보
    let infoView: UIStackView = UIStackView()
    infoView.axis = .vertical
    infoView.spacing = 8
    infoView.alignment = .leading
    
    view.addArrangedSubview(infoView)
    
    // 상단 뷰
    let topStackView: UIStackView = UIStackView()
    topStackView.axis = .horizontal
    topStackView.spacing = 8
    topStackView.alignment = .center
    topStackView.clipsToBounds = true
    
    // d-day
    let dday = BadgeDDay()
    dday.text = dateToDDay(model.receiverDate)
    
    topStackView.addArrangedSubview(dday)
    
    // 제목
    let title: UILabel = UILabel()
    title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
    title.textColor = .rollpeSecondary
    title.textAlignment = .left
    title.text = model.title
    title.numberOfLines = 0
    title.lineBreakMode = .byTruncatingTail
    
    topStackView.addArrangedSubview(title)
    infoView.addArrangedSubview(topStackView)
    
    // 내용
    let description: UILabel = UILabel()
    description.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
    description.textColor = .rollpeGray
    description.textAlignment = .left
    description.text = "\(model.createdUser) 주최 | \(dateToYYYYMD(model.createdAt)) 생성"
    
    infoView.addArrangedSubview(description)
    
    return view
}

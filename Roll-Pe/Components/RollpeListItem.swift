//
//  RollpeListItem.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/27/25.
//

import UIKit
import SnapKit

class RollpeListItem: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // 공개 여부
    private var viewStatView: UIView = UIView()
    
    // 테마
    private var themeView: UIView = themeWhite()
    
    // 상태
    private let statusesView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        
        return sv
    }()
    
    // D-day
    private let dday = BadgeDDay()
    
    // 테마와 제목, 설명
    private let contentView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        
        return sv
    }()
    
    // 정보
    private let infoView: UIStackView = {
        let sv: UIStackView = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.clipsToBounds = true
        
        return sv
    }()
    
    // 제목
    private let title: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    // 설명
    private let desc: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textColor = .rollpeGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private func setup() {
        self.axis = .vertical
        self.spacing = 12
        self.alignment = .leading
        
        self.addArrangedSubview(statusesView)
        statusesView.addArrangedSubview(dday)
        
        self.addArrangedSubview(contentView)
        
        contentView.addArrangedSubview(themeView)
        
        contentView.addArrangedSubview(infoView)
        infoView.addArrangedSubview(title)
        infoView.addArrangedSubview(desc)
    }
    
    func configure(model: RollpeListDataModel) {
        // 공개 여부
        self.removeArrangedSubview(viewStatView)
        viewStatView.removeFromSuperview()
        
        viewStatView = model.viewStat ? BadgePublic() : BadgePrivate()
        statusesView.insertArrangedSubview(viewStatView, at: 0)
        
        // D-day
        dday.text = dateToDDay(stringToDate(string: model.receive.receivingDate, format: "yyyy-MM-dd")) 
        
        // 테마
        contentView.removeArrangedSubview(themeView)
        contentView.removeArrangedSubview(infoView)
        
        themeView = {
            switch model.theme {
            case "화이트": return themeWhite()
            case "추모": return themeMemorial()
            case "축하": return themeCongrats()
            default: return themeWhite()
            }
        }()
        
        contentView.addArrangedSubview(themeView)
        contentView.addArrangedSubview(infoView)
        
        // 제목
        title.text = model.title
        
        // 설명
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
         
        desc.text = "\(model.host.name) 주최 | \(dateToString(date: dateFormatter.date(from: model.createdAt)!, format: "yyyy.M.d")) 생성"
    }
}

class RollpeSearchListItem: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // 테마
    private var themeView: UIView = UIView()
    
    // 정보
    private let infoView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        
        return sv
    }()
    
    // 상단 뷰
    private let topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.clipsToBounds = true
        
        return sv
    }()
    
    // D-day
    private let dday = BadgeDDay()
    
    // 제목
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    // 내용
    private let desc: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textColor = .rollpeGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private func setup() {
        self.axis = .horizontal
        self.spacing = 12
        self.alignment = .center
        
        self.addArrangedSubview(infoView)
        
        topStackView.addArrangedSubview(dday)
        topStackView.addArrangedSubview(title)
        infoView.addArrangedSubview(topStackView)
        infoView.addArrangedSubview(desc)
    }
    
    
    func configure(model: RollpeListDataModel) {
        // 테마
        self.removeArrangedSubview(themeView)
        themeView.removeFromSuperview()
        
        themeView = {
            switch model.theme {
            case "화이트": return themeWhite()
            case "추모": return themeMemorial()
            case "축하": return themeCongrats()
            default: return themeWhite()
            }
        }()
        
        self.insertArrangedSubview(themeView, at: 0)
        
        // D-day
        dday.text = dateToDDay(stringToDate(string: model.receive.receivingDate, format: "yyyy-MM-dd"))
        
        // 제목
        title.text = model.title
        
        // 설명
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        desc.text = "\(model.host.name) 주최 | \(dateToString(date: dateFormatter.date(from: model.createdAt)!, format: "yyyy.M.d")) 생성"
    }
}

// table view cell
class RollpeListTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let rollpeListItem = RollpeListItem()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .rollpeGray
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(rollpeListItem)
    }
    
    func configure(model: RollpeListDataModel, isLast: Bool) {
        rollpeListItem.configure(model: model)
        separatorView.removeFromSuperview()
        
        if isLast {
            rollpeListItem.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(24)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(24)
            }
            
        } else {
            rollpeListItem.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(24)
                make.horizontalEdges.equalToSuperview()
            }
            
            contentView.addSubview(separatorView)
            
            separatorView.snp.remakeConstraints { make in
                make.top.equalTo(rollpeListItem.snp.bottom).offset(24)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().priority(.low)
                make.height.equalTo(2)
            }
        }
    }
}

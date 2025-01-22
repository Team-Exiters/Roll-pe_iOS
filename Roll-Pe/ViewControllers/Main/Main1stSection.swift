//
//  MainTopSection.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/20/25.
//

import UIKit
import SnapKit

class MainTopSecionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - 배경 이미지
        let background: UIImageView = UIImageView()
        background.image = UIImage(named: "MainBackground")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        background.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        // MARK: - 중앙 요소
        let centerView: UIStackView = UIStackView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.axis = .vertical
        centerView.spacing = 0
        centerView.alignment = .center
        
        self.addSubview(centerView)
        
        centerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        // 로고
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage(named: "Logo")
        logo.image = logoImage
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        centerView.addArrangedSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.427)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage!))
        }
        
        centerView.setCustomSpacing(20, after: logo)
        
        // 제목
        let title: UILabel = UILabel()
        title.textColor = .rollpeSecondary
        title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        title.numberOfLines = 2
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineHeightMultiple = 0.98
        titleParagraphStyle.alignment = .center
        title.attributedText = NSMutableAttributedString(string: "다같이 한 마음으로\n사랑하는 사람에게 전달해보세요", attributes: [.paragraphStyle: titleParagraphStyle])
        
        centerView.addArrangedSubview(title)
        centerView.setCustomSpacing(60, after: title)
        
        // 버튼
        let button: RollpeButtonPrimary = RollpeButtonPrimary(title: "롤페 시작하기")
        
        centerView.addArrangedSubview(button)
        
        button.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // MARK: - 하단 요소
        let bottomView: UIStackView = UIStackView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.axis = .vertical
        bottomView.spacing = 4
        bottomView.alignment = .center
        
        self.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
        
        // 아래쪽 화살표
        let arrowDown: UIImageView = UIImageView()
        let arrowDownImage: UIImage! = UIImage(named: "icon_arrow_down_thin")
        arrowDown.image = arrowDownImage
        arrowDown.translatesAutoresizingMaskIntoConstraints = false
        arrowDown.contentMode = .scaleAspectFit
        arrowDown.clipsToBounds = true
        arrowDown.tintColor = .rollpeGray
        
        bottomView.addArrangedSubview(arrowDown)
        
        arrowDown.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(arrowDown.snp.width).dividedBy(getImageRatio(image: arrowDownImage!))
        }
        
        // 스크롤 안내 텍스트
        let tryToScroll: UILabel = UILabel()
        tryToScroll.textColor = .rollpeGray
        tryToScroll.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 15)
        tryToScroll.numberOfLines = 0
        tryToScroll.textAlignment = .center
        tryToScroll.text = "아래로 스크롤 해보아요!"
        
        bottomView.addArrangedSubview(tryToScroll)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

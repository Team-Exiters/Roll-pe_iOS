//
//  RollpeCreateViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftUI

class RollpeCreateViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    
    // 주제 텍스트
    private func LabelSubject() -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        
        return label
    }
    
    // 설명 텍스트
    private func LabelDesc() -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 12)
        label.textColor = .rollpeSecondary
        
        return label
    }
    
    // 테마 미리보기
    private func ThemePreview() -> UIView {
        let view: UIView = UIView()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        view.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        return view
    }
    
    // 테마 라벨
    private func ThemeLabel() -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textColor = .rollpeSecondary
        
        return label
    }
    
    // 날짜 선택
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        
        var components = DateComponents()
        // 최소일
        components.day = 1
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        // 최대일
        components.day = 30
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())

        picker.maximumDate = maxDate
        picker.minimumDate = minDate
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .rollpePrimary
        
        // Spacer
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // MARK: - 내부 뷰
        
        let scrollView: UIScrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeareaTop)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        let contentView: UIView = UIView()
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.width.equalToSuperview()
        }
        
        let pageTitle = UILabel()
        pageTitle.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32)
        pageTitle.textColor = .rollpeSecondary
        pageTitle.text = "롤페 만들기"
        
        contentView.addSubview(pageTitle)
        
        pageTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(88)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - 제목
        
        let subjectTitle: UILabel = LabelSubject()
        subjectTitle.text = "제목을 입력하세요"
        
        contentView.addSubview(subjectTitle)
        
        subjectTitle.snp.makeConstraints { make in
            make.top.equalTo(pageTitle.snp.bottom).offset(52)
            make.leading.equalToSuperview().inset(20)
        }
        
        let textFieldTitle = TextField()
        textFieldTitle.placeholder = ""
        
        contentView.addSubview(textFieldTitle)
        
        textFieldTitle.snp.makeConstraints { make in
            make.top.equalTo(subjectTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // MARK: - 비율 선택
        
        let subjectRatios: UILabel = LabelSubject()
        subjectRatios.text = "비율을 선택하세요"
        
        contentView.addSubview(subjectRatios)
        
        subjectRatios.snp.makeConstraints { make in
            make.top.equalTo(textFieldTitle.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        let scrollRatios: UIScrollView = UIScrollView()
        
        let listRatios: UIStackView = UIStackView()
        listRatios.axis = .horizontal
        listRatios.spacing = 20
        
        contentView.addSubview(scrollRatios)
        scrollRatios.addSubview(listRatios)
        
        listRatios.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview()
        }
        
        scrollRatios.snp.makeConstraints { make in
            make.top.equalTo(subjectRatios.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 가로
        let paperHorizontal = RollpeRatioBlock()
        paperHorizontal.image = "img_paper_horizontal"
        paperHorizontal.text = "가로"
        paperHorizontal.isSelected = true
        
        listRatios.addArrangedSubview(paperHorizontal)
        
        // 세로
        let paperVertical = RollpeRatioBlock()
        paperVertical.image = "img_paper_vertical"
        paperVertical.text = "세로"
        
        listRatios.addArrangedSubview(paperVertical)
        
        // 정방형
        let paperSquare = RollpeRatioBlock()
        paperSquare.image = "img_paper_square"
        paperSquare.text = "정방형"
        
        listRatios.addArrangedSubview(paperSquare)
        
        // MARK: - 테마
        
        let subjectThemes: UILabel = LabelSubject()
        subjectThemes.text = "테마를 선택하세요"
        
        contentView.addSubview(subjectThemes)
        
        subjectThemes.snp.makeConstraints { make in
            make.top.equalTo(scrollRatios.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        let scrollThemes: UIScrollView = UIScrollView()
        let listThemes: UIStackView = UIStackView()
        listThemes.axis = .horizontal
        listThemes.spacing = 20
        
        contentView.addSubview(scrollThemes)
        scrollThemes.addSubview(listThemes)
        
        listThemes.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalToSuperview()
        }
        
        scrollThemes.snp.makeConstraints { make in
            make.top.equalTo(subjectThemes.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 화이트
        let whiteThemeBlock = RollpeThemeBlock()
        let whiteThemePreview = ThemePreview()
        whiteThemePreview.backgroundColor = .rollpeWhite
        whiteThemePreview.layer.borderColor = UIColor.rollpeBlack.cgColor
        whiteThemePreview.layer.borderWidth = 2
        let whiteLabel = ThemeLabel()
        whiteLabel.text = "화이트"
        
        whiteThemeBlock.view = whiteThemePreview
        whiteThemeBlock.label = whiteLabel
        whiteThemeBlock.isSelected = true
        
        listThemes.addArrangedSubview(whiteThemeBlock)
        
        // 블랙
        let blackThemeBlock = RollpeThemeBlock()
        let blackThemePreview = ThemePreview()
        blackThemePreview.backgroundColor = .rollpeBlack
        let blackLabel = ThemeLabel()
        blackLabel.text = "블랙"
        
        blackThemeBlock.view = blackThemePreview
        blackThemeBlock.label = blackLabel
        
        listThemes.addArrangedSubview(blackThemeBlock)
        
        // 생일
        let birthdayThemeBlock = RollpeThemeBlock()
        let birthdayThemePreview = ThemePreview()
        birthdayThemePreview.backgroundColor = .rollpePink
        let birthdayIcon: UIImageView = UIImageView()
        let birthdayIconImage: UIImage = .iconBirthdayCake
        
        birthdayIcon.image = birthdayIconImage
        birthdayIcon.contentMode = .scaleAspectFit
        birthdayThemePreview.addSubview(birthdayIcon)
        
        birthdayIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.575)
            make.height.equalTo(birthdayIcon.snp.width).dividedBy(getImageRatio(image: birthdayIconImage))
        }
        
        let birthdayLabel = ThemeLabel()
        birthdayLabel.text = "생일"
        
        birthdayThemeBlock.view = birthdayThemePreview
        birthdayThemeBlock.label = birthdayLabel
        birthdayThemeBlock.isSelected = false
        
        listThemes.addArrangedSubview(birthdayThemeBlock)
        
        // MARK: - 크기
        
        let subjectSizes: UILabel = LabelSubject()
        subjectSizes.text = "크기를 선택하세요"
        
        contentView.addSubview(subjectSizes)
        
        subjectSizes.snp.makeConstraints { make in
            make.top.equalTo(scrollThemes.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        let scrollSizes: UIScrollView = UIScrollView()
        let listSizes: UIStackView = UIStackView()
        listSizes.axis = .horizontal
        listSizes.spacing = 20
        
        contentView.addSubview(scrollSizes)
        scrollSizes.addSubview(listSizes)
        
        listSizes.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalToSuperview()
        }
        
        scrollSizes.snp.makeConstraints { make in
            make.top.equalTo(subjectSizes.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        // A4
        let a4SizeBlock = RollpeSizeBlock()
        a4SizeBlock.size = "A4"
        a4SizeBlock.maximum = 13
        a4SizeBlock.isSelected = true
        
        listSizes.addArrangedSubview(a4SizeBlock)
        
        // MARK: - 공개 설정 여부
        
        let subjectPrivate: UILabel = LabelSubject()
        subjectPrivate.text = "공개 설정 여부"
        
        contentView.addSubview(subjectPrivate)
        
        subjectPrivate.snp.makeConstraints { make in
            make.top.equalTo(scrollSizes.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        let descPrivate = LabelDesc()
        descPrivate.text = "링크를 가진 모든 분들이 볼 수 있어요."
        
        contentView.addSubview(descPrivate)
        
        descPrivate.snp.makeConstraints { make in
            make.top.equalTo(subjectPrivate.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        // 공개 설정
        let controlPrivate = SegmentControl(items: ["공개", "비공개"])
        controlPrivate.control.selectedSegmentIndex = 1
        
        contentView.addSubview(controlPrivate)
        
        controlPrivate.snp.makeConstraints { make in
            make.top.equalTo(descPrivate.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 비밀번호
        let password = TextField()
        password.placeholder = "비밀번호"
        
        contentView.addSubview(password)
        
        password.snp.makeConstraints { make in
            make.top.equalTo(controlPrivate.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // MARK: - 종료 시간
        
        let subjectTimeLimit: UILabel = LabelSubject()
        subjectTimeLimit.text = "종료 시간을 지정해주세요"
        
        contentView.addSubview(subjectTimeLimit)
        
        subjectTimeLimit.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 종료일 선택
        let textFieldDate = TextFieldForPicker()
        textFieldDate.text = dateToYYYYMdahhmm(datePicker.minimumDate!)
        textFieldDate.inputView = datePicker
        
        contentView.addSubview(textFieldDate)
        
        textFieldDate.snp.makeConstraints { make in
            make.top.equalTo(subjectTimeLimit.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        datePicker.rx.date
            .subscribe(onNext: { date in
                textFieldDate.text = dateToYYYYMdahhmm(date)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 미리보기
        
        let subjectPreview: UILabel = LabelSubject()
        subjectPreview.text = "종료일을 지정해주세요"
        
        contentView.addSubview(subjectPreview)
        
        subjectPreview.snp.makeConstraints { make in
            make.top.equalTo(textFieldDate.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        let descPreview = LabelDesc()
        descPreview.text = "최대 \(13)명까지 작성할 수 있어요."
        
        contentView.addSubview(descPreview)
        
        descPreview.snp.makeConstraints { make in
            make.top.equalTo(subjectPreview.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        let imageViewPreview = UIImageView()
        let imagePreview: UIImage = .imgPreviewWhiteHorizontal
        imageViewPreview.image = imagePreview
        imageViewPreview.contentMode = .scaleAspectFit
        imageViewPreview.clipsToBounds = true
        
        contentView.addSubview(imageViewPreview)
        
        imageViewPreview.snp.makeConstraints { make in
            make.top.equalTo(descPreview.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(imageViewPreview.snp.width).dividedBy(getImageRatio(image: imagePreview))
        }
        
        // MARK: - 만들기
        
        let buttonCreate = PrimaryButton(title: "만들기")
        
        contentView.addSubview(buttonCreate)
        
        buttonCreate.snp.makeConstraints { make in
            make.top.equalTo(imageViewPreview.snp.bottom).offset(52)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        buttonCreate.rx.tap
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        // MARK: - 네비게이션 바
        
        let navigationBar = NavigationBar()
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeareaTop)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

struct RollCreateViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeCreateViewController()
        }
    }
}

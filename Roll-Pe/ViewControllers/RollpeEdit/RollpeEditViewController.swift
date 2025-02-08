//
//  RollpeEditViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/4/25.
//

import UIKit
import SwiftUI
import RxSwift

class RollpeEditViewController: UIViewController {
    
    var rollpeHostViewModel : RollpeHostViewModel
    
    init(rollpeHostViewModel: RollpeHostViewModel) {
        self.rollpeHostViewModel = rollpeHostViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)에러")
    }
    
    private lazy var editView = EditView(rollpeHostViewModel: rollpeHostViewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpeGray
        setupContentView()
    }
    
    private func setupContentView(){
        view.addSubview(editView)
        editView.layer.cornerRadius = 16
        editView.layer.masksToBounds = true
        editView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(128)
            make.bottom.equalToSuperview().offset(-128)
        }
    }
}

struct RollpeEditViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeEditViewController(rollpeHostViewModel: RollpeHostViewModel())
        }
    }
}

class EditView : UIView {
    
    private let disposeBag = DisposeBag()
    
    var rollpeHostViewModel : RollpeHostViewModel
    
    private var rollpeData : RollpeHostModel? = nil
    
    init(rollpeHostViewModel: RollpeHostViewModel) {
        self.rollpeHostViewModel = rollpeHostViewModel
        super.init(frame: .zero)
        bindViewModel()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:)에러")
    }
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        if let originalImage = UIImage(named: "icon_x") {
            let resizedImage = originalImage.resized(to: CGSize(width: 20, height: 20))
            button.setImage(resizedImage, for: .normal)
        }
        button.tintColor = .rollpeSecondary
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        }
        return label
    }()
    
    private let publicSettingLabel : UILabel = {
        let label = UILabel()
        label.text = "공개 설정"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        return label
    }()
    
    private let segmentControl = SegmentControl(items: ["공개","비공개"])
    
    private func setupUI(){
        backgroundColor = .rollpePrimary
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(publicSettingLabel)
        addSubview(segmentControl)
        
        backButton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        publicSettingLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(backButton.snp.bottom).offset(32)
        }
        segmentControl.snp.makeConstraints{ make in
            make.top.equalTo(publicSettingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func bindViewModel() {
        rollpeHostViewModel.rollpeHostModel
            .compactMap { $0 } // nil 값 제거
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.rollpeData = model
            })
            .disposed(by: disposeBag)
    }

}

extension UIImage {
    /// 지정한 크기로 이미지를 리사이즈하여 새로운 UIImage 반환
    func resized(to size: CGSize) -> UIImage? {
        // 1) 비트맵 그래픽 컨텍스트 생성
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // 2) 현재 이미지를 해당 size 영역에 맞춰 그리기
        self.draw(in: CGRect(origin: .zero, size: size))
        
        // 3) 새로 만들어진 이미지를 컨텍스트에서 꺼내오기
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4) 컨텍스트 종료
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


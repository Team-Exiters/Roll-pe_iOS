//
//  SegmentControl.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SegmentControl: UIView {
    private let disposeBag = DisposeBag()
    
    let items: [String]
    
    init(frame: CGRect = .zero, items: [String]) {
        self.items = items
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let selectedSegment: UIView = {
        let view: UIView = UIView()
        view.layer.backgroundColor = UIColor.rollpePrimary.cgColor
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    lazy var control: UISegmentedControl = {
        let control = UISegmentedControl(items: self.items)
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .clear
        control.backgroundColor = .clear
        
        let font: UIFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) ?? UIFont.systemFont(ofSize: 16)
        control.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.rollpeSecondary], for: .normal)
        
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        return control
    }()
    
    private func setup() {
        // 뷰 디자인 설정
        self.backgroundColor = UIColor(red: 0.945, green: 0.945, blue: 0.945, alpha: 1)
        self.layer.cornerRadius = 16
        
        self.addSubview(selectedSegment)
        
        self.addSubview(control)
        
        control.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.edges.equalToSuperview().inset(8)
        }
        
        selectedSegment.snp.makeConstraints { make in
            make.verticalEdges.equalTo(control.snp.verticalEdges)
            make.leading.equalTo(control.snp.leading)
            make.width.equalTo(control.snp.width).dividedBy(items.count)
            make.height.equalTo(40)
        }
        
        // 세그먼트 index 변화에 따른 동작
        control.rx.selectedSegmentIndex
            .subscribe(onNext: { index in
                self.changeSegmentedControlLinePosition(index: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func changeSegmentedControlLinePosition(index: Int) {
        UIView.animate(withDuration: 0.25, animations: {
            let segmentWidth = self.control.frame.width / CGFloat(self.items.count)
            
            self.selectedSegment.snp.updateConstraints { make in
                make.leading.equalTo(self.control.snp.leading).offset(segmentWidth * CGFloat(index))
            }
            self.layoutIfNeeded()
        })
    }
}

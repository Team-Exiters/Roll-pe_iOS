//
//  BaseRollpeV1ViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 6/18/25.
//

import UIKit
import RxSwift

class BaseRollpeV1ViewController: UIViewController {
    public let disposeBag = DisposeBag()
    public let rollpeV1ViewModel = RollpeV1ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .rollpePrimary
        bindRollpeViewModel()
    }
    
    private func bindRollpeViewModel() {
        let output = rollpeV1ViewModel.transform()
        
        output.needEnter
            .emit(onNext: { needEnter in
                if let needEnter = needEnter,
                   let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel {
                    if needEnter {
                        if rollpeDataModel.viewStat { // 공개
                            self.confirmEnterRollpe()
                        } else { // 비공개
                            self.showPasswordTextFieldAlert()
                        }
                    } else {
                        self.navigationController?.pushViewController(RollpeV1DetailViewController(pCode: rollpeDataModel.code), animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.isEnterSuccess
            .emit(onNext: { isEnterSuccess in
                if let isEnterSuccess = isEnterSuccess,
                   let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel {
                    if isEnterSuccess {
                        self.navigationController?.pushViewController(RollpeV1DetailViewController(pCode: rollpeDataModel.code), animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 입장 확인
    private func confirmEnterRollpe() {
        guard let rollpeDataModel = rollpeV1ViewModel.selectedRollpeDataModel else {
            return
        }
        
        self.showConfirmAlert(title: "알림", message: "\(rollpeDataModel.title) 롤페에 입장하시겠습니까?")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.rollpeV1ViewModel.enterRollpe(pCode: rollpeDataModel.code)
            })
            .disposed(by: disposeBag)
    }
    
    // 비밀번호를 통한 입장
    private func showPasswordTextFieldAlert() {
        let alertController = UIAlertController(title: "롤페 입장하기", message: "비밀번호를 입력하세요", preferredStyle: .alert)
        
        alertController.addTextField { field in
            
        }
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            if let textField = alertController.textFields?.first,
               let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel {
                self.rollpeV1ViewModel.enterRollpe(pCode: rollpeDataModel.code, password: textField.text)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

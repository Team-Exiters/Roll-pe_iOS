//
//  DeleteHeartViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

class DeleteHeartViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    let successAlertMessage = PublishSubject<String?>()
    let errorAlertMessage = PublishSubject<String?>()
    
    struct Output {
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 마음 삭제
    func deleteHeart(hCode: String) {
        apiService.requestDecodable("/api/heart?hcode=\(hCode)", method: .delete, decodeType: ResponseNoDataModel.self)
            .subscribe(onNext: { model in
                self.successAlertMessage.onNext(model.message)
            }, onError: { error in
                print("마음 삭제 중 오류 발생: \(error)")
                self.errorAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}

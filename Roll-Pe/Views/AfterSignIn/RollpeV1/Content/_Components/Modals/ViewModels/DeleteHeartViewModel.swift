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
    let criticalAlertMessage = PublishSubject<String?>()
    
    struct Output {
        let successAlertMessage: Driver<String?>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 마음 삭제
    func deleteHeart(hCode: String) {
        apiService.request("/api/heart?hcode=\(hCode)", method: .delete)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response, data in
                if (200..<300).contains(response.statusCode) {
                    self.successAlertMessage.onNext("마음이 삭제되었습니다.")
                } else {
                    self.onError()
                }
                
                /*
                let decoder = JSONDecoder()
                
                do {
                    let model = try decoder.decode(ResponseNoDataModel.self, from: data)
                    self.dismissAlertMessage.onNext(model.message)
                } catch {
                    print("ResponseNoDataModel 변환 실패")
                    print(String(data: data, encoding: .utf8) ?? "")
                    
                    self.onError()
                }
                 */
            }, onError: { error in
                print("마음 삭제 중 오류 발생: \(error)")
                self.onError()
            })
            .disposed(by: disposeBag)
    }
    
    private func onError() {
        self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
    }
}

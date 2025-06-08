//
//  RollpeV1ViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

class RollpeV1ViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    var selectedRollpeDataModel: RollpeListDataModel?
    
    private let rollpe = BehaviorRelay<RollpeV1DataModel?>(value: nil)
    
    private let errorAlertMessage = PublishSubject<String?>()
    private let criticalAlertMessage = PublishSubject<String?>()
    
    private let needEnter = BehaviorRelay<Bool?>(value: nil)
    private let isEnterSuccess = BehaviorRelay<Bool?>(value: nil)
    
    struct Output {
        let rollpe: Driver<RollpeV1DataModel?>
        let errorAlertMessage: Driver<String?>
        let criticalAlertMessage: Driver<String?>
        let needEnter: Signal<Bool?>
        let isEnterSuccess: Signal<Bool?>
    }
    
    func transform() -> Output {
        return Output(
            rollpe: rollpe.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil),
            needEnter: needEnter.asSignal(onErrorJustReturn: nil),
            isEnterSuccess: isEnterSuccess.asSignal(onErrorJustReturn: nil)
        )
    }
    
    // 롤페 불러오기
    func getRollpeData(pCode: String) {
        apiService.request("/api/paper?pcode=\(pCode)", method: .get)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response, data in
                self.needEnter.accept(nil)
                self.isEnterSuccess.accept(nil)
                
                let decoder = JSONDecoder()
                
                if (200..<300).contains(response.statusCode) {
                    do {
                        let model = try decoder.decode(RollpeV1ResponseModel.self, from: data)
                        self.rollpe.accept(model.data)
                        
                        self.needEnter.accept(false)
                    } catch {
                        print("ResponseNoDataModel 변환 실패")
                        print(String(data: data, encoding: .utf8) ?? "")
                        
                        self.onError()
                    }
                } else {
                    do {
                        let nodataModel = try decoder.decode(ResponseNoDataModel.self, from: data)
                        self.criticalAlertMessage.onNext(nodataModel.message)
                    } catch {
                        print("ResponseNoDataModel 변환 실패")
                        print(String(data: data, encoding: .utf8) ?? "")
                        
                        self.onError()
                    }
                    
                    self.needEnter.accept(true)
                }
            }, onError: { error in
                print("롤페 정보 가져오는 중 오류 발생: \(error)")
                self.onError()
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 들어가기
    func enterRollpe(pCode: String, password: String? = nil) {
        var body: [String: Any] = [
            "pCode": pCode
        ]
        
        if let password = password {
            body["password"] = password
        }
        
        apiService.request("/api/paper?pcode=\(pCode)", method: .post, parameters: body)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response, data in
                let decoder = JSONDecoder()
                
                if (200..<300).contains(response.statusCode) {
                    self.isEnterSuccess.accept(true)
                } else {
                    do {
                        let nodataModel = try decoder.decode(ResponseNoDataModel.self, from: data)
                        self.criticalAlertMessage.onNext(nodataModel.message)
                    } catch {
                        print("ResponseNoDataModel 변환 실패")
                        print(String(data: data, encoding: .utf8) ?? "")
                        
                        self.onError()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func onError() {
        self.errorAlertMessage.onNext("오류가 발생하였습니다.")
        self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
    }
}

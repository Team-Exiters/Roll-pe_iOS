//
//  EditHeartViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

class EditHeartViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    private let colors = BehaviorRelay<[QueryIndexDataModel]>(value: [])
    let selectedColor = BehaviorRelay<QueryIndexDataModel?>(value: nil)
    
    let successAlertMessage = PublishSubject<String?>()
    let errorAlertMessage = PublishSubject<String?>()
    let criticalAlertMessage = PublishSubject<String?>()
    
    struct Output {
        let colors: Driver<[QueryIndexDataModel]>
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            colors: colors.asDriver(),
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 색상
    func getColors(isMono: Bool) {
        apiService.requestDecodable("/api/index?type=\(isMono ? "monocolor" : "color")", method: .get, decodeType: QueryIndexResponseModel.self)
            .subscribe(onNext: { model in
                self.colors.accept(model.data)
            }, onError: { error in
                print("index 가져오는 중 오류 발생: \(error)")
                self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    // 마음 수정
    func editHeart(heartPK: Int, paperFK: Int, color: String?, context: String?, location: Int) {
        guard let color = color, let context = context else { return }
        
        let body: [String: Any] = [
            "heartPK": heartPK,
            "paperFK": paperFK,
            "color": color.replacingOccurrences(of: "#", with: ""),
            "context": context,
            "location": location
        ]
        
        apiService.requestDecodable("/api/heart", method: .patch, parameters: body, decodeType: ResponseNoDataModel.self)
            .subscribe(onNext: { model in
                self.successAlertMessage.onNext(model.message)
            }, onError: { error in
                print("마음 수정 중 오류 발생: \(error)")
                self.errorAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}

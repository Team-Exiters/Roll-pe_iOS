//
//  WriteHeartViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

class WriteHeartViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    private let colors = BehaviorRelay<[QueryIndexDataModel]>(value: [])
    let selectedColor = BehaviorRelay<QueryIndexDataModel?>(value: nil)
    
    private let successAlertMessage = PublishSubject<String?>()
    private let errorAlertMessage = PublishSubject<String?>()
    private let criticalAlertMessage = PublishSubject<String?>()
    
    struct Input {
        let id: Int
        let index: Int
        let text: ControlProperty<String?>
        let doneTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let colors: Driver<[QueryIndexDataModel]>
        let selectedColor: Driver<QueryIndexDataModel?>
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        let isTextValid = input.text.orEmpty.map { !$0.isEmpty }
        let isColorValid = selectedColor.map { $0?.name != nil }
        
        input.doneTapEvent
            .observe(on: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(isTextValid, isColorValid, input.text.orEmpty))
            .subscribe(onNext: { [weak self] isTextValid, isColorValid, text in
                guard let self = self else { return }
                
                if !isTextValid {
                    errorAlertMessage.onNext("내용을 입력하세요.")
                } else if !isColorValid {
                    errorAlertMessage.onNext("색상을 선택하세요.")
                } else {
                    self.createHeart(paperFK: input.id, color: selectedColor.value?.name, context: text, location: input.index)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            colors: colors.asDriver(),
            selectedColor: selectedColor.asDriver(onErrorJustReturn: nil),
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 색상
    func getColors() {
        apiService.requestDecodable("/api/index?type=color", method: .get, decodeType: QueryIndexResponseModel.self)
            .subscribe(onNext: { model in
                self.colors.accept(model.data)
            }, onError: { error in
                print("index 가져오는 중 오류 발생: \(error)")
                self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    // 추모용 색상
    func getMonoColors() {
        apiService.requestDecodable("/api/index?type=monocolor", method: .get, decodeType: QueryIndexResponseModel.self)
            .subscribe(onNext: { model in
                self.colors.accept(model.data)
            }, onError: { error in
                print("index 가져오는 중 오류 발생: \(error)")
                self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    // 마음 생성
    private func createHeart(paperFK: Int, color: String?, context: String?, location: Int) {
        guard let color = color, let context = context else { return }
        
        let body: [String: Any] = [
            "paperFK": paperFK,
            "color": color,
            "context": context,
            "location": location
        ]
        
        apiService.requestDecodable("/api/heart", method: .post, parameters: body, decodeType: ResponseNoDataModel.self)
            .subscribe(onNext: { model in
                self.successAlertMessage.onNext(model.message)
            }, onError: { error in
                print("마음 남기는 중 오류 발생: \(error)")
                self.errorAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}

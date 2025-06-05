//
//  SearchUserViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/25/25.
//

import Foundation
import RxSwift
import RxCocoa

class SearchUserViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    let users = BehaviorRelay<[SearchUserResultModel]>(value: [])
    private let alertMessage = PublishSubject<String?>()
    
    struct Input {
        let word: ControlProperty<String?>
        let keyboardTapEvent: ControlEvent<Void>
        let searchButtonTapEvent: ControlEvent<Void>
        let selectUser: ControlEvent<IndexPath>
    }
    
    struct Output {
        let users: Driver<[SearchUserResultModel]>
        let showAlert: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        let searchTrigger = Observable.merge(
            input.keyboardTapEvent.asObservable(),
            input.searchButtonTapEvent.asObservable()
        )
        
        searchTrigger
            .observe(on: MainScheduler.instance)
            .withLatestFrom(input.word)
            .subscribe(onNext: { [self] word in
                if let word {
                    self.getUsers(name: word)
                } else {
                    self.alertMessage.onNext("이름을 입력하세요")
                }
            })
            .disposed(by: disposeBag)
        
        input.selectUser
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                var currentUsers = self.users.value
                
                for i in currentUsers.indices {
                    currentUsers[i].isSelected = (i == indexPath.row)
                }
                
                self.users.accept(currentUsers)
            })
            .disposed(by: disposeBag)
        
        return Output(
            users: users.asDriver(),
            showAlert: alertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 유저 불러오기
    func getUsers(name: String) {
        apiService.requestDecodable("/api/user/search-user/?nameCode=\(name)", method: .get, decodeType: SearchUserModel.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                self.users.accept(model.data.results)
            }, onError: { error in
                print("검색한 유저 불러오는 중 오류 발생: \(error)")
                self.alertMessage.onNext("검색 결과가 없습니다.")
            })
            .disposed(by: disposeBag)
    }
}

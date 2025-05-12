//
//  MainAfterSignInViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/18/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainAfterSignInViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    init() {
        getHotRollpes()
    }
    
    // 지금 뜨는 롤페들
    let hotRollpeList = BehaviorRelay<[RollpeListDataModel]>(value: [])
    
    // 지금 뜨는 롤페들 불러오기
    func getHotRollpes() {
        apiService.requestDecodable("/api/paper/user?type=hot", method: .get, decodeType: RollpeResponseListModel.self)
            .subscribe(onNext: { model in
                self.hotRollpeList.accept(model.data)
            }, onError: { error in
                print("내가 작성한 마음 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

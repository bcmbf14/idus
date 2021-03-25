//
//  TrackViewModel.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import RxCocoa
import RxSwift

protocol TrackViewModelType {
    var viewWillAppear: PublishSubject<Void> { get }
    var isNetworking: Driver<Bool> { get }
    var track: Driver<Track> { get }
}


struct TrackViewModel:TrackViewModelType {
    
    // MARK: <- Event
    
    let viewWillAppear = PublishSubject<Void>()
    
    // MARK: <- UI
    
    let track: Driver<Track>
    let isNetworking: Driver<Bool>
    let showAlert: Driver<(String, String)>
    
    
    init () {
        let onNetworking = PublishSubject<Bool>()
        isNetworking = onNetworking.asDriver(onErrorJustReturn: false)
        
        let onError = PublishSubject<Error>()
        showAlert = onError
            .map { error -> (String, String) in
                return ("Error", error.localizedDescription)
            }.asDriver(onErrorJustReturn: ("Error", "Unknown Error"))
        
        track = Observable<Void>
            .merge([viewWillAppear])
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .do(onNext: { _ in onNetworking.onNext(true) })
            .flatMapLatest {
                return APIService.fetchTrack()
                    .retry(2)
                    .do(onDispose:  { onNetworking.onNext(false) })
                    .catch({ error -> Single<Track> in
                        onError.onNext(error)
                        return .never()
                    })
            }
            .share()
            .asDriver(onErrorJustReturn: Track.dummy)
    }
    
}



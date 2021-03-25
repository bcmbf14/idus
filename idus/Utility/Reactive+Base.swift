//
//  Reactive+Base.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//


import RxCocoa
import RxSwift


extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: URLSession {
    func dataTask(request: URLRequest) -> Single<Data> {
        return Single.create(subscribe: { observer -> Disposable in
            let task = self.base.dataTask(with: request) { (data, response, error) in
                guard let response = response as? HTTPURLResponse, let data = data else {
                    
                    observer(.failure(ServiceError.unknown))
                    
                    return
                }
                guard 200..<400 ~= response.statusCode else {
                    observer(.failure(ServiceError.requestFailed(response: response, data: data)))
                    return
                }
                observer(.success(data))
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        })
    }
}


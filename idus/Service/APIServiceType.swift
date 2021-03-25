//
//  ServiceType.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import RxSwift

protocol APIServiceType {
    static func fetchTrack() -> Single<Track>
}

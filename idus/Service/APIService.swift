//
//  Service.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import RxCocoa
import RxSwift

struct APIService: APIServiceType {
    // MARK: Properties
    
    private let session: URLSession
    
    // MARK: Initialize
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: DataTask
    
    static func fetchTrack() -> Single<Track> {
        let session = URLSession.shared
        
        let baseUrl = "http://itunes.apple.com/lookup?id="
        let id = "872469884"
        
        guard let url = URL(string: baseUrl + id) else {
            return .error(ServiceError.urlTransformFailed)
        }
        
        return session.rx.dataTask(request: URLRequest(url: url))
            .map { data throws in
                let tracks = try data.decode(Tracks.self)
                
                return tracks.results.first ?? Track.dummy
            }
    }
}

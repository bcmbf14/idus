//
//  Data+Decode.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import Foundation

extension Data {
  func decode<T>(_ type: T.Type, decoder: JSONDecoder? = nil) throws -> T where T: Decodable {
    let decoder = decoder ?? JSONDecoder()
    return try decoder.decode(type, from: self)
  }
}

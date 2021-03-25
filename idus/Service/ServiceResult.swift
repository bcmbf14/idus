//
//  ServiceResult.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import Foundation

enum ServiceError: Error {
  case unknown
  case urlTransformFailed
  case requestFailed(response: HTTPURLResponse, data: Data?)
}

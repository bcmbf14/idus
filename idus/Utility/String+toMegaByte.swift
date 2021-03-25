//
//  String+Byte.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import Foundation

extension String {
    func toMegaByte() -> String {
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            return bcf.string(fromByteCount: Int64(self) ?? 0)
    }
}

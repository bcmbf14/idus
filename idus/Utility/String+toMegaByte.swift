//
//  String+Byte.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import Foundation

extension String {
    func toMegaByte() -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useMB]
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: Int64(self) ?? 0)
    }
}

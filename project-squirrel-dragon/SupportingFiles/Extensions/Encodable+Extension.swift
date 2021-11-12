//
//  Encodable+Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/11.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

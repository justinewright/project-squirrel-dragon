//
//  Firebase+Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/08.
//

import Firebase
import Foundation

extension DataSnapshot {
    var data: Data? {
    guard let value = value,
    !(value is NSNull) else {return nil}

    return try? JSONSerialization.data(withJSONObject: value)
    }

    var json: String? {data?.string}
}

extension Data {
    var string: String? {String(data: self, encoding: .utf8)}
}

extension DataSnapshot {

func snapshotToArrayOfDataModel<ConversionType:Codable> (
    snapshot: DataSnapshot,
    expecting: ConversionType.Type) -> ConversionType? {
        guard let data = snapshot.data else { return nil }
        do {
            let decodedData = try JSONDecoder().decode(ConversionType.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }

}

//
//  Array+Ext.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 12/5/18.
//

import Foundation

extension Array {
    func chuncked(into size: Int) -> [[Element]]{
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//
//  SauronError.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 11/20/18.
//

import Foundation

internal struct SauronError: LocalizedError, Equatable {
    
    private var description: String!
    
    init(description: String) {
        self.description = description
    }
    
    var errorDescription: String? {
        return description
    }
    
    public static func ==(lhs: SauronError, rhs: SauronError) -> Bool {
        return lhs.description == rhs.description
    }
}

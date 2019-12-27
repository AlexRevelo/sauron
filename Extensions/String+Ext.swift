//
//  String+Ext.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 11/22/18.
//

import Foundation

extension String{
    func toBase64() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
}

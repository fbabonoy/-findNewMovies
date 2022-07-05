//
//  NetworkError.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/5/22.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badURL
    case other(Error)
}

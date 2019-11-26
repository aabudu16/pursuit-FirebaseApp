//
//  AppError.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/26/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import Foundation
enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}

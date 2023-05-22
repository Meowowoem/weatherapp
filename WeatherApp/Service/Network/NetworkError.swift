//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation

enum FetchError: LocalizedError {
    case badResponce, networkFailure, decodingFailure, invalidData, locationFailed, unknown
}

extension FetchError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badResponce:
            return "Response error"
        case .networkFailure:
            return "Network error"
        case .decodingFailure:
            return "Decoding error"
        case .invalidData:
            return "Invalid data"
        case .locationFailed:
            return "Error in determining geolocation"
        case .unknown:
            return "Unknown error"
        }
    }
}

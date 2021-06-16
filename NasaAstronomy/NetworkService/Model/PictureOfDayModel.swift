//
//  PictureOfDayModel.swift
//  NetworkService
//
//  Created by suresh kansujiya on 15/06/21.
//

import Foundation

// MARK: - PictureOfDayModel
public struct PictureOfDayModel: Codable {
    public let date, explanation: String
    public let hdurl: String
    public let mediaType, serviceVersion, title: String
    public let url: String

    public enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

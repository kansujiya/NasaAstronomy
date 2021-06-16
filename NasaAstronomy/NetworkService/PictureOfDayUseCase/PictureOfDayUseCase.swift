//
//  PictureOfDayUseCase.swift
//  NetworkService
//
//  Created by suresh kansujiya on 15/06/21.
//

import Foundation

public enum PictureOfDayEndpoints {
    case getPictureOfDay
}

extension PictureOfDayEndpoints: Endpoint {
    
    public var base: String {
        return ServiceConstant.baseUrl
    }
    
    public var path: String {
        switch self {
        case .getPictureOfDay: return "api_key"
        }
    }
}

public protocol PicureOfTheDayUseCaseProtocol {
    func getPictureOfTheDay(from pictureType: PictureOfDayEndpoints, completion: @escaping (Result<PictureOfDayModel?, APIError>) -> Void)
}

public class PicureOfTheDayUseCase: NetworkServiceManagerProtocol, PicureOfTheDayUseCaseProtocol  {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    public convenience init() {
        self.init(configuration: .default)
    }
    
    public func getPictureOfTheDay(from pictureType: PictureOfDayEndpoints, completion: @escaping (Result<PictureOfDayModel?, APIError>) -> Void) {
        let endpoint = pictureType
        let request = endpoint.request
        let key = shortStringValueInYYYYMMDDAsDate(Date()) ?? ""
        if DataCache.instance.hasData(forKey: key) {
            do {
                let readUser: PictureOfDayModel? = try DataCache.instance.readCodable(forKey: key)
                completion(.success(readUser))
            } catch {}
        } else {
            fetch(with: request, decode: { json -> PictureOfDayModel? in
                guard let pictureOfDayModel = json as? PictureOfDayModel else {return  nil}
                return pictureOfDayModel
            }, completion: { value in
                switch value {
                case .success(let model):
                    DataCache.instance.cleanAll()
                    do {
                        try DataCache.instance.write(codable: model, forKey: key)
                    } catch {
                        completion(.failure(.responseUnsuccessful))
                    }
                    completion(.success(model))
                case .failure:
                    do {
                        let lastDayKey = shortStringValueInYYYYMMDDAsDayBeforeDate(Date()) ?? ""
                        guard let readUser: PictureOfDayModel? = try DataCache.instance.readCodable(forKey: lastDayKey) else {
                            completion(.failure(.responseUnsuccessful))
                            return
                        }
                        completion(.success(readUser))
                    } catch {
                        completion(.failure(.responseUnsuccessful))
                    }
                }
            })
        }
    }
}

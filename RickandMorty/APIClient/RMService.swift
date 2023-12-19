//
//  RMService.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import Foundation

///Primary API service object to get rick and morty data
final class RMService {
    static let shared = RMService() // shared singleton instance
    
    private init() {
        
    }
    
    enum RMServiceError: Error {
        case failedToCreatedRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(_ request: RMRequest,
                                    expecting type: T.Type,
                                    completion: @escaping(Result<T, Error>) -> Void) {
        
        guard let urlRequest = self.request(from: request) else{
            completion(.failure(RMServiceError.failedToCreatedRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            //decode response
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: -Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest?{
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}

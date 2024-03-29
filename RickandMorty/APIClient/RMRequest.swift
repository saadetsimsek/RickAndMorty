//
//  RMRequest.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import Foundation

///Object thet represent a singlet API call
final class RMRequest {
    //base url
    // endpoint
    //paht component
    //query parameters
    
    private struct Constants{
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    let endpoint: RMEndpoint //desired endpoint
    
    private let pathComponenets: [String] // path components for API, if any
    
    private let queryParameters:[URLQueryItem] // query arguments for API, if any
    
    //Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponenets.isEmpty{
            pathComponenets.forEach({
                string += "/\($0)"
            })
        }
        if !queryParameters.isEmpty{
            string += "?"
           //name=value § name=value
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil }
                return "/\($0.name) = \(value)"
            }).joined(separator: "§")
          
            string += argumentString
        }
        
        return string
    }
    
    //computed § constructed API url
    
    public var url: URL? {
        return URL(string: urlString)
    }
    // bu kod, belirli bir temel URL'ye ve belirli bir uç noktaya dayanarak, ek bileşenleri (yol ve sorgu parametreleri) ekleyerek bir URL oluşturan bir yapıyı temsil eder. Oluşturulan URL, url adlı bir özellik aracılığıyla erişilebilir hale getirilmiştir.
    
    public let httpMethod = "GET"
    
    //MARK: - Public
    
    public init(endpoint: RMEndpoint, 
                pathComponenets: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponenets = pathComponenets
        self.queryParameters = queryParameters
    }
    
    ///atemp to create request
    ///-Parameter url: URL to parse
    ///
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                
                var pathComponenets : [String] = []
                if components.count > 1 {
                    pathComponenets = components
                    pathComponenets.removeFirst()
                }
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponenets: pathComponenets)
                    return
                }
            }
        }
        else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                //calue=name%value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0],
                                        value: parts[1])
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest{
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
    static let listLocationRequest = RMRequest(endpoint: .location)
}

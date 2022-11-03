//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 31/10/22.
//


import Foundation

public protocol Platform {
    static func getShared() -> Platform
    func getNetwork() -> LKTONetwork
}


public enum LKTOAPIMethod: String {
    case POST
    case GET
}


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

public struct LKTOAPIEndpoint {
    public let path: String
    public var method: LKTOAPIMethod = .GET
    public var params: [String: String]? = nil
    
    public init(path: String, method: LKTOAPIMethod = .GET, params: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.params = params
    }
    
    public var urlComponents = URLComponents()
    
    public mutating func createURLRequest(for environment: NetworkEnvironment) -> URLRequest? {
        let baseURL = URL(string: environment.baseURL)
        
        
       
        urlComponents.scheme = baseURL?.scheme ?? "https"
        urlComponents.host = baseURL?.host ?? ""
        urlComponents.path = path
        
        if let queryParams = params {
            urlComponents.setQueryItems(with: queryParams)
        }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
}

public class LKTOWholesalesPlatform: Platform {
    public let baseURL = ""
    public static let shared = LKTOWholesalesPlatform()
    public let network: LKTONetwork
    
    
    public static func getShared() -> Platform {
        return shared
    }
    
    public func getNetwork() -> LKTONetwork {
        return network
    }
    
    init() {
        network = LKTONetwork(.production)
    }
}


public struct NetworkEnvironment {
    public let baseURL: String
}

extension NetworkEnvironment {
    public static let test = NetworkEnvironment(baseURL: "http://localhost.com")
    public static let production =   NetworkEnvironment(baseURL: "https://davidani.com")
}



public struct DataSerializer {
    public let data: Data
    public var decoder =  JSONDecoder()
    
    public func decode<T: Decodable>() -> T? {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {}
        return nil
    }
}




public class LKTONetworkRequest: NSObject {
    public var parent: LKTONetwork?
    public var endpoint: LKTOAPIEndpoint
    public var forceRefresh = false
    private var task: URLSessionTask?
    init(_ endpoint: LKTOAPIEndpoint, parent: LKTONetwork) {
        self.parent = parent
        self.endpoint = endpoint
    }
    
    public func resume(completion: @escaping(Result<DataSerializer, LKTOError>) -> Void) {
        guard  task == nil || forceRefresh else {
            task?.resume()
            return
        }
       task = parent?.requestHandler.handle(request: endpoint.createURLRequest(for: parent?.environment ?? .test)!, completion: { result in
            switch result {
            case .success(let data): do {
                print("Success \(String(data: data, encoding: .utf8))")
                completion(.success(DataSerializer(data: data)))
            }
            case .failure(let lktError): do {
                completion(.failure(lktError))
            }
            }
        })
        task?.resume()
    }
    func cancel() {}
    func pause() {}
    func loadMore() {}
    func change(endpoint: LKTOAPIEndpoint) {}
    
}


public class LKTONetwork {
    public var environment: NetworkEnvironment
    public var requestHandler: LKTONetworkRequestable
    init( _ environment: NetworkEnvironment, requestHandler: LKTONetworkRequestable = URLSession.shared) {
        self.environment = environment
        self.requestHandler = requestHandler
    }
    
    public func createRequest(for endPoint: LKTOAPIEndpoint) -> LKTONetworkRequest {
        return LKTONetworkRequest(endPoint, parent: self)
    }
}


public protocol LKTONetworkRequestable: AnyObject {
    func handle(request: URLRequest, completion: @escaping(Result<Data, LKTOError>) -> Void) -> URLSessionTask
}


extension URLSession: LKTONetworkRequestable {
    public func handle(request: URLRequest, completion: @escaping(Result<Data, LKTOError>) -> Void) -> URLSessionTask {
        
        print(request.url?.absoluteString)
        
        return self.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.requestError(error)))
                return
            }
            //print("Success \(String(data: data, encoding: .utf8))")
            completion(.success(data))
        }
    }
}


public enum LKTOError: Error {
    case dataNilError
    case requestError(Error?)
    case dataParseError(message: String)
}






public struct LKTOListResponse<model: Decodable>: Decodable {
    public let data: [model]
}

public struct LKTODictionaryResponse<model: Decodable>: Decodable {
    public let data: model
}

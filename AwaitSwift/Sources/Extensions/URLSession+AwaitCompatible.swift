//
//  URLSession+AwaitCompatible.swift
//  AwaitSwift
//
//  Created by Gleb Radchenko on 10/24/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import PromiseSwift

extension Awaitable where Base: URLSession {
    public typealias DataTaskCompletion = (Data?, URLResponse?)
    
    public func sendRequest(queue: DispatchQueue = .global(), _ request: URLRequest) -> Promise<DataTaskCompletion> {
        return async(queue: queue) { (resolve) in
            self.base.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    resolve(.error(error))
                } else {
                    resolve(.value((data, response)))
                }
            }
        }
    }
    
    public func sendRequest(queue: DispatchQueue = .global(), _ request: URLRequest) throws -> DataTaskCompletion {
        return try sendRequest(queue: queue, request).await()
    }
    
    public func sendRequest(queue: DispatchQueue = .global(), _ request: URLRequest) -> Promise<Data> {
        return async(queue: queue) {
            let (someData, _) = try self.sendRequest(queue: queue, request)
            
            guard let data = someData else {
                throw NSError.defaultAwaitError()
            }
            
            return data
        }
    }
    
    public func sendRequest(queue: DispatchQueue = .global(), _ request: URLRequest) throws -> Data {
        return try sendRequest(queue: queue, request).await()
    }
    
    public func sendRequest<R: Decodable>(queue: DispatchQueue = .global(), _ request: URLRequest) -> Promise<R> {
        return async(queue: queue) {
            let data: Data = try self.sendRequest(queue: queue, request)
            return try JSONDecoder().decode(R.self, from: data)
        }
    }
    
    public func sendRequest<R: Decodable>(queue: DispatchQueue = .global(), _ request: URLRequest) throws ->  R {
        return try sendRequest(queue: queue, request).await()
    }
}

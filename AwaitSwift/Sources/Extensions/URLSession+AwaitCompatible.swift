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
            let task = self.base.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    resolve(.error(error))
                } else {
                    resolve(.value((data, response)))
                }
            }
            
            task.resume()
        }
    }
    
    public func sendRequest(queue: DispatchQueue = .global(), _ request: URLRequest) -> Promise<Data> {
        return async(queue: queue) {
            let (someData, _) = try self.sendRequest(queue: queue, request).await()
            
            guard let data = someData else {
                throw NSError.defaultAwaitError()
            }
            
            return data
        }
    }
    
    public func sendRequest<R: Decodable>(queue: DispatchQueue = .global(), _ request: URLRequest) -> Promise<R> {
        return async(queue: queue) {
            let data: Data = try self.sendRequest(queue: queue, request).await()
            return try JSONDecoder().decode(R.self, from: data)
        }
    }
}

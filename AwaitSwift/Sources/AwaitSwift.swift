//
//  AwaitSwift.swift
//  AwaitSwift
//
//  Created by Gleb Radchenko on 10/24/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import PromiseSwift

extension Error {
    static func defaultAwaitError() -> NSError {
        return NSError(domain: "await-swift", code: 0, userInfo: nil)
    }
}

@discardableResult
public func await<R>(queue: DispatchQueue = .global(), _ block: @escaping () throws -> R) throws -> R {
    return try await(
        Promise<R>(queue: queue) { (resolve) in
            do {
                let r = try block()
                resolve(.value(r))
            } catch {
                resolve(.error(error))
            }
        }
    )
}

@discardableResult
public func await<R>(_ promise: Promise<R>) throws -> R {
    let semaphore = DispatchSemaphore(value: 0)
    
    var result: PromiseResult<R> = .error(NSError.defaultAwaitError())
    promise.execute { result = $0; semaphore.signal() }
    
    semaphore.wait()
    return try result.valueOrThrow()
}

@discardableResult
public func async<R>(queue: DispatchQueue = .global(), _ block: @escaping (@escaping (PromiseResult<R>) -> Void) -> Void) -> Promise<R> {
    return Promise<R>(queue: queue) { block($0) }
}

@discardableResult
public func async<R>(queue: DispatchQueue = .global(), _ block: @escaping () throws -> R) -> Promise<R> {
    return Promise<R>(queue: queue) { (resolve) in
        do {
            let r = try block()
            resolve(.value(r))
        } catch {
            resolve(.error(error))
        }
    }
}

public func async<R>(queue: DispatchQueue = .global(), _ block: @escaping () throws -> R) {
    let promise: Promise<R> = async(queue: queue, block)
    promise.execute()
}

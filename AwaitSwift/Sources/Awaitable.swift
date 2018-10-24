//
//  Awaitable.swift
//  AwaitSwift
//
//  Created by Gleb Radchenko on 10/24/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

public protocol Awaitable {
    associatedtype T
    
    var awaitable: T { get }
}

extension Awaitable {
    public var awaitable: Base<Self> {
        return Base(base: self)
    }
}

public struct Base<T> {
    public let base: T
    
    public init(base: T) {
        self.base = base
    }
}

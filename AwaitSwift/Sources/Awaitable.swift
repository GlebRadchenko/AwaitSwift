//
//  Awaitable.swift
//  AwaitSwift
//
//  Created by Gleb Radchenko on 10/24/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

public struct Awaitable<Base> {
    public let base: Base
    
    public init(base: Base) {
        self.base = base
    }
}

public protocol AwaitCompatible {
    associatedtype CompatibleType
    
    var await: Awaitable<CompatibleType> { get set }
    static var await: Awaitable<CompatibleType>.Type { get set }
}

extension AwaitCompatible {
    public var await: Awaitable<Self> {
        get { return Awaitable(base: self) }
        set { }
    }
    
    public static var await: Awaitable<Self>.Type {
        get { return Awaitable<Self>.self }
        set { }
    }
}

import class Foundation.NSObject
extension NSObject: AwaitCompatible { }

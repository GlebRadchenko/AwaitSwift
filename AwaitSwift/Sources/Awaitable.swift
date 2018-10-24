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
    
    var aw: Awaitable<CompatibleType> { get set }
    static var aw: Awaitable<CompatibleType>.Type { get set }
}

extension AwaitCompatible {
    public var aw: Awaitable<Self> {
        get { return Awaitable(base: self) }
        set { }
    }
    
    public static var aw: Awaitable<Self>.Type {
        get { return Awaitable<Self>.self }
        set { }
    }
}

import class Foundation.NSObject
extension NSObject: AwaitCompatible { }

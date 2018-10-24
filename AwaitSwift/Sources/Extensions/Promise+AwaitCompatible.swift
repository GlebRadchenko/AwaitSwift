//
//  Promise+AwaitCompatible.swift
//  AwaitSwift
//
//  Created by Gleb Radchenko on 10/24/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import PromiseSwift

extension Promise: AwaitCompatible {
    @discardableResult
    public func await() throws -> Element {
        checkThread()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: PromiseResult<Element> = .error(NSError.defaultAwaitError())
        execute { result = $0; semaphore.signal() }
        
        semaphore.wait()
        return try result.valueOrThrow()
    }
    
    fileprivate func checkThread() {
        assert(!Thread.isMainThread, "Can't call \(#function) on Main Thread")
    }
}

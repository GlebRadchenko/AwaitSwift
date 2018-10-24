//
//  AppDelegate.swift
//  Buildable
//
//  Created by Gleb Radchenko on 10/24/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit
import AwaitSwift
import PromiseSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application
        (_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        test()
        
        do {
            let userAndChildren = try loginAndGetChildred(for: "Gleb").await()
        } catch {
            print(error)
        }
        
        return true
    }
    
    func test() {
        let str = try! await(generateString())
        print(str)
    }
    
    func generateString() -> Promise<String> {
        return async {
            let intArray = try await(async { () -> [Int] in
                return [1, 2, 3, 4, 5]
            })
            
            let doubleArray = try await(async { () -> [Double] in
                return intArray.map { Double($0) }
            })
            
            let stringArray = try await { () -> [String] in
                return doubleArray.map { "\($0)" }
            }
            
            return stringArray.reduce("", { (r, value) -> String in
                return r + value + " "
            })
        }
    }
    
    class User: Decodable {
        var name: String
    }
    
    func login(name: String) -> Promise<User> {
        return async {
            let request = URLRequest.init(url: URL(string: "https://google.com/")!)
            let user: User = try URLSession.shared.aw.sendRequest(request).await()
            return user
        }
    }
    
    func getChildren(for user: User) -> Promise<[User]> {
        return async {
            let request = URLRequest.init(url: URL(string: "")!)
            let children: [User] = try URLSession.shared.aw.sendRequest(request).await()
            return children
        }
    }
    
    func loginAndGetChildred(for userName: String) -> Promise<(User, [User])> {
        return async {
            let user = try self.login(name: userName).await()
            let children = try self.getChildren(for: user).await()
            
            return (user, children)
        }
    }
}


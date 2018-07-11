//
//  HeadsAndHandsKit.swift
//  HeadsAndHandsKit
//
//  Created by Sergey on 09/07/2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation

public enum HeadsAndHeadsKit {
    public static func helloWorld() {
        print("Hello World")
    }
}

public class Reuse {
    static var shared: Reuse?
    private let config: ReuseConfiguration
    private static let defaults = UserDefaults.standard


    public static func instantiate(with config: ReuseConfiguration) {
        Reuse.shared = Reuse(config: config)
    }

    private init(config: ReuseConfiguration) {
        self.config = config
    }

    var session: URLSession {
        return URLSession(configuration: .default)
    }

    var baseURL: URL {
        return config.url
    }
}

public class ReuseConfiguration {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
}

public enum ReuseError: Error {
    case noInstantiating
    case badParsing
    case noResponse
    case badResponse(code: Int)
}

public protocol LoginViewControllerProtocol {
    var login: String { get }
    var password: String { get }

    func logIn(completion: @escaping (Bool, ReuseError?) -> Void)
}

public extension LoginViewControllerProtocol where Self: UIViewController {
    public func logIn(completion: @escaping (Bool, ReuseError?) -> Void) {
        guard let shared = Reuse.shared else {
            completion(false, ReuseError.noInstantiating)
            return
        }
        let url = URL(fileURLWithPath: "/auth.php", relativeTo: shared.baseURL)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let params = [
            "login": login,
            "password": password
        ]

        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])

        let task = shared.session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(false, ReuseError.noResponse)
                return
            }

            if response.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, ReuseError.badResponse(code: response.statusCode))
            }
        }

        task.resume()
    }
}

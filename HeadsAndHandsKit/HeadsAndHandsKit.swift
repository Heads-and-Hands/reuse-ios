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

    var loginType: LoginType {
        return config.loginType
    }

    var minPasswordLength: Int {
        return config.minPassLength
    }
}

struct Regex {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let plainString = "[A-Z0-9a-z._%+-@!#$^*()_? ]"
}

public class ReuseConfiguration {
    let url: URL
    let loginType: LoginType
    let minPassLength: Int
    let isComplexPass: Bool

    public init(url: URL, loginType: LoginType, minPassLength: Int, isComplexPass: Bool) {
        self.url = url
        self.loginType = loginType
        self.minPassLength = minPassLength
        self.isComplexPass = isComplexPass
    }
}

public enum ReuseError: Error {
    case noInstantiating
    case badURL
    case badParsing
    case noResponse
    case badResponse(code: Int)
}

public enum LoginType {
    case phone
    case email
    case string
}

public protocol LoginBehaviour {
    var login: String { get }
    var password: String { get }
    var isLoginValid: Bool { get }
    var isPasswordValid: Bool { get }

    func logIn(completion: @escaping (Bool, ReuseError?) -> Void)
}

public extension LoginBehaviour {
    public func logIn(completion: @escaping (Bool, ReuseError?) -> Void) {
        guard let shared = Reuse.shared else {
            completion(false, ReuseError.noInstantiating)
            return
        }
        guard let url = URL(string: "/auth.php", relativeTo: shared.baseURL) else {
            completion(false, ReuseError.badURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let params = [
            "login": login,
            "password": password
        ]

        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])

        let task = shared.session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
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
        }

        task.resume()
    }

    public var isLoginValid: Bool {
        guard let shared = Reuse.shared else {
            return false
        }

        switch shared.loginType {
        case .email:
            let test = NSPredicate(format: "SELF MATCHES %@", Regex.email)
            return test.evaluate(with: login)
        case .phone:
            return login.isPhoneNumber
        case .string:
            let test = NSPredicate(format: "SELF MATCHES %@", Regex.plainString)
            return test.evaluate(with: login)
        }
    }

    public var isPasswordValid: Bool {
        guard let shared = Reuse.shared else {
            return false
        }

        return password.count >= shared.minPasswordLength
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

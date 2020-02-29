//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/17/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var userId = ""
        static var sessionId = ""
    }
        
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let uniqueKeyParam = "?uniqueKey=\(Auth.userId)"
        
        case login
        case logout
        case getStudentLocations
        case postStudentLocation
        case getUserData
        case updateStudentLocation
        
        var stringValue: String {
            switch self {
            case .login, .logout:
                return Endpoints.base + "/session"
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation, .updateStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .getUserData:
                return Endpoints.base + "/users/" + Auth.userId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
            
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.login.url
        let body = LoginRequest(udacity: Udacity(username: username, password: password))
        let ResponseType = LoginResponse.self
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                Auth.userId = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.login.url
        let ResponseType = LogoutResponse.self

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
               completion(false, error)
               return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            do {
                _    = try decoder.decode(ResponseType.self, from: newData)
                Auth.userId = ""
                Auth.sessionId = ""
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getStudentLocations(uniqueKey: String = "", completion: @escaping ([StudentInformation], Error?) -> Void) {
        var url = Endpoints.getStudentLocations.url
        if !uniqueKey.isEmpty {
            url = URL(string: "&uniqueKey=" + uniqueKey, relativeTo: url)!
        }
        
        taskForGETRequest(url: url, response: StudentLocationResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.postStudentLocation.url
        let body = PostLocationRequest(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.userId)
        let ResponseType = PostLocationResponse.self
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
               completion(false, error)
               return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                LocationModel.myLocation = StudentInformation(createdAt: responseObject.createdAt, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectId: responseObject.objectId, uniqueKey: Auth.userId, updatedAt: responseObject.createdAt)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func getStudentData(completion: @escaping (Student?, Error?) -> Void) {
        let url = Endpoints.getUserData.url
        let ResponseType = Student.self
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func updateStudentLocation(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.updateStudentLocation.url
        let body = PostLocationRequest(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.userId)
        let ResponseType = PostLocationResponse.self
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
               completion(false, error)
               return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                LocationModel.myLocation = StudentInformation(createdAt: responseObject.createdAt, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectId: responseObject.objectId, uniqueKey: Auth.userId, updatedAt: responseObject.createdAt)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}

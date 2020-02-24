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
        
        var stringValue: String {
            switch self {
            case .login, .logout:
                return Endpoints.base + "/session"
            case .getStudentLocations, .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
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
               completion(false, error)
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
    
    class func getStudentLocations(uniqueKey: String = "", completion: @escaping ([StudentLocation], Error?) -> Void) {
        var url = Endpoints.getStudentLocations.url
        if !uniqueKey.isEmpty {
            url = URL(string: "?uniqueKey=" + uniqueKey, relativeTo: url)!
        }
        let ResponseType = StudentLocationResults.self
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
               completion([], error)
               return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
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
                LocationModel.myLocation = StudentLocation(createdAt: responseObject.createdAt, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectId: responseObject.objectId, uniqueKey: Auth.userId, updatedAt: responseObject.createdAt)
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


//
//
//
//{
//    "createdAt": "2015-02-25T01:10:38.103Z",
//    "firstName": "Jarrod",
//    "lastName": "Parkes",
//    "latitude": 34.7303688,
//    "longitude": -86.5861037,
//    "mapString": "Huntsville, Alabama ",
//    "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
//    "objectId": "JhOtcRkxsh",
//    "uniqueKey": "996618664",
//    "updatedAt": "2015-03-09T22:04:50.315Z"
//}


//class TMDBClient {
//
//    static let apiKey = "33ef9433576edbae22e89a3ee82bfb33"
//
//    struct Auth {
//        static var accountId = 0
//        static var requestToken = ""
//        static var sessionId = ""
//    }
//
//    enum Endpoints {
//        static let base = "https://api.themoviedb.org/3"
//        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
//
//        case getWatchlist
//        case getRequestToken
//        case login
//        case getSessionId
//        case webAuth
//        case logout
//        case getFavorites
//        case search(String)
//        case markWatchlist
//        case markFavorite
//        case posterImageURL(String)
//
//        var stringValue: String {
//            switch self {
//            case .getWatchlist:
//                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
//            case .getRequestToken:
//                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
//            case .login:
//                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
//            case .getSessionId:
//                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
//            case .webAuth:
//                return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
//            case .logout:
//                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
//            case .getFavorites:
//                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
//            case .search(let query):
//                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//            case .markWatchlist:
//                return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
//            case .markFavorite:
//                return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
//            case .posterImageURL(let posterPath):
//                return "https://image.tmdb.org/t/p/w500/" + posterPath
//            }
//        }
//
//        var url: URL {
//            return URL(string: stringValue)!
//        }
//    }
//
//    @discardableResult
//    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            } catch {
//                do {
//                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//        return task
//    }
//
//    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try! JSONEncoder().encode(body)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//               completion(nil, error)
//               return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            } catch {
//                do {
//                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//
//    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
//        taskForGETRequest(url: Endpoints.getWatchlist.url, response: MovieResults.self) { (response, error) in
//            if let response = response {
//                completion(response.results, nil)
//            } else {
//                completion([], error)
//            }
//        }
//    }
//
//    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
//        taskForGETRequest(url: Endpoints.getRequestToken.url, response: RequestTokenResponse.self) { (response, error) in
//            if let response = response {
//                Auth.requestToken = response.requestToken
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//
//    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
//        taskForPOSTRequest(url: Endpoints.login.url, response: RequestTokenResponse.self, body: body) { (response, error) in
//            if let response = response {
//                Auth.requestToken = response.requestToken
//                completion(true, error)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//
//    class func getSessionId(completion: @escaping (Bool, Error?) -> Void) {
//        let body = PostSession(requestToken: Auth.requestToken)
//        taskForPOSTRequest(url: Endpoints.getSessionId.url, response: SessionResponse.self, body: body) { (response, error) in
//            if let response = response {
//                Auth.sessionId = response.sessionId
//                completion(true, error)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//
//    class func logout(completion: @escaping () -> Void) {
//        var request = URLRequest(url: Endpoints.logout.url)
//        request.httpMethod = "DELETE"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = LogoutRequest(sessionId: Auth.sessionId)
//        request.httpBody = try! JSONEncoder().encode(body)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            Auth.requestToken = ""
//            Auth.sessionId = ""
//            completion()
//        }
//        task.resume()
//    }
//
//    class func getFavorites(completion: @escaping ([Movie], Error?) -> Void) {
//        taskForGETRequest(url: Endpoints.getFavorites.url, response: MovieResults.self) { (response, error) in
//            if let response = response {
//                completion(response.results, nil)
//            } else {
//                completion([], error)
//            }
//        }
//    }
//
//    class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionTask {
//        let task = taskForGETRequest(url: Endpoints.search(query).url, response: MovieResults.self) { (response, error) in
//            if let response = response {
//                completion(response.results, nil)
//            } else {
//                completion([], error)
//            }
//        }
//        return task
//    }
//
//    class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
//        let body = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
//        taskForPOSTRequest(url: Endpoints.markWatchlist.url, response: TMDBResponse.self, body: body) { (response, error) in
//            if let response = response {
//                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//
//    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
//        let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
//        taskForPOSTRequest(url: Endpoints.markFavorite.url, response: TMDBResponse.self, body: body) { (response, error) in
//            if let response = response {
//                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//
//    class func downloadPosterImage(posterPath: String, completion: @escaping (Data?, Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: Endpoints.posterImageURL(posterPath).url) { data, response, error in
//            guard let data = data else {
//                completion(nil, error)
//                return
//            }
//            completion(data, nil)
//        }
//        task.resume()
//    }
//}

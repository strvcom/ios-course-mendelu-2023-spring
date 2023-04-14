import UIKit

// Rick and morty API Docs - https://rickandmortyapi.com/documentation

// TODO: REST 1 - Create URL
var components = URLComponents(string: "https://rickandmortyapi.com")!
components.path = "/api/character"
components.queryItems = [
    URLQueryItem(
        name: "page",
        value: String(2)
    )
]
let urlFromComponents = components.url!

let url = URL(string: "https://rickandmortyapi.com/api/character")! // Please, don't force unwrap in your projects

// TODO: REST 2 - Create URLRequest
var request = URLRequest(url: urlFromComponents)

// TODO: REST 3 - Update HTTP method (create enum for it)
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

request.httpMethod = HTTPMethod.get.rawValue // Get is also default method, you don't have to set it

// TODO: REST 4 - Show how to update headers
request.allHTTPHeaderFields?["Accept-Language"] = "en-US"

// TODO: REST 5 - URLSession call (print data)

// TODO: REST 6 - Handle status code (create enum for it)
enum StatusCode {
    case info
    case success
    case redirect
    case clientError(Int)
    case serverError(Int)
    case none
    
    var isValid: Bool {
        // https://fuckingifcaseletsyntax.com
        guard case .success = self else {
            return false
        }
        
        return true
    }
    
    init(response: URLResponse) {
        guard let response = response as? HTTPURLResponse else {
            self = .none
            return
        }
        
        switch response.statusCode {
        case 100 ..< 200:
            self = .info
        case 200 ..< 300:
            self = .success
        case 300 ..< 400:
            self = .redirect
        case 400 ..< 500:
            self = .clientError(response.statusCode)
        case 500 ..< 600:
            self = .serverError(response.statusCode)
        default:
            self = .none
        }
    }
}

// TODO: REST 7 - Create Decodable model
// https://app.quicktype.io

struct CharactersResult: Codable {
    let info: Info
    let results: [Result]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Result: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}

// TODO: REST 8 - Parse model

// TODO: REST 9 - Switch URL with URLComponents and add query parameters

// TODO: REST 10 - Show how to update body
struct REQRESCharacter: Codable {
    let name: String
    let job: String
}

let body = try JSONEncoder().encode(
    REQRESCharacter(
        name: "Jerry Smith",
        job: "unemployed"
    )
)

var reqResRequest = URLRequest(url: URL(string: "https://reqres.in/api/users")!)
reqResRequest.httpMethod = HTTPMethod.post.rawValue
reqResRequest.httpBody = body

// TODO: REST 11 - Post example

Task { () -> Void in
    do {
        let (data, response) = try await URLSession.shared.data(for: reqResRequest)
        
        let statusCode = StatusCode(response: response)
        
        guard statusCode.isValid else {
            return print("💔 Wrong status code", statusCode)
        }
        
        print(String(data: data, encoding: .utf8))
    } catch {
        print("💔 Error received", error)
    }
}


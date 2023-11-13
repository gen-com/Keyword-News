//
//  NaverOpenAPI+Request.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/08/21.
//

import Foundation

extension NaverOpenAPI {
    /// 네이버 오픈 API에 대한 요청 정보입니다.
    struct Request: Requestable {
        private var url: URL?
        private var httpHeader: [String: String]
        private var httpMethod: HTTPMethod
        private var data: Data?
        private var parameter: [String: String]
        
        init(path: String) throws {
            url = try Self.createURL(for: path)
            httpHeader = [:]
            httpMethod = .get
            parameter = [:]
        }
        
        func fetch(withSession session: URLSession) async throws -> ResponseProtocol {
            let urlRequest = try urlRequest()
            let (data, urlResponse) = try await session.data(for: urlRequest)
            guard let httpURLResponse = urlResponse as? HTTPURLResponse
            else { throw Error(status: .badURLResponse) }
            return Response((data, httpURLResponse))
        }
        
        private func urlRequest() throws -> URLRequest {
            guard let url = url
            else { throw Error(status: .badURL) }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.value
            httpHeader.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
            let queryItems = parameter.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlRequest.url?.append(queryItems: queryItems)
            urlRequest.httpBody = data
            return urlRequest
        }
        
        private static func createURL(for path: String) throws -> URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = NaverOpenAPI.scheme
            urlComponents.host = NaverOpenAPI.host
            urlComponents.path = path
            guard let url = urlComponents.url
            else { throw Error(status: .badURL) }
            return url
        }
        
        func httpMethod(_ method: HTTPMethod) -> Self {
            var copy = self
            copy.httpMethod = method
            return copy
        }
        
        func httpHeader(_ header: [String: String]) -> Self {
            var copy = self
            copy.httpHeader = header
            return copy
        }
        
        func data(_ data: some Encodable) throws -> Self {
            var copy = self
            copy.data = try JSONEncoder().encode(data)
            return copy
        }
        
        func parameter(_ parameter: some Encodable) throws -> Self {
            var copy = self
            copy.parameter = try parameter.stringDictionary()
            return copy
        }
    }
}

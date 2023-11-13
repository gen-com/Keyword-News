//
//  NaverOpenAPI+Response.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/08/23.
//

import Foundation

extension NaverOpenAPI {
    /// 네이버 오픈 API가 지정한 상태입니다.
    enum Status: Int {
        /// 성공.
        case success = 200
        /// 잘못된 요청.
        case badRequest = 400
        /// 인증 실패.
        case authenticationFail = 401
        /// 요청 실패.
        case requestFail = 403
        /// 잘못된 URL.
        case badURL = 404
        /// 잘못된 HTTP 메소드.
        case badHTTPMethod = 405
        /// 요청 가능 한도 초과.
        case exceedRequestLimit = 429
        /// 서버 내부 오류.
        case serverError = 500
        /// 잘못된 응답.
        case badURLResponse = 600
        /// 알 수 없는 오류.
        case unknown = -1
        
        init(code: Int) {
            if let status = Status(rawValue: code) {
                self = status
            } else {
                self = .unknown
            }
        }
    }
    
    /// 네이버 오픈 API의 응답에 대한 정보입니다.
    struct Response: ResponseProtocol {
        /// 요청을 통해 받은 응답을 입력으로 받습니다.
        private let input: Input
        
        init(_ input: Input) {
            self.input = input
        }
        
        /// 응답으로 유효한 값이 왔는지 검증합니다.
        func verifyResponse() throws -> Data {
            let status = Status(code: input.urlResponse.statusCode)
            switch status {
            case .success: return input.data
            default:
                var error = try JSONDecoder().decode(Error.self, from: input.data)
                error.status = status
                throw error
            }
        }
    }
}

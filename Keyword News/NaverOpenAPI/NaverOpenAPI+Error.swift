//
//  NaverOpenAPI+Error.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/08/24.
//

import Foundation

extension NaverOpenAPI {
    /// 네이버 오픈 API에서 발생할 수 있는 오류를 정보입니다.
    struct Error: Swift.Error, Codable {
        /// 오류에 대한 정보.
        let message: String
        /// 오류 코드.
        let code: String
        /// 응답 상태.
        var status: Status = .unknown
        
        enum CodingKeys: String, CodingKey {
            case message = "errorMessage"
            case code = "errorCode"
        }
        
        init(status: Status) {
            self.status = status
            code = ""
            switch status {
            case .badURL: message = Message.badURL
            case .badURLResponse: message = Message.badURLReponse
            default: message = ""
            }
        }
        
        private enum Message {
            static let badURL = "There's a problem generating the URL."
            static let badURLReponse = "There's a problem generating the URLResponse."
        }
    }
}

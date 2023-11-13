//
//  ResponseProtocol.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/08/23.
//

import Foundation

/// 응답을 해석하는 유형.
protocol ResponseProtocol {
    /// 요청의 응답 타입.
    typealias Input = (data: Data, urlResponse: HTTPURLResponse)
    
    /// 요청의 응답으로 인스턴스를 생성합니다.
    /// - Parameter input: 요청의 응답
    init(_ input: Input)
    /// 응답을 검증합니다.
    /// - Returns: 응답 데이터.
    func verifyResponse() throws -> Data
}

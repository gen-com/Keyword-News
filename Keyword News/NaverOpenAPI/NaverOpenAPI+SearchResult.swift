//
//  NaverOpenAPI+SearchResult.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 10/1/23.
//

import Foundation

extension NaverOpenAPI {
    /// 네이버 오픈 API의 뉴스 응답 데이터 모델입니다.
    struct SearchResult<Item>: SearchResultProtocol, Codable where Item: Codable {
        /// 요청 시각.
        var requestDate: String
        /// 총 검색 결과량.
        let totalResult: Int
        /// 받아온 결과값 시작 지점.
        let itemStartIndex: Int
        /// 받아온 결과값 표시량.
        let itemAmount: Int
        
        var lastSearchDate: Date? { try? requestDate.toDate(format: .naver) }
        var lastItemIndex: Int { itemStartIndex + itemAmount - 1 }
        var itemCapacity: Int { totalResult }
        var isUpdatable: Bool { false }
        /// 요청한 항목.
        let items: [Item]
        
        enum CodingKeys: String, CodingKey {
            case requestDate = "lastBuildDate"
            case totalResult = "total"
            case itemStartIndex = "start"
            case itemAmount = "display"
            case items
        }
    }
}

//
//  NewsSearchResultProtocol.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/16.
//

import Foundation

/// 검색 결과의 정보에 대한 유형.
protocol SearchResultProtocol<Item> {
    /// 검색 항목의 유형.
    associatedtype Item
    
    /// 마지막 검색 시각.
    var lastSearchDate: Date? { get }
    /// 검색 항목의 마지막 인덱스.
    var lastItemIndex: Int { get }
    /// 항목 용량.
    var itemCapacity: Int { get }
    /// 새로 불러올 수 있는 지 여부.
    var isUpdatable: Bool { get }
    /// 검색 항목.
    var items: [Item] { get }
}

//
//  NewsSearchResult.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/16.
//

import Foundation
import OrderedCollections

/// 뉴스 검색 결과를 표현하는 데이터 모델.
struct NewsSearchResult: SearchResultProtocol {
    var lastSearchDate: Date?
    var lastItemIndex: Int
    var itemCapacity: Int
    var isUpdatable: Bool
    var orderedNewsSet: OrderedSet<NewsWrapper>
    var items: [NewsProtocol] {
        orderedNewsSet.elements.map {
            switch $0 {
            case .content(let news): return news
            }
        }
    }
    
    static let maxCapacity = 100
    
    // MARK: - Initializer(s)
    
    init() {
        lastSearchDate = Date()
        lastItemIndex = 0
        itemCapacity = 0
        isUpdatable = false
        orderedNewsSet = []
    }
    
    init(_ naverSearchResult: NaverOpenAPI.NewsResponse) {
        lastSearchDate = naverSearchResult.lastSearchDate
        lastItemIndex = naverSearchResult.lastItemIndex
        itemCapacity = naverSearchResult.itemCapacity
        isUpdatable = naverSearchResult.isUpdatable
        orderedNewsSet = OrderedSet(naverSearchResult.items.map({ NewsWrapper.content($0) }))
    }
    
    // MARK: - Editing
    
    mutating func updateInfo(with searchResult: some SearchResultProtocol) {
        lastSearchDate = searchResult.lastSearchDate
        lastItemIndex = searchResult.lastItemIndex
        itemCapacity = min(searchResult.itemCapacity, Self.maxCapacity)
    }
}

//
//  NewsSearchResultContainer.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/26.
//

/// 키워드 검색을 통해 받아온 뉴스를 보관할 수 있는 자료구조 모델.
actor NewsSearchResultContainer: SearchResultContainable {
    /// 키워드와 뉴스를 페어로 두는 딕셔너리 자료구조.
    private var keywordNewsDictonary: [Keyword: NewsSearchResult]
    
    // MARK: - Initializer(s)
    
    /// 빈 키워드-뉴스 보관 자료구조를 생성합니다.
    init(keywords: [Keyword] = []) async {
        keywordNewsDictonary = [Keyword: NewsSearchResult]()
        keywords.forEach { keywordNewsDictonary[$0] = NewsSearchResult() }
    }
    
    // MARK: - SearchResultContainable Conformance
    
    func searchResult(for keyword: Keyword) throws -> any SearchResultProtocol<NewsProtocol> {
        return try newsSearchResult(for: keyword)
    }
    
    /// 딕셔너리에서 키워드에 대한 뉴스를 찾아 반환합니다.
    private func newsSearchResult(for keyword: Keyword) throws -> NewsSearchResult {
        guard let newsSearchResult = keywordNewsDictonary[keyword]
        else { throw Error.keywordNotFound(keyword) }
        return newsSearchResult
    }
    
    func append(_ searchResult: some SearchResultProtocol<NewsProtocol>, for keyword: Keyword) throws -> Int {
        var newsSearchResult = keywordNewsDictonary[keyword] ?? NewsSearchResult()
        newsSearchResult.updateInfo(with: searchResult)
        var notInsertedCount = 0
        for item in searchResult.items {
            if newsSearchResult.itemCapacity <= newsSearchResult.orderedNewsSet.count {
                keywordNewsDictonary[keyword] = newsSearchResult
                throw Error.reachMaxCapacity(newsSearchResult.itemCapacity)
            }
            let (inserted, _) = newsSearchResult.orderedNewsSet.append(NewsWrapper.content(item))
            notInsertedCount += inserted ? 0 : 1
        }
        newsSearchResult.isUpdatable = 0 < notInsertedCount
        keywordNewsDictonary[keyword] = newsSearchResult
        return notInsertedCount
    }
    
    func update(with searchResult: some SearchResultProtocol<NewsProtocol>, for keyword: Keyword) throws {
        var updatedSearchResult = NewsSearchResult()
        updatedSearchResult.updateInfo(with: searchResult)
        let previousSearchResult = try newsSearchResult(for: keyword)
        updatedSearchResult.orderedNewsSet.append(contentsOf: searchResult.items.map { NewsWrapper.content($0) })
        updatedSearchResult.orderedNewsSet.append(contentsOf: previousSearchResult.orderedNewsSet)
        keywordNewsDictonary[keyword] = updatedSearchResult
    }
    
    func removeSearchResult(for keyword: Keyword) throws {
        _ = try searchResult(for: keyword)
        keywordNewsDictonary.removeValue(forKey: keyword)
    }
    
    // MARK: - Error
    
    /// 키워드 뉴스 보관에 있어 발생할 수 있는 오류.
    enum Error: Swift.Error, CustomStringConvertible {
        /// 찾을 수 없는 키워드.
        case keywordNotFound(String)
        /// 최대 용량 초과.
        case reachMaxCapacity(Int)
        
        /// 요류 내용 설명.
        var description: String {
            switch self {
            case .keywordNotFound(let keyword):
                return "Keyword \"\(keyword)\" is not exists in keyword container."
            case .reachMaxCapacity(let capacity):
                return "The maximum capacity is \(capacity)."
            }
        }
    }
}

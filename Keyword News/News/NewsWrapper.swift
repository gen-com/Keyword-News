//
//  NewsWrapper.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/18.
//

/// 해시가 가능한 뉴스 프로토콜 구현 데이터 모델.
enum NewsWrapper: Hashable {
    /// 뉴스 내용.
    case content(any NewsProtocol)
    
    // MARK: - Hashable conformance
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .content(news):
            hasher.combine(news.url?.absoluteString)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.content(lhsNews), .content(rhsNews)):
            return lhsNews.url?.absoluteString == rhsNews.url?.absoluteString
        }
    }
}

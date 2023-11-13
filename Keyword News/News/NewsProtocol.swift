//
//  NewsProtocol.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/16.
//

import Foundation

/// 뉴스를 표현하는 유형.
protocol NewsProtocol {
    /// 뉴스 제목.
    var title: String { get }
    /// 뉴스 URL.
    var url: URL? { get }
    /// 뉴스 내용.
    var content: String { get }
    /// 뉴스 게시 날짜.
    var publishedDate: Date? { get }
}

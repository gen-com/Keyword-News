//
//  KeywordPersistable.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/25.
//

/// 저장이 가능한 유형.
///
/// 이 프로토콜을 채택하면 원하는 유형을 영구적으로 저장할 수 있습니다.
/// 저장할 ``Content``는 Codable 프로토콜을 준수해야 합니다.
///
/// 여러 스레드가 한 번에 접근해 연산을 수행할 경우 데이터 경쟁이 발생할 수 있어 Actor 유형을 활용해야 합니다.
protocol Persistable<Content>: Actor {
    /// 저장할 내용 유형.
    associatedtype Content: Codable
    
    /// 현재 데이터를 저장합니다.
    /// - Parameter content: 저장할 내용.
    func save(_ content: some Codable) throws
    /// 저장된 데이터를 불러옵니다.
    /// - Returns: 저장된 데이터.
    func load() throws -> Content
    /// 저장된 데이터를 초기화합니다.
    func reset() throws
}

//
//  HTTPHeader.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

enum HTTPHeader {
    enum HeaderField: String {
        case contentType = "Content-Type"
    }

    enum ContentType: String {
        case json = "application/json"
        case text = "text/html;charset=utf-8"
    }
}


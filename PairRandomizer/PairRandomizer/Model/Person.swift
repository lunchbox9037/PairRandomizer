//
//  Person.swift
//  PairRandomizer
//
//  Created by stanley phillips on 2/12/21.
//

import Foundation

class Person: Codable {
    let name: String

    init(name: String) {
        self.name = name
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name
    }
}

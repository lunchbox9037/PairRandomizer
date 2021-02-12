//
//  PersonController.swift
//  PairRandomizer
//
//  Created by stanley phillips on 2/12/21.
//

import Foundation

class PersonController {
    // MARK: - Properties
    static let shared = PersonController()
    var people: [Person] = []
    
    // MARK: - CRUD
    func addPerson(name: String) {
        people.append(Person(name: name))
        saveToPersistentStorage()
    }
    
    func delete(person: Person) {
        guard let index = people.firstIndex(of: person) else {return}
        people.remove(at: index)
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0].appendingPathComponent("PairRandomizer.json")
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: fileURL())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistentStorage() {
        do {
            let data = try Data(contentsOf: fileURL())
            people = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}//end class

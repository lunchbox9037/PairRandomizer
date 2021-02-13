//
//  PersonController.swift
//  PairRandomizer
//
//  Created by stanley phillips on 2/12/21.
//

import CoreData

class PersonController {
    // MARK: - Properties
    static let shared = PersonController()
    var people: [Person] = []
    var pairs: [[Person]] = []
    var groupLimit: Int = 2
    
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
    
    func randomize() {
        people = people.shuffled()
        createGroups()
    }
    
    func createGroups() {
        pairs = [[]]
        var groupCount = 0
        var nameIndex = 0
        var groupLimitIndex = 0
        
        if people.count % groupLimit == 0 {
            groupCount = people.count / groupLimit
        } else {
            groupCount = (people.count / groupLimit) + 1
        }
        
        for pairIndex in 0..<groupCount {
            pairs.append([])
            while groupLimitIndex < groupLimit && nameIndex < people.count {
                pairs[pairIndex].append(people[nameIndex])
                nameIndex += 1
                groupLimitIndex += 1
            }
            groupLimitIndex = 0
        }
        
        saveToPersistentStorage()
    }
    
    func clearGroups() {
        people = []
        createGroups()
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

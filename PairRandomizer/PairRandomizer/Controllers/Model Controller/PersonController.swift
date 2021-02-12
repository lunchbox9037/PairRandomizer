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
        pairs = [[]]
        var pairsCount = 0
        if people.count % 2 == 0 {
            pairsCount = people.count / 2
        } else {
            pairsCount = (people.count / 2) + 1
        }
        
        var i = 0
        var n = 0
        for _ in 0..<pairsCount {
            pairs.append([])
        }
        
        for p in 0..<pairsCount {
            while n < 2 && i < people.count {
                pairs[p].append(people[i])
                i += 1
                n += 1
            }
            n = 0
        }
        
        saveToPersistentStorage()
    }
    
    func reSectionWhenPersisting() {
        pairs = [[]]
        var pairsCount = 0
        if people.count % 2 == 0 {
            pairsCount = people.count / 2
        } else {
            pairsCount = (people.count / 2) + 1
        }
        
        var i = 0
        var n = 0
        for _ in 0..<pairsCount {
            pairs.append([])
        }
        
        for p in 0..<pairsCount {
            while n < 2 && i < people.count {
                pairs[p].append(people[i])
                i += 1
                n += 1
            }
            n = 0
        }
        
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

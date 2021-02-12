//
//  PairListTableViewController.swift
//  PairRandomizer
//
//  Created by stanley phillips on 2/12/21.
//

import UIKit

class PairListTableViewController: UITableViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.shared.loadFromPersistentStorage()
        PersonController.shared.reSectionWhenPersisting()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        //add a text field to the alert
        alert.addTextField { (_) in}
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addButton = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let personName = alert.textFields?[0].text, !personName.isEmpty else {return}
            PersonController.shared.addPerson(name: personName)
            PersonController.shared.randomize()
            self.tableView.reloadData()
        }
        
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        PersonController.shared.randomize()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return PersonController.shared.pairs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonController.shared.pairs[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        cell.textLabel?.text = PersonController.shared.pairs[indexPath.section][indexPath.row].name.capitalized
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = PersonController.shared.pairs[indexPath.section][indexPath.row]
            PersonController.shared.pairs[indexPath.section].remove(at: indexPath.row)
            PersonController.shared.delete(person: personToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}//end class

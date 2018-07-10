//
//  ViewController.swift
//  ToDoey
//
//  Created by Morten Albertsen on 10/07/2018.
//  Copyright © 2018 Morten Albertsen. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggs", "Fuck af"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var input = UITextField()
        //Laver vores alert popup
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        //Laver vores action knap, navnet på hvad knappen
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the Add Item Button on our UIALert
            if input.text! != "" {
                self.itemArray.append(input.text!)
                self.tableView.reloadData()
            }
        }
        //Tilføjer et tekstfelt til vores alert som user kan skrive i
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            input = alertTextField
        }
        
        //Tilføjer vores action knap til vores alert pooup
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}


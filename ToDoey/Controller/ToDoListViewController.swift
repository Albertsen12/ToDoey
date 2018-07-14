//
//  ViewController.swift
//  ToDoey
//
//  Created by Morten Albertsen on 10/07/2018.
//  Copyright © 2018 Morten Albertsen. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
        //Ternary operator
        //value = condition ? ValueTrue : ValueFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        // Linjen ovenover er det same som linjerne under
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
                let newItem = Item(context: self.context)
                newItem.title = input.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
                
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
    
    //MARK Model mani Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("lol")
        }
        self.tableView.reloadData()
    }
    
    // = Item.fetchRequest() betyder at hvis den ikke får en parameter med
    // når metoden kaldes, benytter den en default værdi som er Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let aditionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    

}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Morten Albertsen on 13/07/2018.
//  Copyright © 2018 Morten Albertsen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.row].name ?? "No Categories added yet"

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Nil coalescing Operator. Hvis categories er nil så sætter den bare værdien til 1
        return categories?.count ?? 1
    }
    
    // MARK: - Data Manipulation methods

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var input = UITextField()
        //Laver vores alert popup
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        //Laver vores action knap, navnet på hvad knappen
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What will happen once the user clicks the Add Item Button on our UIALert
            if input.text! != "" {
                let newCategory = Category()
                newCategory.name = input.text!
                
                self.save(category: newCategory)
                
                self.tableView.reloadData()
            }
        }
        //Tilføjer et tekstfelt til vores alert som user kan skrive i
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            input = alertTextField
        }
        
        //Tilføjer vores action knap til vores alert pooup
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("lol")
        }
        self.tableView.reloadData()
    }
    

    func loadCategorys() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationWC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationWC.selectedCategory = categories?[indexPath.row]
        }
    }
}

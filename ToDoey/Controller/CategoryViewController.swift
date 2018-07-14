//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Morten Albertsen on 13/07/2018.
//  Copyright © 2018 Morten Albertsen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = category.name

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
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
                let newCategory = Category(context: self.context)
                newCategory.name = input.text!
                self.categoryArray.append(newCategory)
                
                self.saveItems()
                
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
    func loadCategorys(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationWC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationWC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}

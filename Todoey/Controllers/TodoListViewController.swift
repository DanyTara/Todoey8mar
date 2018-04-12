//
//  ViewController.swift
//  Todoey
//
//  Created by Daniela Tarantini on 08/03/18.
//  Copyright © 2018 Daniela Tarantini. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
     //creo una nuova variabile -categoriaSelezionata- e con il didSet>che mi permette di far succedere qualcosa appena la variabile ha un valore. Questo significa che quando scatta il LOAD noi abbiamo già un valore per quella selezionata. Altrimenti crash
    var selectedCategory : Category? {
        didSet{
        loadItems()
        }
    }


   override func viewDidLoad() {
        super.viewDidLoad()
    
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    
    }
    
    // Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        // questa riga di codice sostituisce if done del checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
  
    }
    
    // Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
 
        tableView.reloadData()
        
        // print(itemArray[indexPath.row])
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        
        // la riga sopra sostiutuisce tutto il seguente if perché =! è l'opposto
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
       
        
        // per evitare di far apparire la riga grigia quando viene selezionata
        tableView.deselectRow(at: indexPath, animated: true)
  
}
    
    // Add nuovi elementi
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // creo una variabile locale per poi poterci mettere il alertTextField
        var textField = UITextField()
        
        // aggiungo un UIAlert di tipo .Alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        // creo un azione che accadrà quando l'utente clicca su UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // cosa succede quando un utente clicca sul Add Button sul UIAlert
            // siccome siamo all'interno di una closure dobbiamo mettere il self
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
            //aggiungo un campo di testo in UIAlert
            alert.addTextField { (alertTextField) in
            //questo è il placeholder dove dico all'utente cosa deve fare
            alertTextField.placeholder = "Create new item"
            //metto nella var locale il TextField che si genera quando si scrive
            textField = alertTextField
        }
        // aggiungo l'azione creata e presento UIAlert
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
   // questo diventa il READ di CRUD
        func loadItems() {

            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
//            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//            if let additionalPredicate = predicate {
//                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//            } else {
//                request.predicate = categoryPredicate
//            }
//
//            let compaundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//            request.predicate = compaundPredicate
//
//        do {
//        itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching data from context \(error)")
//        }
        tableView.reloadData()
    }

}
//MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()


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



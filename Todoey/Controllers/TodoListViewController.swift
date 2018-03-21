//
//  ViewController.swift
//  Todoey
//
//  Created by Daniela Tarantini on 08/03/18.
//  Copyright © 2018 Daniela Tarantini. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
     //creo una nuova variabile -categoriaSelezionata- e con il didSet>che mi permette di far succedere qualcosa appena la variabile ha un valore. Questo significa che quando scatta il LOAD noi abbiamo già un valore per quella selezionata. Altrimenti crash
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
   override func viewDidLoad() {
        super.viewDidLoad()
    
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    
    }
    
    // Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // questa riga di codice sostituisce if done del checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
  
    }
    
    // Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
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
            // quindi E' QUI che devo mettere il nuovo elemento nell'array perché l'azione si completa QUI e non nell'Alert
            // per adesso mettiamo !, poi faremo meglio
            // siccome siamo all'interno di una closure dobbiamo mettere il self
            
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // ricarico i dati della tabella altrimenti i nuovi elementi sono nell'array ma non appaiono nelle celle
        
        self.tableView.reloadData()
        
    }
    
   // questo diventa il READ di CRUD
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compaundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compaundPredicate
        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
//MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
            let request : NSFetchRequest<Item> = Item.fetchRequest()
        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
        
            let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
        
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
            loadItems(with: request, predicate: predicate)
        
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



//
//  ViewController.swift
//  Todoey
//
//  Created by Daniela Tarantini on 08/03/18.
//  Copyright © 2018 Daniela Tarantini. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destry Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    // Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // qui si compilano le celle con gli elementi dell'array
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
  
    }
    
    // Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(itemArray[indexPath.row])
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
            // ricarico i dati della tabella altrimenti i nuovi elementi sono nell'array ma non appaiono nelle celle
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
    
}


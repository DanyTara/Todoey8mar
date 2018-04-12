//
//  Item.swift
//  Todoey
//
//  Created by Daniela Tarantini on 22/03/18.
//  Copyright © 2018 Daniela Tarantini. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
   



    
    
    //creo la relationship con Category. La var è di tipo LinkingObjects che è un contenitore auto-aggiornato. Rappresenta 0 o piu oggetti linkati al loro modello possessore  attraverso una relazione di proprietà. Bisogna inizializzare il linking object con un type e proprietà. Il type sarà Category, ma devo mettere il self perché category è una solo classe e io ho bisogno un .type. La proprietà sarà la let items (ovvero la relationship) dichiarata in Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

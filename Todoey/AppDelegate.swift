//
//  AppDelegate.swift
//  Todoey
//
//  Created by Daniela Tarantini on 08/03/18.
//  Copyright © 2018 Daniela Tarantini. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print per avere stampato nel debug il percorso di dove è il database Realm con i miei valori
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
       
        //creo nuova costante di Realm - con il try perchè è un throw.
       
        do {
            _ = try Realm()
        
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        
        
        return true
    }

 

}


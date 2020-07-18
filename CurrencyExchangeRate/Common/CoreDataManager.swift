//
//  CoreDataManager.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 18/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreManager {
    static let shared = CoreManager()

    private init(){}
    
    func saveCurrencyListData(currencies: [String : String]){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       let managedContext = appDelegate.persistentContainer.viewContext
       
       for (key, value) in currencies {
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: currencyLocalData)
           let predicate = NSPredicate(format: "currencyCode == %ld", key)
           fetchRequest.predicate = predicate
           do {
               let result = try managedContext.fetch(fetchRequest)
               if result.count == 0{

                   let userEntity = NSEntityDescription.entity(forEntityName: currencyLocalData, in: managedContext)!
                   
                   let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                   user.setValue(key , forKeyPath: "currencyCode")
                   user.setValue(value, forKeyPath: "currencyCountry")
                   
                   do {
                       try managedContext.save()
                   } catch let error as NSError {
                       print("Could not save. \(error), \(error.userInfo)")
                   }
               }
           } catch {
               print("Failed")
           }
       }
   }
    
    
    func saveExchangeRateData(exchangeRate: [String : Double]){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for (key, value) in exchangeRate {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: exchangeRateLocalData)
            let predicate = NSPredicate(format: "exchangeRateCode == %ld", key)
            fetchRequest.predicate = predicate
            do {
                let result = try managedContext.fetch(fetchRequest)
                
                if result.count == 0{
                    let userEntity = NSEntityDescription.entity(forEntityName: exchangeRateLocalData, in: managedContext)!
                    
                    let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                    user.setValue(key , forKeyPath: "exchangeRateCode")
                    user.setValue(value, forKeyPath: "exchangeRateValue")
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            } catch {
                print("Failed")
            }
        }
    }
}

//
//  DataPresistenceManeger.swift
//  NetFlix
//
//  Created by Ahmed Fathi on 11/09/2023.
//
import UIKit
import Foundation
import CoreData



class DataPresistenceManager {
    
    static let share = DataPresistenceManager()
    
    
    func downloadTitleWith(model: Title , complation: @escaping (Result<Void, Error>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.id = Int64(Int(model.id))
        item.media_type = model.media_type
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = Double(model.vote_average!)
        item.vote_count = Int64(Int(model.vote_count!))
        
        do{
            try  context.save()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    func fetchinDataFromDataBase(completion: @escaping (Result<[TitleItem] , Error >) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
           let titles =  try context.fetch(request)
            completion(.success(titles))
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

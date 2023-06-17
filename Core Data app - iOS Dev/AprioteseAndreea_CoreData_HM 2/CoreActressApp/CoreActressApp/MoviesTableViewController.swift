//
//  MoviesTableViewController.swift
//  CoreActressApp
//
//  Created by Andreea Apriotese on 10.05.2023.
//

import UIKit
import CoreData
class MoviesTableViewController: UITableViewController {
    
    var actress: NSManagedObject!
    var movies: [NSManagedObject] = []
    var moviexPerson: [NSManagedObject] = []
    var selectedItems: [Bool] = []
    var blueItems: [Bool] = []
    var selectedItemsCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
        
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
      let fetchRequestMoviexPerson = NSFetchRequest<NSManagedObject>(entityName: "MoviexPerson")
        
      do {
        self.movies = try managedContext.fetch(fetchRequest)
        self.moviexPerson = try managedContext.fetch(fetchRequestMoviexPerson)
          
        self.tableView.reloadData()
          
        self.selectedItems = Array(repeating: false, count: movies.count)
        self.blueItems = Array(repeating: false, count: movies.count)

          
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = movies[indexPath.row]
        cell.textLabel?.text =
          person.value(forKeyPath: "name") as? String
        cell.detailTextLabel?.text =
          person.value(forKeyPath: "year") as? String

        
        for moviexPerson in self.moviexPerson {
            let movie = moviexPerson.value(forKey: "movie") as? Movie
            let actress = moviexPerson.value(forKey: "actress") as? Person
                
            if(movie!.name == self.movies[indexPath.row].value(forKeyPath: "name") as? String && actress!.name == self.actress.value(forKeyPath: "name") as? String){
                blueItems[indexPath.row] = true;
                cell.backgroundColor = UIColor.systemBlue
            }
           
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItems[indexPath.row] = true
        selectedItemsCounter += 1
        let newButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        self.navigationItem.rightBarButtonItem = newButton
        
    }
    
    @objc func saveButtonAction() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "MoviexPerson",
                                     in: managedContext)!
      
        
        for (index, selections) in self.selectedItems.enumerated() {
            let indexPath = IndexPath(row: index, section:1)
            if(selections == true && self.blueItems[index] != true){
    
                let moviexPerson = NSManagedObject(entity: entity, insertInto: managedContext)
                moviexPerson.setValue(self.actress, forKey: "actress")
                moviexPerson.setValue(self.movies[index], forKey: "movie")
                do {
                    try managedContext.save()
                    print("Data saved successfully.")
                  
                } catch let error as NSError {
                    print("Could not save data. Error: \(error), \(error.userInfo)")
                }
            } else if(selections == true && self.blueItems[index] == true) {
                let deletedIndex = self.getIndex(forName: self.movies[index])!
                if(deletedIndex != -1){
                    managedContext.delete(self.moviexPerson[deletedIndex]);
                    do {
                        print("deleted")
                        self.moviexPerson.remove(at: deletedIndex)
                        try managedContext.save()

                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
             
                
            }
            
        }
       
        self.navigationItem.rightBarButtonItem = nil
       
    }
    
    func getIndex(forName movie: NSObject) -> Int? {
        for (index, moviexPerson) in self.moviexPerson.enumerated() {
            let currentMovie = moviexPerson.value(forKey: "movie") as? Movie
            let currentActress = moviexPerson.value(forKey: "actress") as? Person
                
            if(currentMovie!.name == movie.value(forKeyPath: "name") as? String && currentActress!.name == self.actress.value(forKeyPath: "name") as? String){
                return index
            }
           
        }
        return -1;
    }
    
    @objc func deleteFunction() {
        // Perform the actions you want when the "Save" button is tapped
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedItems[indexPath.row] = false
        selectedItemsCounter -= 1
        if(selectedItemsCounter==0){
            let newButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(deleteFunction))
            self.navigationItem.rightBarButtonItem = newButton
        }
    }
}

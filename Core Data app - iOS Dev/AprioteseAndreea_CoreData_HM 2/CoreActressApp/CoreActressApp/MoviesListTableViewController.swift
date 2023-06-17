//
//  MoviesListTableViewController.swift
//  CoreActressApp
//
//  Created by Andreea Apriotese on 14.05.2023.
//

import UIKit
import CoreData

class MoviesListTableViewController: UITableViewController {

    var movies: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Movie")
      
      //3
      do {
        self.movies = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    @IBAction func addMovie(_ sender: Any) {
        let alert = UIAlertController(title: "New movie",
                                      message: "Add a new movie",
                                      preferredStyle: .alert)
        
          let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            self.save(name: (alert.textFields?[0].text)!, year:(alert.textFields?[1].text)!)
            self.tableView.reloadData()
          }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
              alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                  textField.placeholder = "Name"

              })
          
              alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                  textField.placeholder = "Year"

              })
         
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String, year: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext =
        appDelegate.persistentContainer.viewContext
      let entity =
        NSEntityDescription.entity(forEntityName: "Movie",
                                   in: managedContext)!
      
      let movie = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      movie.setValue(name, forKeyPath: "name")
      movie.setValue(year, forKeyPath: "year")

      do {
        try managedContext.save()
        movies.append(movie)
        
       
        //selectedItems += [false]
        //blueItems += [false]
          
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text =
          movie.value(forKeyPath: "name") as? String
        cell.detailTextLabel?.text =
          movie.value(forKeyPath: "year") as? String
        return cell
    }
    
   
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

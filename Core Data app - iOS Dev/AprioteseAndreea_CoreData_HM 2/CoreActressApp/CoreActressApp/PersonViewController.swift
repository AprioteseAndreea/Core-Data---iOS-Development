//
//  PersonViewController.swift
//  CoreActressApp
//
//  Created by Andreea Apriotese on 08.05.2023.
//

import UIKit
import CoreData

class PersonViewController: UIViewController {
    
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    
    var actress: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFiled.text = actress.value(forKeyPath: "name") as? String
        ageTextField.text = actress.value(forKeyPath: "age") as? String
        nationalityTextField.text = actress.value(forKeyPath: "nationality") as? String
    }
    
    @IBAction func updatePerson(_ sender: Any) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        actress.setValue(nameTextFiled.text, forKeyPath:"name")
        actress.setValue(ageTextField.text, forKeyPath:"age")
        actress.setValue(nationalityTextField.text, forKeyPath:"nationality")
        
          do {
            try managedContext.save()
            self.showToast(message: "The actress was successfully updated!", font: .systemFont(ofSize: 12.0))

          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-120, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    @IBAction func deleteName(_ sender: UIBarButtonItem) {
      
      let alert = UIAlertController(title: "Are you sure you want to delete this person?",
                                    message: "",
                                    preferredStyle: .alert)
      
        let deleteAction = UIAlertAction(title: "Delete", style: .default)
        {
          [unowned self] action in
            self.delete(name: (actress.value(forKeyPath: "name") as? String)!)
        }
          
      
    
      let cancelAction = UIAlertAction(title: "Cancel",
                                       style: .cancel)
      
      
      alert.addAction(deleteAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true)
    }
    
    func delete(name: String) {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }

      let managedContext =
        appDelegate.persistentContainer.viewContext
      
        managedContext.delete(actress);
     
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detailsVC = segue.destination as! MoviesTableViewController
            detailsVC.actress =  actress
          
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

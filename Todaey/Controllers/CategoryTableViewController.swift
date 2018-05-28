//
//  CategoryTableViewController.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //not needed anymore
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source methods

    //Set number of rows you needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count //that many number of rows (cells) in section (view)
    }
    
    //get the cell, modify it as you want, send it back
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name //every cell has label, current row of current indexpath
        
        return cell //reuse prototype cell, this cell be returned and shown as row
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
     // MARK: - Add new items (Navigation)
     
     /* // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //changed the sender from any to UIBarButtonItem
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // has scope everywhere locally in here
        var textField = UITextField() //use to extend scope, read and useing
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            
            //trailing closure
            (action) in
            
            //what to do when user clicks the add item button on our UIAlert
            print("Success")
            
            print(textField.text!)
            
            //can use Appdelegate, but instead use shared, inside it is something called delegate
            //it is called app delegate
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            //self, because we are in closure
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
            self.tableView.reloadData()
        }
        
        //add textfield to the alert
        alert.addTextField {
            //trailing closure
            (alertTextField) in
            alertTextField.placeholder = "Create new category"
            //not going to show anythign because shown executed when this created, not on click add item of alert box
            print(alertTextField.text!) //force unwrap, because we know it will always have value
            textField = alertTextField //extending scope of this textfield
            print("now")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView delegate Methods
    
    
    // MARK: - Supporting Data Manipulation Methods
    //set array of ..
    //create contet, create load from data, add new items, save item button to save
    //setup categoryview same as the items
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving conext: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
}

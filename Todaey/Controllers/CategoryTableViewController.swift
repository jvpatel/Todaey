//
//  CategoryTableViewController.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    //try! means we know there's possibilty, but ignore we know it will never fail
    let realm = try! Realm()
    var categoryArray : Results<Category>? //changed the type because better to change type than casting many <> means unwrap
    
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
        
        //will throw error, if loading categories failed
        
        // 'categoryArray?.count' can be nil, neil-coalescing operator, we are saying: get count of categories if it is not nil, if nil then that entire will be nil
        return categoryArray?.count ?? 1 //that many number of rows (cells) in section (view)
    }
    
    //get the cell, modify it as you want, send it back
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //cat[] changed to cat?[] meaning get value only if it is not nil
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added" //every cell has label, current row of current indexpath
        
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
    
    // MARK: - TableView delegate Methods
    
    //when category selected, take to the corresponding items view, basically perform segue when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //before we perform segue, we have to load itemsArray to have only items related to this category
    //so, prepare for segue, this method called before segue is executed, before above method is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController //hold reference of the landing controller
        
        //grab category of selected cell, possibilty that no row is selected, but never possible because we segue when row selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
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
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            //self, because we are in closure
            //not needed because category list of realm is auto-updating, it will update database by itself, and automanage for tracking
            //self.categoryArray.append(newCategory)
            
            self.saveCategories(category: newCategory)
            
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
    
    // MARK: - Supporting Data Manipulation Methods
    //set array of ..
    //create contet, create load from data, add new items, save item button to save
    //setup categoryview same as the items
    
    func saveCategories(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving conext: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        //loads up all the catgories "realm.object" is list or some other datatype
        //tought to cast, better to change type of category to keep it go faster
        //it will auto-update our categories
        categoryArray = realm.objects(Category.self)
        
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

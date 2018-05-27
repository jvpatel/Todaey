//
//  ViewController.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy DEMOGORGON"] //TECT FOR CELL1, CELL2, CELL3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Tableview DataSource Methods
    // Display cell and Define number if cells
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count //that many number of rows (cells) in section (view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create reusable cell
        //code sense, makes you know what they mean V: from iboutlet-TableView, L-local from this method
        //they both refer same thing, "ToDoItemCell" is the identifier we gave upon adding TableViewController in story board, which then gave warning (1)
        // We got cell dequeud
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row] //every cell has label, current row of current indexpath
        return cell //reuse prototype cell, this cell be returned and shown as row
    }

    //MARK - TableView and Delegate Methods
    // Click cell listening, and TableViewDelegate
    
    //check to see if the row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row) //tells which row was selected
        print(itemArray[indexPath.row])
        
        //cell at this indexpath, will have accessory, set that
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //shows gray then disappears background
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        // has scope everywhere locally in here
        var textField = UITextField() //use to extend scope, read and useing
        
        let alert = UIAlertController(title: "Add New Todaey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            //trailing closure
            (action) in
            //what to do when user clicks the add item button on our UIAlert
            print("Success")
            print(textField.text!)
            
            //self, because we are in closure
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        //add tectfield to the alert
        alert.addTextField {
            //trailing closure
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //not going to show anythign because shown executed when this created, not on click add item of alert box
            print(alertTextField.text!) //force unwrap, because we know it will always have value
            textField = alertTextField //extending scope of this textfield
            print("now")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


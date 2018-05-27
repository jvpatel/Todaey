//
//  ViewController.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]() //TECT FOR CELL1, CELL2, CELL3
    
    //gets saved in plist file - that's why we need key-value
    //find path of default save file: need (filepath of sandbox of apprun, id of simulator, and id of sandbox that run our app
    let defaults = UserDefaults.standard //interface to userdefault db, store key values persistently when app launches
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demon"
        itemArray.append(newItem3)
        
        //set items array only if default has data saved, else app crashes
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
            
        }
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
        //solution: use model or dictionary: model is better to solve this check issue
        
        //this goes alway bottom and comes back with resuing cell, but come with checked because first one was
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //we didn't use below one: we checked, then scroll down scroll back up again, we get brand new cell with this message, so lost checked
        //let cell1 = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title //every cell has label, current row of current indexpath
        cell.accessoryType = (item.done) ? .checkmark : .none
        
//        if item.done == true {
//            //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark //this one didn't do check mark, may because cell was destroyed because we were reloading
//            cell.accessoryType = .checkmark //this tells that thhis cell is created, set property of this cell as it will be active
//        } else {
//            //tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            cell.accessoryType = .none
//        }
        
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
        //say you can have only 8 cells reusable in a tableview, check 1st one, and the 9th one will be checked automatically
        //if we uncheck 9th one, then 1st one also unchecked because table-view cell re-used
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this solves the check issue, and reusable of cell
        
        tableView.reloadData() //refresh after updating done, forces to call "cellForRowAt" method method called for every single cell in tableview visibility
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //self, because we are in closure
            self.itemArray.append(newItem)
            
            //save in user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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


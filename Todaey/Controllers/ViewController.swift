//
//  ViewController.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]() //TECT FOR CELL1, CELL2, CELL3
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //gets saved in plist file - that's why we need key-value
    //find path of default save file: need (filepath of sandbox of apprun, id of simulator, and id of sandbox that run our app
    //let defaults = UserDefaults.standard //interface to userdefault db, store key values persistently when app launches
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //path to the documents folder, FileManager provides interface to filesystem, default filemanger is singleton
        //organized by directory and domain-mask (user home directory, where we'll save sustomer's data associated with this path)
        //create our own plist file
        print(dataFilePath)
        
        //searchBar.Delgate = self either do in code, or control-drag to the yellow icon, and select outlet as delegate
        
        loadItems()
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demon"
//        itemArray.append(newItem3)
        
        //set items array only if default has data saved, else app crashes
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview DataSource Methods
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

    //also called pragma mark
    //MARK: - TableView and Delegate Methods
    // Click cell listening, and TableViewDelegate
    
    //check to see if the row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row) //tells which row was selected
        print(itemArray[indexPath.row])
        
        //cell at this indexpath, will have accessory, set that
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //say you can have only 8 cells reusable in a tableview, check 1st one, and the 9th one will be checked automatically
        //if we uncheck 9th one, then 1st one also unchecked because table-view cell re-used
        
        //use to update, but still have to call save() after it to commit changes
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //context.delete(itemArray[indexPath.row]) - call this one first otherwise it will delete something that you didn't want to delete
        //itemArray.remove(at: indexPath.row) //deletes only from our array
        //our app behaves stragely, it leaves empty spot at the place that was delete, so empty top 2 rows then listing starts
        
        
        //toggle item-only reflected in item array
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this solves the check issue, and reusable of cell
        saveItems()
        
        
        tableView.reloadData() //refresh after updating done, forces to call "cellForRowAt" method method called for every single cell in tableview visibility
        
        tableView.deselectRow(at: indexPath, animated: true) //shows gray then disappears background
    }
    
    //MARK: - Add New Items
    
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
            
            //can use Appdelegate, but instead use shared, inside it is something called delegate
            //it is called app delegate
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            //self, because we are in closure
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //save in user defaults
            //trying to save array of our own custom object, it is rejecting
            ////attempting to set non property using UserDefaults ->
            //we are mis-using user default. so need better solution to persist data than using default
            //user default doesn't work so great, don't use it for anything other small stuff like volume on/off. Takes only standard stuff, not our custom part
            //Solution: use sandbox to persist data. All apps in thier own sandbox, each have own folders to save retreive data
            //all of this data is what we sync with itunes/icloud, don't affect ios operating system, iphone prevents from making changes to operating system, only way to bypass is jailbreak, that's why iphone best secured
            //
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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
    
    //MARK: - Supporting methods
    
    //create before copy paste
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            try context.save()
        } catch {
            print("Error saving conext: \(error)")
        }
    }
   
    //with is external parameter, request is internal parameter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            //will fetch many number of items
            //let request : NSFetchRequest<Item> = Item.fetchRequest()
            itemArray = try context.fetch(request) //we know it will be array of items
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
}

//MARK: - Search bar methods

//helps to split functionality with all of this implementation, because overtime they will increase
//MVC controllers increase very long, so better to modular well. So separate, needed core functionality of application from addons like search
//we are extending functionality by search
extension ToDoListViewController: UISearchBarDelegate {
    
    //when user clicks on search, this method wil be called
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        print(searchBar.text!)
        
        //used to query, it is a part of foundation, [cd] for dicratic, like bar in the top, or colon in the top of letters
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
        
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
        
        //do not copy paste, and repeat code, create method
//        do {
//            itemArray = try context.fetch(request) //we know it will be array of items
//        }
//        catch {
//            print("Error fetching data: \(error)")
//        }
//
//        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //called all time text changes
        
        //when entire text is cleared, show all items, our keyboard should go away not stay there
        if searchBar.text?.count == 0 {
            loadItems()
            
            //determines who'll have the priority, which process, manages, assign this project to different thread
            //update your UI in main thread, keyboard goes away, because this code is ran in foreground
            DispatchQueue.main.async {
                
                //remove keyboard, it shouldn't be selected, and keyboard should go away
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//
//  ViewController.swift
//  Todaey
//
//  Created by Jay on 5/27/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var selectedCategory : Category? {
        //executed when the value of this variable is set, when set loadup itemsArray
        didSet {
            loadItems()
        }
    }
    
    var toDoItems: Results<Item>? //TECT FOR CELL1, CELL2, CELL3
    
    //gets saved in plist file - that's why we need key-value
    //find path of default save file: need (filepath of sandbox of apprun, id of simulator, and id of sandbox that run our app
    //let defaults = UserDefaults.standard //interface to userdefault db, store key values persistently when app launches
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        //can't do here - use viewwillappear
//        if let colorHex = selectedCategory?.color {
//            //do this only if navigationcontroller is not null, so use guard
//
//            guard let navBar = navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex) else {
//                //app crashes here, we know vie loaded, but currrent controller isn't loaded into navigation controller, because view loaded but not yet inserted in navigation controller, may be not in navigation stack, this method called before navigation property is updated
//                //we can catch this ones in testing, while user don't know what it is
//                fatalError("Navigation controller does not exist")
//            }
//        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //path to the documents folder, FileManager provides interface to filesystem, default filemanger is singleton
        //organized by directory and domain-mask (user home directory, where we'll save sustomer's data associated with this path)
        //create our own plist file
        //print(dataFilePath!)
        
        //searchBar.Delgate = self either do in code, or control-drag to the yellow icon, and select outlet as delegate
        
        //loadItems() - not needed anymore
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

    //executed right before the view will show up on the screen, and after the navigation stack establist, and after viewdid is completed, this is different life cycle point
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        //changed if let -> guard, and we are not expecting this to happen
        guard let colorHex = selectedCategory?.color else { fatalError() }
            //do this only if navigationcontroller is not null, so use guard
            
        //this navigation controller controls, sets title of this view as categoryname
        title = selectedCategory?.name
            
        //let navBarColor = FlatWhite() - just to test contrast color
        
        //changed if let -> guard let to avoif 'if let' pyramid
        //not expecting this to happen, so guard against it
        guard let navBarColor =  UIColor(hexString: colorHex) else { fatalError() }
                
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        //nasattr. is like enum, large because that's what we use,
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.tintColor = navBarColor
        
        
    }
    
    //called just before the view will disapper from UI, just before the view will be removed from the stack
    //used to remove settings of this items view, so that category view won't have this color in nav bar
    override func viewWillDisappear(_ animated: Bool) {
        
        //if not valid hex, then it will be nil, we guard against it, and fatal error thrown
        guard let originalColor = UIColor(hexString: "1D9BF6") else {
            fatalError()
        }
        
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview DataSource Methods
    // Display cell and Define number if cells
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1 //that many number of rows (cells) in section (view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create reusable cell
        //code sense, makes you know what they mean V: from iboutlet-TableView, L-local from this method
        //they both refer same thing, "ToDoItemCell" is the identifier we gave upon adding TableViewController in story board, which then gave warning (1)
        // We got cell dequeud
        //solution: use model or dictionary: model is better to solve this check issue
        
        //this goes alway bottom and comes back with resuing cell, but come with checked because first one was
        //not needed, done by super class
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //we didn't use below one: we checked, then scroll down scroll back up again, we get brand new cell with this message, so lost checked
        //let cell1 = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        //get the swipe cell from superclass, we are giving our tableview to the superclass, which will make it swipe cell, and pass it back to us here
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title //every cell has label, current row of current indexpath
            cell.accessoryType = (item.done) ? .checkmark : .none
            
            //FlatSkyBlue: has white text color, try FlatWhite-> it will have black text color
            //if let color = UIColor(hexString: selectedCategory!.color).darken(byPercentage:
            //selected category safe to unwrap, make it optional chaining for UIcolor, we added '?' it for optional chaining didn't existed
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                //darken depending on current row number and total number of items, we know it will be never null here
                //CGFloat(indexPath.row/toDoItems!.count)
                CGFloat(indexPath.row)/CGFloat(toDoItems!.count)
                ) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //print("version 1: \(CGFloat(indexPath.row/toDoItems!.count))") //o.o (whole number/wholenumber=wholenumber, and wholenumber is what gets converted into float
            //print("version 2: \(CGFloat(indexPath.row)/CGFloat(toDoItems!.count))") //0/333
        } else {
            cell.textLabel?.text = "No items added"
        }
        
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
        //print(toDoItems?[indexPath.row]??"")
        
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
//        toDoItems?[indexPath.row].done = !((toDoItems?[indexPath.row].done))! //this solves the check issue, and reusable of cell
//        saveItems()
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    //realm.delete(item) //this is to know how to delete
                    item.done = !item.done //this will update database record
                }
            }
            catch {
                print("Error saving done status: \(error)")
            }
        }
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        //realm.add(newItem) - there's nothing to add here, we added to categories, that's it, realm already tracked and added by itself
                    }
                }
                catch {
                    print("Error saving data: \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
            //save in user defaults
            //trying to save array of our own custom object, it is rejecting
            ////attempting to set non property using UserDefaults ->
            //we are mis-using user default. so need better solution to persist data than using default
            //user default doesn't work so great, don't use it for anything other small stuff like volume on/off. Takes only standard stuff, not our custom part
            //Solution: use sandbox to persist data. All apps in thier own sandbox, each have own folders to save retreive data
            //all of this data is what we sync with itunes/icloud, don't affect ios operating system, iphone prevents from making changes to operating system, only way to bypass is jailbreak, that's why iphone best secured
            //
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
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
    
    // MARK: - Swipe Methods
    
    //delete method from swipe, we will override here, and it should delete as expected
    override func updateModel(at indexPath: IndexPath) {
        //if don't use below line, than super class method is not executed, so you won't get print
        //super.updateModel(at: indexPath)
        
        //flow: deletion - triggers delegate method "edit actions for row at" in supperclass,
        // it has closure to call updateModel-Indexpath, that calls updateModel() of super, but it's overridden by categoryclass, so it will execute category class update method. to execute updatemodel of super, this category method has to call by super.updatemodel
        
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    //delete category
                    self.realm.delete(itemForDeletion)
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - Supporting methods
    
    //create before copy paste
//    func saveItems(){
//        //let encoder = PropertyListEncoder()
//
//        do {
//            try realm.write {
//                //realm.add(Item)
//            }
//        } catch {
//            print("Error saving conext: \(error)")
//        }
//
//        tableView.reloadData()
//    }
   
    //with is external parameter, request is internal parameter
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //needed because it didn't refresh grid after search
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

//helps to split functionality with all of this implementation, because overtime they will increase
//MVC controllers increase very long, so better to modular well. So separate, needed core functionality of application from addons like search
//we are extending functionality by search
extension ToDoListViewController: UISearchBarDelegate {

    //when user clicks on search, this method wil be called
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //realm provides filter that takes in nspredicate
//        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "title", ascending: true)
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: false)
        //no need to load, because we already loaded
        
        tableView.reloadData()
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

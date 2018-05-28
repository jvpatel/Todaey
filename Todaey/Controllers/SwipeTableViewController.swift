//
//  SwipeTableViewController.swift
//  Todaey
//
//  Created by Jay on 5/28/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
    }

    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //remove all swipe stuff
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //cat[] changed to cat?[] meaning get value only if it is not nil - to be implemented in front-end UIClass not in this class, because this will be super class
        //cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added" //every cell has label, current row of current indexpath
        
        //remove all swipe stuff
        cell.delegate = self
        
        return cell //reuse prototype cell, this cell be returned and shown as row
    }
    
    // MARK: - SwipeTableViewCellDelegate methods
    
    //handles when user swipes on cell, orientation from right
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // has a closure, of what to do when swiped
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("delete stuff")
            
            self.updateModel(at: indexPath)
            
            //removed because too specific for a super class, it doesn't need to know specifics of extending class. Solution: trigger a function call that can be used by child classes
//            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        //delete category
//                        self.realm.delete(categoryForDeletion)
//                    }
//                }
//                catch {
//                    print(error)
//                }
//            }
            
            print("Item deleted")
        }
        
        // customize the action appearance, shows action
        deleteAction.image = UIImage(named: "delete-icon") //name of image file
        
        return [deleteAction] //response to user swiping a cell
    }
    
    //swipe alway thorugh to delete at once, instead of clicking delete button
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    // MARK: - Trigger functions
    
    //trigger function to child class
    func updateModel(at indexPath: IndexPath){
        //update datamodel here
      
        print("update using super class")
        
        //sub classes will override this method to finishup this delete task in their own way
        //            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
        //                do {
        //                    try self.realm.write {
        //                        //delete category
        //                        self.realm.delete(categoryForDeletion)
        //                    }
        //                }
        //                catch {
        //                    print(error)
        //                }
        //            }
    }

}

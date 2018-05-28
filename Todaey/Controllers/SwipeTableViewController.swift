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
    }

    // MARK: - SwipeTableViewCellDelegate methods
    
    //handles when user swipes on cell, orientation from right
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // has a closure, of what to do when swiped
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
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

}

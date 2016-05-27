//
//  NewChatViewController.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {

    var tableView: UITableView!
    
    var users: [User] = []
    
    var selectedIndexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Chat"
        
        navigationController?.setTheme()
        
        setupTableView()
        setupBarButtonItems()
        fetch()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        tableView.rowHeight = 52.0
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    func setupBarButtonItems() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        
        let addButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButtonPressed() {
        let userIds = selectedIndexes.map { users[$0].id }
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetch() {
        Network.fetchUsers { users, error in
            if let error = error { self.displayError(error, completion: nil) }
            self.users = users ?? []
            self.tableView.reloadData()
        }
    }
    
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        cell.nameLabel.text = users[indexPath.row].name
        cell.emailLabel.text = users[indexPath.row].email
        
        if selectedIndexes.contains(indexPath.row) {
            cell.accessoryType = .Checkmark
            cell.nameLabel.textColor = UIColor.microPurple()
        } else {
            cell.accessoryType = .None
            cell.nameLabel.textColor = UIColor.darkGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let previousIndex = selectedIndexes.indexOf(indexPath.row) {
            selectedIndexes.removeAtIndex(previousIndex)
        } else {
            selectedIndexes.append(indexPath.row)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}
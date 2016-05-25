//
//  ViewController.swift
//  SocketChat
//
//  Created by Daniel Li on 5/24/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import SwiftyJSON
import SlackTextViewController

class ViewController: SLKTextViewController {
    
    init() {
        super.init(tableViewStyle: .Plain)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var socket: SocketIOClient!
    
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }
    
    var messages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
        socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:5000")!, options: [.Nsp("/test")])
        
        socket.on("chat") { data, ack in
            if let dict = data.first as? NSDictionary,
                message = dict["lol"] as? String {
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                let rowAnimation: UITableViewRowAnimation = self.inverted ? .Bottom : .Top
                let scrollPosition: UITableViewScrollPosition = self.inverted ? .Bottom : .Top
                
                self.tableView.beginUpdates()
                self.messages.insert(message, atIndex: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
                self.tableView.endUpdates()
                
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
            }
        }
        
        socket.onAny { print("Got event: " + $0.event) }
        
        socket.connect()
        
        rightButton.setTitle("Send", forState: .Normal)
    }
    
    override func didPressRightButton(sender: AnyObject?) {
        socket.emit("chat", [textView.text])
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let rowAnimation: UITableViewRowAnimation = self.inverted ? .Bottom : .Top
        let scrollPosition: UITableViewScrollPosition = self.inverted ? .Bottom : .Top
        
        self.tableView.beginUpdates()
        self.messages.insert(textView.text, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
        
        textView.text = ""
    }
}

extension ViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        cell.textLabel?.text = messages[indexPath.row]
        
        cell.transform = tableView.transform
        
        return cell
    }
}


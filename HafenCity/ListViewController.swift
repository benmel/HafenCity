//
//  ListViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 2/26/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit
import CoreData

@objc
protocol ListViewControllerDelegate {
    func shouldCollapseMenu()
}

class ListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    // outlets
    @IBOutlet weak var table: UITableView!
    
    // delegates
    var delegate: ListViewControllerDelegate?
    var locationDelegate: LocationViewControllerDelegate?
    
    // variables
    var locations = [Location]()
    var tapRecognizer: UITapGestureRecognizer?
    var swipeRecognizer: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        table.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        table.dataSource = self
        table.delegate = self
        fetchLocations()
        
        // set up interaction notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableTable", name:"disableInteraction", object: self.parentViewController)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableTable", name:"enableInteraction", object: self.parentViewController)
        
        // set up tap gestures
        tapRecognizer = UITapGestureRecognizer(target: self, action: "collapseMenu")
        tapRecognizer?.enabled = false
        self.view.addGestureRecognizer(tapRecognizer!)
        
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "collapseMenu")
        swipeRecognizer?.direction = .Left
        swipeRecognizer?.enabled = false
        self.view.addGestureRecognizer(swipeRecognizer!)
    }
        
    func fetchLocations() {
        // get managed context
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // get locations
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Location")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [Location]?
        if let results = fetchedResults {
            locations = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedView = self.locations[indexPath.row]
        performSegueWithIdentifier("DetailsList", sender: selectedView)
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return locations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let person = locations[indexPath.row]
        cell.textLabel!.text = person.valueForKey("name") as String?
        return cell
    }
    
    func collapseMenu() {
        delegate?.shouldCollapseMenu()
    }
    
    func enableTable() {
        table.scrollEnabled = true
        table.allowsSelection = true
        tapRecognizer?.enabled = false
        swipeRecognizer?.enabled = false
    }
    
    func disableTable() {
        table.scrollEnabled = false
        table.allowsSelection = false
        tapRecognizer?.enabled = true
        swipeRecognizer?.enabled = true
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsList" {
            let nav = segue.destinationViewController as UINavigationController
            let controller = nav.topViewController as LocationViewController
            controller.delegate = locationDelegate
            let location = sender as Location
            controller.text = location.text
            controller.directory = location.directory
            nav.navigationBar.topItem?.title = location.name
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

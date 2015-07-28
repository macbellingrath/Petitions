//
//  MasterViewController.swift
//  Petitions
//
//  Created by Mac Bellingrath on 7/28/15.
//  Copyright © 2015 Mac Bellingrath. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String:String]]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let urlString:String
        if navigationController?.tabBarItem.tag == 0{
            title = "Petitions: Recent "
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            title = "Petitions: Popular"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        if let url = NSURL(string: urlString){
            if let data = NSData(contentsOfURL: url){
                let json = JSON(data: data)
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    print("OK to parse")
                    parseJSON(json)
                    }   else {
                    showError()
                  }
                } else {
                showError()
            }} else {
            showError()
            }
    }
    // MARK: - JSON Methods
    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue{
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let sigsNeeded = result["signaturesNeeded"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs, "signaturesNeeded":sigsNeeded]
            objects.append(obj)
        }
        tableView.reloadData()
    }


    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
                
                controller.detailItem = object
               

            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel?.text = object["body"]
        return cell
    }
   
    
    //MARK: - Helper Methods
    
    func done(){
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "I'm having trouble connecting to the feed", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        
    }
}
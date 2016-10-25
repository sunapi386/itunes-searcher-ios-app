//
//  MusicTableViewController.swift
//  iTunesSearch
//
//  Created by Jason Sun on 16/10/25.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class MusicTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    let cp = ContentProviderITunes()

    var content: [String] = []

//    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
//        debugPrint("searchBarResultsListButtonClicked")
//        self.content = []
//        self.tableView.reloadData()
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        debugPrint("searchBarCancelButtonClicked")
//        self.content = []
//        self.tableView.reloadData()
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }
        cp.searchTerm = searchTerm
        debugPrint("searching \(searchTerm) : \(cp.parameterizedURL())")
        cp.performSearch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let notificationName = NSNotification.Name(rawValue: "ContentProviderReceivedData")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification: Notification) in
            debugPrint("\(notificationName) got notification \(notification)")
            //todo: update model / content
            guard let mediaItems = self.cp.searchResults else {
                debugPrint("Got no items in search")
                return
            }
            self.content = mediaItems.map({ (mItem: MediaItem) -> String in
                mItem.displayName
            })
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)

        // Configure the cell...
        let row = indexPath.row
        let object = content[row]
        cell.textLabel?.text = object

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

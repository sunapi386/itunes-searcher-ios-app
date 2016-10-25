//
//  MusicTableViewController.swift
//  iTunesSearch
//
//  Created by Jason Sun on 16/10/25.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MusicTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    let cp = ContentProviderITunes()
    var content: [MediaItem]?
    var player :AVPlayer?

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }
        cp.searchTerm = searchTerm
        cp.mediaKind = .musicVideo
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
            self.content = mediaItems
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
        return content?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)

        // Configure the cell...
        let row = indexPath.row
        let object = content?[row]
        cell.textLabel?.text = object?.displayName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let mItem = content?[row], let previewURL = mItem.previewUrl {
            player = AVPlayer(url: previewURL)
            let vc = AVPlayerViewController()
            vc.player = player
            present(vc, animated: true, completion: nil)
            player!.play()
        }
    }

    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Miti Shah on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class FeedTableViewController: UITableViewController {

    let reuseIdentifier = "feedCell"
    let flowLayout = UICollectionViewFlowLayout()
    var links = [Link]()
    var databaseReference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var storage = FIRStorageReference()
        self.databaseReference = FIRDatabase.database().reference().child("posts")

        
        let feedVC = FeedTableViewController()
        if FIRAuth.auth()?.currentUser == nil {
            //            FIRAuth.auth()?.currentUser?.uid.
             present(LoginViewController(), animated: true, completion: nil)
            
        } else {
            self.navigationController?.pushViewController(feedVC, animated: true)
            
        }
                storage = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
        getLinks()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        getLinks()
    }
    
    func getLinks() {
        
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                dump(child)
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String: String] {
                    let link = Link(key: snap.key,
                                    userID: valueDict["userID"] ?? "",
                                    comment: valueDict["comment"] ?? "")
                    let dict = snap.value as? [String: Any]
                    var valueDict = snap.value as? [String: Any]
                        self.links.append(link)
                    
                    }
            }
            self.tableView.reloadData()
        })
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return links.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FeedTableViewCell

        var link = links[indexPath.row]
        cell?.commentLabel.text = link.comment
        
        var storage = FIRStorage.storage()
        
        let storageRef = storage.reference(forURL: "gs://ac-32-final.appspot.com")
        let spaceRef = storageRef.child("images/\(link.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                
                cell?.feedImageView.image = image
            }
        }
        return cell!
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

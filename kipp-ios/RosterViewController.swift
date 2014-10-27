//
//  RosterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileImageTappedDelegate, MGSwipeTableCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var teacher: PFUser!
    var classroom: Classroom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.reloadData()
        
        navigationItem.title = "Period \(classroom.period)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classroom.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = classroom.students[indexPath.row]
        cell.student = student
        cell.profileDelegate = self
        cell.delegate = self
        cell.rightButtons = createRightButtons()
        //        cell.leftButtons = []
        //        cell.leftSwipeSettings.transition = MGSwipeTransition.TransitionDrag
        cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        cell.rightExpansion.fillOnTrigger = false

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let student = classroom.students[indexPath.row]
        self.performSegueWithIdentifier("characterSegue", sender: student)
    }

    func createRightButtons() -> NSArray {
        var button = MGSwipeButton(title: "Actions", backgroundColor: UIColor.darkBlue()) { (cell) -> Bool in
            NSLog("Tapped actions for \(cell)")
//            self.markActionComplete(self.tableView.indexPathForCell(cell)!)
            return true
        }
        //        var button = MGSwipeButton(title: "Delete", backgroundColor: UIColor.myRedColor()) { (cell) -> Bool in
        //            NSLog("Tapped delete for \(cell)")
        //            self.markActionComplete(self.tableView.indexPathForCell(cell)!)
        //            return true
        //        }
        return [button]
    }
    
    
    func didTapProfileImg(student: Student) {
        self.performSegueWithIdentifier("profileSegue", sender: student)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "profileSegue") {
            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.student = sender as Student
        } else if (segue.identifier == "characterSegue") {
            var characterVC = segue.destinationViewController as CharacterViewController
            characterVC.student = sender as? Student
        }
        
    }
    
}

//
//  StudentTableViewCell.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class StudentTableViewCell: MGSwipeTableCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    
    var profileDelegate: ProfileImageTappedDelegate?
    
    weak var student: Student? {
        willSet(newStudent) {
            if newStudent != nil {
                self.displayName.text = "\(newStudent!.firstName) \(newStudent!.lastName)"
                self.profilePic.image = UIImage(named: newStudent!.gender.profileImg())
//                newStudent!.fillAttendanceState() // If we want attendance for specific date, we can pass the date here
            }
        }
    }
        
    @IBAction func didTapProfilePic(sender: AnyObject) {
        profileDelegate?.didTapProfileImg(student!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

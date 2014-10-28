//
//  Classroom.swift
//  kipp-ios
//
//  Created by vli on 10/12/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit
var _currentClassroomId: String?

class Classroom: NSObject {
    var students: [Student]!
    var period: Int!
    var subject: String!
    var title: String?      // used if teacher wants to rename display name of class
    var termStart, termEnd: NSDate!
    var parseId: String!
    
    init(obj: PFObject) {
        period = obj["period"] as Int
        subject = obj["subject"] as String
        let studentsArray = obj.objectForKey("students") as NSArray
        students = Student.studentsWithArray(studentsArray)
        termStart = obj["termStartDate"] as NSDate
        termEnd = obj["termEndDate"] as NSDate?
        title = obj["title"] as? String
        parseId = obj.objectId
    }
    
    class func setCurrentClass(classroom: Classroom) {
        _currentClassroomId = classroom.parseId
    }
    
    class func currentClassId() -> String? {
        return _currentClassroomId;
    }
    
    class func currentClassWithCompletion(completion: ((classroom: Classroom?, error: NSError?) -> ())) {
        ParseClient.sharedInstance.findClassroomsWithCompletion() { (classrooms: [Classroom]?, error: NSError?) -> Void in
            if classrooms != nil && classrooms?.count > 0 {
                var currentClassroom: Classroom?
                for classroom in classrooms! {
                    if classroom.parseId == self.currentClassId() {
                        currentClassroom = classroom
                    }
                }
                
                completion(classroom: (currentClassroom ?? classrooms?[0]), error: error)
                return ()
            }
        }
    }
    
    class func classroomsWithArray(objs: [PFObject]) -> [Classroom] {
        var classrooms = [Classroom]()
        
        for pfobj in objs {
            classrooms.append(Classroom(obj: pfobj))
        }
        classrooms.sort({$0.period < $1.period})
        return classrooms
    }
}

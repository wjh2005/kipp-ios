//
//  SpiderViewController.swift
//  kipp-ios
//
//  Created by vli on 11/6/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class SpiderViewController: UIViewController {
    var studentId: Int!
    var loadedTraitValues: [Int]!
    
    var scoresLoaded: Bool = false
    var spiderView: BTSpiderPlotterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Load spider view?")

        var dict = ["A": "0", "B": "0", "C": "0", "D": "0", "E": "0", "F": "0", "G": "0"]
        spiderView = BTSpiderPlotterView(frame: self.view.frame, valueDictionary: dict)
//        var values = ["A": "0", "B": "0", "C": "0"]
//        spiderView = BTSpiderPlotterView(frame: self.view.frame, valueDictionary: values)
        spiderView.maxValue = 1.0
        spiderView.valueDivider = 0.1
        spiderView.drawboardColor = UIColor(red: CGFloat(96.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(215.0/255.0), alpha: CGFloat(0.5))
        spiderView.plotColor = UIColor(red: CGFloat(96.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(215.0/255.0), alpha: CGFloat(0.5))
        self.view.addSubview(spiderView)
        
        loadedTraitValues = [Int](count: 7, repeatedValue: 0)
        loadScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadScores() {
//        for index in 0..<student.characterArray.count {
        let characterTraits = CharacterTrait.defaultCharacterTraitArray()
        for index in 0..<7 {
            let curCharacterTrait = characterTraits[index]
            
            ParseClient.sharedInstance.getLatestCharacterScoreForWeekWithCompletion(studentId, characterTrait: curCharacterTrait.title) { (characterTrait, error) -> () in
                if characterTrait != nil {
                    NSLog("Found \(characterTrait!.title) with score \(characterTrait!.score)")
//                    self.student!.characterArray[index].score = characterTrait!.score
                    self.loadedTraitValues[index] = characterTrait!.score
                } else {
                    self.loadedTraitValues[index] = 0
                }
                if index == 6 {
                    self.scoresLoaded = true
                    self.drawGraph()
                }
            }
        }
    }

    func drawGraph() {
        var values = getNormalizedValues()
        let characterTraits = CharacterTrait.defaultCharacterTraitArray()
        var dict: NSMutableDictionary = NSMutableDictionary()
        for index in 0..<characterTraits.count {
            dict.setValue(values[index], forKey: characterTraits[index].title)
//            var dict = ["A": "\(values[0])", "B": "\(values[1])", "C": "\(values[2])", "D": "\(values[3])", "E": "\(values[4])", "F": "\(values[5])", "G": "\(values[6])"]
        }
//        var dict = ["A": "\(values[0])", "B": "\(values[1])", "C": "\(values[2])", "D": "\(values[3])", "E": "\(values[4])", "F": "\(values[5])", "G": "\(values[6])"]
        NSLog("\(dict)")
//        spiderView = BTSpiderPlotterView(frame: self.view.frame, valueDictionary: dict)
//        spiderView.maxValue = 1.0
//        spiderView.valueDivider = 0.1
//        self.view.addSubview(spiderView)
        
        spiderView.animateWithDuration(0.5, valueDictionary: dict)
    }
    
    func getNormalizedValues() -> [Float] {
        let minVal = minElement(loadedTraitValues) - 1
        let maxVal = maxElement(loadedTraitValues) + 1
        let range = maxVal - minVal
        let zeroVal = -minVal
        NSLog("min: \(minVal), max: \(maxVal), range: \(range), zero: \(zeroVal)")
        var normVals: [Float] = [Float]()
        for score in loadedTraitValues {
            let normScore = score + zeroVal
            normVals.append(Float(normScore)/Float(range))
        }
        return normVals
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

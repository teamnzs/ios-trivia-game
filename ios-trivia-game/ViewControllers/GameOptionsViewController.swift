//
//  GameOptionsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class GameOptionsViewController: UIViewController {

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var numOfQuestionsPicker: UIPickerView!
    
    var categoryPickerData: [String] = [String]()
    var numOfQuestionsPickerData: [String] = [String]()
    
    var numOfQuestions: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPickerData()
    }
    
    func setupPickerData() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        numOfQuestionsPicker.delegate = self
        numOfQuestionsPicker.dataSource = self
        self.numOfQuestionsPickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GameOptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return categoryPickerData.count
        } else {
            return numOfQuestionsPickerData.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return categoryPickerData[row]
        } else {
            numOfQuestions = row + 1
            return numOfQuestionsPickerData[row]
        }
    }
}

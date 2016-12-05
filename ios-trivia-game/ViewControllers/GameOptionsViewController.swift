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
    
    // API Data
    var numOfPlayers: Int?
    var category: Int?
    var isPublic: Bool?
    var selectedFriends = Set<String>()
    var nameOfGameroom: String?
    
    // UI Data
    var categoryPickerData: [String] = [String]()
    var numOfQuestionsPickerData: [String] = [String]()
    var categoryPickerNum: [Int] = [Int]()
    
    var numOfQuestions: Int?
    
    let PICKER_TAG_FOR_CATEGORY = 1;
    let PICKER_TAG_FOR_NUM_OF_QUESTIONS = 2;
    
    internal let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getCategories()
    }
    
    func getCategories() {
        FirebaseClient.instance.getCategories(complete: {(snapshot) in
            let value = snapshot.value
            if let categories = value as? NSDictionary {
                let triviaCategories = self.convertWithArray(dictionaries: categories.allValues as! [NSDictionary])
                for category in triviaCategories {
                    print("Category: \(category.getJson())")
                    self.categoryPickerData.append(category.title!)
                    self.categoryPickerNum.append(category.id!)
                }
                self.setupPickerData()
            }
        }, onError: {(error) in
        })
    }
    
    func convertWithArray(dictionaries: [NSDictionary]) -> [TriviaCategory] {
        var categories = [TriviaCategory]()
        
        for dictionary in dictionaries {
            let category = TriviaCategory(dictionary: dictionary)
            categories.append(category)
        }
        
        return categories
    }
    
    func setupPickerData() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        numOfQuestionsPicker.delegate = self
        numOfQuestionsPicker.dataSource = self
        self.numOfQuestionsPickerData = Array(1...MAX_NUMBER_OF_QUESTIONS).flatMap { String(describing: $0) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        _ = self.navigationController!.popViewController(animated: true)
        let selectFriendsViewController = self.navigationController!.topViewController as! SelectFriendsViewController
        selectFriendsViewController.numOfPlayers = self.numOfPlayers
        selectFriendsViewController.isPublic = self.isPublic
        selectFriendsViewController.nameOfGameroom = self.nameOfGameroom
    }

    // Make an api call to create a game room, and then go to CountdownTimerViewController if it succeeds.
    @IBAction func onStartGameClicked(_ sender: Any) {
        FirebaseClient.instance.getRandomQuestions(categoryId: category!, maxNumOfQuestions: numOfQuestions!, complete: {(questionList) in
            let newGame = GameRoom(id: FirebaseClient.instance.createGameRoomId().key, name: self.nameOfGameroom, currentNumPlayers: 1, maxNumPlayers: self.numOfPlayers, state: GameRoom.State(rawValue: 0), isPublic: self.isPublic, currentQuestion: 0, maxNumQuestions: self.numOfQuestions, questions: questionList, category: self.category)
            
            FirebaseClient.instance.createGame(gameRoom: newGame.getJson() as NSDictionary, complete: {_, ref in
                let roomId = ref.key
                
                print("Created game room with roomID: \(roomId)")
                // Go to CountdownGameViewController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destination = storyboard.instantiateViewController(withIdentifier: Constants.COUNTDOWN_NAVIGATION_VIEW_CONTROLLER)
                let countdownNavigationController = destination as! UINavigationController
                let countdownGameViewController = countdownNavigationController.topViewController as! CountdownGameViewController
                countdownGameViewController.roomId = roomId
                
                // create invites in the invite table
                let hostId = (User.currentUser?.uid)!
                for friendId in self.selectedFriends {
                    if Float(friendId) != nil {
                        // numeric friend ids mean that the user is registered. Create an invite
                        let invite = Invite(roomId: newGame.id, guestId: friendId, hostId: hostId)
                        FirebaseClient.instance.createInviteFor(invite: invite, complete: { (_, _) in
                            Logger.instance.log(message: "\(hostId) invited \(friendId) to \(newGame.id)")
                        })
                    }
                    
                    // when the friendId is a hashcode, they aren't registered in our DB.  Given more time, we will create custom UI to invite players
                }
                
                self.present(destination, animated: true, completion: nil)
            })
        }, onError: {(error) in
            Logger.instance.log(logLevel: .error, message: "Found an error while trying to start game \(error?.localizedDescription)")
        })
    }
}

extension GameOptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == PICKER_TAG_FOR_CATEGORY {
            return categoryPickerData.count
        } else if pickerView.tag == PICKER_TAG_FOR_NUM_OF_QUESTIONS {
            return numOfQuestionsPickerData.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == PICKER_TAG_FOR_CATEGORY {
            print ("Category picker \(categoryPickerNum)")
            print ("Row \(row)")
            category = self.categoryPickerNum[row]
        } else if pickerView.tag == PICKER_TAG_FOR_NUM_OF_QUESTIONS {
            numOfQuestions = row + 1
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == PICKER_TAG_FOR_CATEGORY {
            return categoryPickerData[row]
        } else if pickerView.tag == PICKER_TAG_FOR_NUM_OF_QUESTIONS {
            numOfQuestions = row + 1
            return numOfQuestionsPickerData[row]
        } else {
            return ""
        }
    }
}

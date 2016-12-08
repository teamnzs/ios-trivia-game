# MindGame
This application is to demonstrate our team's ability to incorporate the concepts that have been learned from the Codepath iOS development course.

The basic game is a trivia game with a unique twist. Game players are given a series of questions. On each question, the players are asked to provide an answer that they would like to give to all other users as an option to select as the right answer. Once all player answer options are received, a series of multiple choice questions is then given to all users that has the players' provided answers along with the correct answer. The objective of the user provided answers is to provide seemingly correct answers to fool the other players.

We will require authentication via a third party account. Users have the ability to play with friends. A profile of the user is also created. A global ranking is maintained.

# Introduction
Welcome to Mind Game! This is a trivia game with a twist. You can pick from a large set of Trivia Categories and invite your Friends. Next you'll need to fool your friends with fake answers, but remember to pick the right answer!

## Video walkthrough
- https://www.youtube.com/watch?v=VWB5-ej6trs

## GIF walkthrough
<img src='https://github.com/teamnzs/ios-trivia-game/blob/master/mindgame.gif' title='Video Walkthrough' width='' alt='GIF walkthrough' />

## Dependent APIs
- Facebook 
    - Login Authentication
- Firebase
    - NoSQL database for backend database that manages Game creation and operation, User registration, Import of Trivia questions
- jService
    - Sources over 150,000 trivia questions from the Jeopardy database

## User Stories

- [x] Intro
   - [x] User should be able to login or sign up via Facebook
   - [x] Get user permission for access Facebook data
   - [x] App should be able to persist user session
- [x] Main page
   - [x] It has tab layout on the bottom - Discover, Profile, Create game, Ranking
   - [x] By tapping on each tab, user should be able to change the main content view
- [x] Discover tab
   - [x] User can create a game room
   - [x] User can see the list of existing games and should be able to join the room by clicking on one of the rooms
- [x] Profile tab
   - [x] User can see their basic information, i.e. profile picture, name, game score, etc
   - [x] User can go back, save information, or log out
- [x] Create game tab
   - [x] User can create a game as "Game room"
- [ ] Ranking tab
   - [ ] User can see the global ranking
- [x] Game room page
   - [x] Create a room
      - [x] Same as "Friends page", user can see their friends list and select a list of friends (up to 5 people)
      - [x] User can create a room by selecting the category, selecting number of questions, and selecting public/private mode, or can exit the view
      - [x] User can see the number of people who have joined, and can click on "Join" or "Cancel" button
   - [x] See friends list
      - [x] User can see their friends list loaded from Facebook Graph api
      - [x] User can search friends
      - [x] Should be able to select a list of friends (up to 5 people) and create a game room
   - [x] Playing game
      - [x] User can see the Trivia question and count down timer
      - [x] Should be able to exit or select answer. The answer list comes from server
      - [x] After submit the answer, user should be able to see the ranking
      - [x] User can go back to the "Ready" page by clicking the next game
   - [x] Entering an existing game room
      - [x] User can see the Travia question and count down timer for existing game
      - [x] Submit button should be gray out until the next round is available
- [x] Final Score page
   - [ ] User should be able to see the ranking and winner

The following **optional** features can be implemented:

- [ ] Intro
   - [ ] User can signup or login via Twitter
- [ ] Profile page
   - [ ] User can take picture with camera
- [ ] Friends page
   - [ ] User can invite people who is near by you by using location data
   - [ ] User can chat with friends

## Wireframe Diagram

Here's a diagram of the wireframe:

<img src='https://raw.githubusercontent.com/teamnzs/ios-wireframe/master/teamnzs-wireframe.gif' title='Video Walkthrough' width='' alt='Wireframe Diagram' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

    Copyright 2016 Savio Tsui, Zhia Hwa Chong, Nari Shin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

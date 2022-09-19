//
//  model.swift
//  CMSC436 SwiftUI Playground
//
//  Created by Mateos O'Connor on 3/30/22.
//

import Foundation
import SwiftUI

class Sudoku : ObservableObject {
    //9x9 board for sudoku
    @Published var solution : [[Int]] {
        didSet {
            UserDefaults.standard.set(solution, forKey: "solutionBoard")
        }
    }
    var solCount: Int
    var board1: [[Int]]
    var board2: [[Int]]
    var board3: [[Int]]
    var board4: [[Int]]
    var board5: [[Int]]
    var solution1: [[Int]]
    var solution2: [[Int]]
    var solution3: [[Int]]
    var solution4: [[Int]]
    var solution5: [[Int]]
    @Published var board : [[Int]] {
        didSet {
            UserDefaults.standard.set(board, forKey: "currentBoard")
        }
    }
    @Published var stringBoard : [String]
    @Published var notes : [[Int]]
    @Published var notesStringArray : [[String]]
    @Published var notesStrings : [String]
    @Published var score : Int
    @Published var numWrong : Int
    @Published var hintsRemaining : Int
    @Published var noMoreHints : Bool
    @Published var startingBoard: [Int]
    @Published var hasGame : Bool
    @Published var difficulty : Difficulty
    @Published var tileColor : [Int]
    @Published var lose : Bool
    @Published var win : Bool
    @Published var hasAddedNum: Bool
    @Published var stopAlerts : Bool
    @Published var useHints : Bool {
        didSet {
            UserDefaults.standard.set(useHints, forKey: "isUsingHints")
        }
    }
    @Published var useSFX : Bool {
        didSet {
            UserDefaults.standard.set(useSFX, forKey: "isUsingSFX")
        }
    }
    @Published var trackScore : Bool {
        didSet {
            UserDefaults.standard.set(trackScore, forKey: "isTrackingScore")
        }
    }
    @Published var gamesStarted : Int {
        didSet {
            UserDefaults.standard.set(gamesStarted, forKey: "forgamesStarted")
        }
    }
    @Published var gamesWon : Int {
        didSet {
            UserDefaults.standard.set(gamesWon, forKey: "forgamesWon")
        }
    }
    @Published var winStreak : Int {
        didSet {
            UserDefaults.standard.set(winStreak, forKey: "forwinStreak")
        }
    }
    @Published var highScore : Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "forhighScore")
        }
    }
    @Published var highScoreDate : Date {
        didSet {
            UserDefaults.standard.set(highScoreDate, forKey: "forhighScoreDate")
        }
    }
    @Published var nextBoard : Int {
        didSet {
            UserDefaults.standard.set(nextBoard, forKey: "forNextBoard")
        }
    }
    
    enum Difficulty {
        case Easy
        case Medium
        case Hard
    }
    
    init(){
        board1 = [[0,0,0,0,0,0,0,0,2],[0,0,0,0,0,0,9,4,0],[0,0,3,0,0,0,0,0,5],[0,9,2,3,0,5,0,7,4],[8,4,0,0,0,0,0,0,0],[0,6,7,0,9,8,0,0,0],[0,0,0,7,0,6,0,0,0],[0,0,0,9,0,0,0,2,0],[4,0,8,5,0,0,3,6,0]]
        board2 = [[4, 0, 6, 0, 0, 0, 0, 5, 9], [0, 0, 0, 0, 4, 0, 2, 0, 0], [0, 7, 0, 0, 0, 0, 0, 0, 0], [0, 0, 5, 9, 1, 0, 0, 6, 0], [0, 1, 3, 0, 0, 0, 8, 9, 4], [0, 0, 0, 2, 0, 0, 0, 0, 1],[5, 0, 8, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 3, 0, 0, 0, 8], [0, 4, 0, 0, 6, 0, 1, 0, 0]]
        board3 = [[0,0,0,0,0,8,0,9,0],[0,0,3,0,0,1,0,0,0],[2,0,0,0,0,7,6,0,0],[0,0,0,0,2,0,0,0,0],[0,9,4,0,8,0,2,0,0],[7,1,0,0,4,0,9,0,5],[1,0,0,9,0,0,5,3,0],[5,7,0,0,0,0,8,4,0],[0,0,0,0,0,6,0,2,1]]
        board4 = [[0,7,0,0,1,0,0,2,0],[5,0,0,0,2,7,0,0,1],[0,0,2,5,0,8,0,0,4],[0,0,0,9,0,0,0,0,0],[8,6,0,1,0,0,9,5,3],[0,0,0,3,0,0,1,0,0],[3,0,0,0,0,0,0,0,9],[0,2,0,7,5,0,0,0,0],[0,0,0,2,3,0,4,8,0]]
        board5 = [[2,7,0,0,0,0,0,9,3],[0,0,6,0,3,9,0,0,0],[3,0,0,0,0,0,1,5,0],[0,3,0,2,0,4,0,0,7],[9,2,5,0,0,0,4,0,8],[4,0,0,6,0,0,0,0,0],[0,0,0,0,0,0,0,7,5],[5,0,0,0,0,8,0,0,1],[0,0,4,0,0,3,9,0,0]]
        solution1 = [[6,8,4,1,5,9,7,3,2],[7,5,1,8,3,2,9,4,6],[9,2,3,6,7,4,1,8,5],[1,9,2,3,6,5,8,7,4],[8,4,5,2,1,7,6,9,3],[3,6,7,4,9,8,2,5,1],[2,3,9,7,4,6,5,1,8],[5,1,6,9,8,3,4,2,7],[4,7,8,5,2,1,3,6,9]]
        solution2 = [[4, 3, 6, 1, 2, 8, 7, 5, 9], [9, 5, 1, 7, 4, 6, 2, 8, 3], [8, 7, 2, 3, 5, 9, 4, 1, 6], [7, 8, 5, 9, 1, 4, 3, 6, 2], [2, 1, 3, 6, 7, 5, 8, 9, 4], [6, 9, 4, 2, 8, 3, 5, 7, 1], [5, 2, 8, 4, 9, 1, 6, 3, 7], [1, 6, 7, 5, 3, 2, 9, 4, 8], [3, 4, 9, 8, 6, 7, 1, 2, 5]]
        solution3 = [[6,4,7,5,3,8,1,9,2],[9,5,3,2,6,1,4,7,8],[2,8,1,4,9,7,6,5,3],[8,6,5,7,2,9,3,1,4],[3,9,4,1,8,5,2,6,7],[7,1,2,6,4,3,9,8,5],[1,2,8,9,7,4,5,3,6],[5,7,6,3,1,2,8,4,9],[4,3,9,8,5,6,7,2,1]]
        solution4 = [[9,7,4,6,1,3,5,2,8],[5,8,3,4,2,7,6,9,1],[6,1,2,5,9,8,7,3,4],[1,3,5,9,7,6,8,4,2],[8,6,7,1,4,2,9,5,3],[2,4,9,3,8,5,1,6,7],[3,5,1,8,6,4,2,7,9],[4,2,8,7,5,9,3,1,6],[7,9,6,2,3,1,4,8,5]]
        solution5 = [[2,7,1,4,5,6,8,9,3],[8,5,6,1,3,9,7,2,4],[3,4,9,8,2,7,1,5,6],[6,3,8,2,9,4,5,1,7],[9,2,5,3,7,1,4,6,8],[4,1,7,6,8,5,2,3,9],[1,8,3,9,4,2,6,7,5],[5,9,2,7,6,8,3,4,1],[7,6,4,5,1,3,9,8,2]]
        notes = [[Int]](repeating: [Int](repeating: 0, count: 1), count: 81)
        notesStringArray = [[String]](repeating: [String](repeating: "", count: 1), count: 81)
        notesStrings = [String](repeating: "", count: 81)
        score = 0
        numWrong = 0
        hintsRemaining = 3
        stringBoard = []
        startingBoard = []
        solCount = 0
        hasGame = false
        difficulty = .Hard
        tileColor = Array(repeating: Int(0), count: 81)
        lose = false
        win = false
        noMoreHints = false
        hasAddedNum = false
        stopAlerts = false
        self.useHints = UserDefaults.standard.object(forKey: "isUsingHints") as? Bool ?? true
        self.useSFX = UserDefaults.standard.object(forKey: "isUsingSFX") as? Bool ?? true
        self.trackScore = UserDefaults.standard.object(forKey: "isTrackingScore") as? Bool ?? true
        self.gamesStarted = UserDefaults.standard.object(forKey: "forgamesStarted") as? Int ?? 0
        self.gamesWon = UserDefaults.standard.object(forKey: "forgamesWon") as? Int ?? 0
        self.winStreak = UserDefaults.standard.object(forKey: "forwinStreak") as? Int ?? 0
        self.highScore = UserDefaults.standard.object(forKey: "forhighScore") as? Int ?? 0
        self.highScoreDate = UserDefaults.standard.object(forKey: "forhighScoreDate") as? Date ?? Date()
        self.nextBoard = UserDefaults.standard.object(forKey: "forNextBoard") as? Int ?? 1
        self.board = UserDefaults.standard.object(forKey: "currentBoard") as? [[Int]] ?? []
        self.solution = UserDefaults.standard.object(forKey: "solutionBoard") as? [[Int]] ?? []
    }
    
    public func newgame(){
        
        stopAlerts = false
        hasAddedNum = false
        tileColor = Array(repeating: 0, count: 81)
        lose = false
        win = false
        noMoreHints = false
        notes = [[Int]](repeating: [Int](repeating: 0, count: 1), count: 81)
        notesStringArray = [[String]](repeating: [String](repeating: "", count: 1), count: 81)
        notesStrings = [String](repeating: "", count: 81)
        score = 0
        numWrong = 0
        hintsRemaining = 4
        difficulty = .Hard
        if (nextBoard == 1) {
            board = board1
            solution = solution1
            nextBoard = 2
        } else if (nextBoard == 2) {
            board = board2
            solution = solution2
            nextBoard = 3
        } else if (nextBoard == 3) {
            board = board3
            solution = solution3
            nextBoard = 4
        } else if (nextBoard == 4) {
            board = board4
            solution = solution4
            nextBoard = 5
        } else if (nextBoard == 5) {
            board = board5
            solution = solution5
            nextBoard = 1
        }
        
        startingBoard = Array(board.joined())
        
        updateStringBoard()
    }
    
    func addNumbers(level: Difficulty) {
        if(level == Difficulty.Easy) {
            return
        } else if(level == Difficulty.Medium) {
            for _ in 0...6{
                addNumber()
            }
            difficulty = .Easy
        } else {
            for _ in 0...6 {
                addNumber()
            }
            difficulty = .Medium
        }
    }
    
    func addNumber(){
        var col: Int
        var row : Int
        var spaceFound = false
        
        while !spaceFound {
            row = Int.random(in: 0...8)
            col = Int.random(in: 0...8)
            if board[row][col] == 0 {
                board[row][col] = solution[row][col]
                startingBoard[row*9 + col] = solution[row][col]
                spaceFound = true
                updateStringBoard()
            }
        }
    }
    
    
    func changeTile(index: Int, num : Int){
        //Check if the cell is part of the original board
        let row: Int = index/9
        let col: Int = index%9
        
        if index == -1 {
            return
        }
        
        if !(hasAddedNum){
            hasAddedNum = true
            gamesStarted += 1
        }
        
        //Check if new number is correct
        if(num == solution[row][col]){
            board[row][col] = num
            updateStringBoard()
            tileColor[index] = 0
            score += 100
            if(compBoards(board: board, sol: solution)){
                gameOver()
            }
        }
        else{
            //the number is incorrect
            board[row][col] = num
            updateStringBoard()
            numWrong += 1
            tileColor[index] = 1
            score -= 200
            if (numWrong == 3){
                hasGame = false
                lose = true
                gameOver()
            }
            
        }
        
    }
    
    func gameOver(){
        //even if you lose, you could have a better score
        if(score > highScore){
            highScore = score
            highScoreDate = Date()
        }
        
        if(compBoards(board: board, sol: solution)){
            gamesWon += 1
            winStreak += 1
            win = true
        } else {
            winStreak = 0
            lose = true
        }
    }
    
    func eraseTile(index: Int){
        //make tile white
        let row: Int = index/9
        let col: Int = index%9
        
        board[row][col] = 0
        
        tileColor[index] = 0
        
        updateStringBoard()
    }
    
    func addNote(index: Int, num : Int){
        if notes[index][0] == 0 {
            notes[index] = []
        }
        notes[index].append(num)
        notes[index] = notes[index].sorted()
        tileColor[index] = 2
        updateNotesString()
    }
    
    func addHint(){
        var col: Int
        var row : Int
        var hintFound = false
        
        if(hintsRemaining == 0){
            noMoreHints = true
            return
        }
        while !hintFound {
            row = Int.random(in: 0...8)
            col = Int.random(in: 0...8)
            if board[row][col] == 0 {
                board[row][col] = solution[row][col]
                hintFound = true
                updateStringBoard()
                hintsRemaining -= 1
                score -= 200
                if(compBoards(board: board, sol: solution)){
                    gameOver()
                }
            }
        }
    }
    
    func updateStringBoard() {
        stringBoard = Array(board.joined()).map(String.init)
        for i in 0...80 {
            if (stringBoard[i] == "0") {
                stringBoard[i] = ""
            }
        }
    }
    
    func updateNotesString() {
        for i in 0...80 {
            notesStringArray[i] = notes[i].map { String($0) }
            notesStrings[i] = notesStringArray[i].joined(separator: " ")
        }
    }
    
    func compBoards(board: [[Int]], sol: [[Int]]) -> Bool {
        for i in 0...8{
            for j in 0...8{
                if (board[i][j] != sol[i][j]){
                    return false
                }
            }
        }
        return true
    }
    
}

//
//  DiamondViewController.swift
//  BrainVita
//
//  Created by Phanindra purighalla on 10/06/17.
//  Copyright © 2017 Aarna Solutions Inc. All rights reserved.
//

import UIKit

class DiamondViewController: UIViewController {
    
    let marblePresent = "⚫️"
    let marbleAbsent = "⚪️"
    let marbleSelected = "🔘"
    let possibleTarget = "◉"
    let selectedTarget = "🔴"
    
    var rowIndexOfSelectedMarble : Int = 0
    var columnIndexOfSelectedMarble : Int = 0
    
    var rowIndexOfSelectedTargetMarble : Int = 0
    var columnIndexOfSelectedTargetMarble : Int = 0
    
    var rowIndexOfRemovedMarble : Int = 0
    var columnIndexOfRemovedMarble : Int = 0
    
    var numMoves : Int = 0
    
    @IBOutlet weak var movesButton: UIButton!

    @IBOutlet weak var undoLastMove: UIButton!
    
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        
        if !(rowIndexOfRemovedMarble == 0 && columnIndexOfRemovedMarble == 0) {
            undo()
        }
        
    }
    
    func undo() {
        
        if let prevSelectedMarble = view.subviews[0].subviews[rowIndexOfSelectedMarble].subviews[columnIndexOfSelectedMarble] as? UIButton {
            prevSelectedMarble.setTitle(marblePresent, for: .normal)
        }
        
        if let prevSelectedTargetMarble = view.subviews[0].subviews[rowIndexOfSelectedTargetMarble].subviews[columnIndexOfSelectedTargetMarble] as? UIButton {
            prevSelectedTargetMarble.setTitle(marbleAbsent, for: .normal)
        }
        
        if let prevRemovedMarble = view.subviews[0].subviews[rowIndexOfRemovedMarble].subviews[columnIndexOfRemovedMarble] as? UIButton {
            prevRemovedMarble.setTitle(marblePresent, for: .normal)
        }
        
    }
    
    @IBOutlet var marbleButtons: [UIButton]!
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.title(for: .normal) == marblePresent {
            sender.setTitle(marbleSelected, for: .normal)
            updateUI(sender)
            for marbleButton in marbleButtons {
                marbleButton.isEnabled = false
                if marbleButton.title(for: .normal) == possibleTarget {
                    marbleButton.isEnabled = true
                }
            }
            sender.isEnabled = true
            undoLastMove.isEnabled = false
        }
        else if sender.title(for: .normal) == marbleSelected {
            sender.setTitle(marblePresent, for: .normal)
            for marbleButton in marbleButtons {
                marbleButton.isEnabled = true
            }
            updateUI(sender)
            undoLastMove.isEnabled = true
        }
        else if sender.title(for: .normal) == possibleTarget {
            sender.setTitle(selectedTarget, for: .normal)
            removeMarble()
            undoLastMove.isEnabled = true
        }
        
    }
    
    func removeMarble () {
        
        rowIndexOfSelectedMarble  = 0
        columnIndexOfSelectedMarble  = 0
        
        rowIndexOfSelectedTargetMarble  = 0
        columnIndexOfSelectedTargetMarble  = 0
        
        rowIndexOfRemovedMarble  = 0
        columnIndexOfRemovedMarble  = 0
        
        // Identify position of selected marble
        outer: for case let stackView as UIStackView in view.subviews {
            for case let horStackView as UIStackView in stackView.subviews {
                columnIndexOfSelectedMarble = 0
                for case let button as UIButton in horStackView.subviews {
                    if button.title(for: .normal) == marbleSelected {
                        break outer
                    }
                    columnIndexOfSelectedMarble += 1
                }
                rowIndexOfSelectedMarble += 1
            }
        }
        
        // Identify position of possible target marble, which is now selected as target
        outer: for case let stackView as UIStackView in view.subviews {
            for case let horStackView as UIStackView in stackView.subviews {
                columnIndexOfSelectedTargetMarble = 0
                for case let button as UIButton in horStackView.subviews {
                    if button.title(for: .normal) == selectedTarget {
                        button.setTitle(marblePresent, for: .normal)
                        break outer
                    }
                    columnIndexOfSelectedTargetMarble += 1
                }
                rowIndexOfSelectedTargetMarble += 1
            }
        }
        
        // If selection is vertical
        if columnIndexOfSelectedMarble == columnIndexOfSelectedTargetMarble {
            if rowIndexOfSelectedMarble < rowIndexOfSelectedTargetMarble {
                if let marbleToRemove = view.subviews[0].subviews[rowIndexOfSelectedMarble+1].subviews[columnIndexOfSelectedMarble] as? UIButton {
                    marbleToRemove.setTitle(marbleAbsent, for: .normal)
                    rowIndexOfRemovedMarble = rowIndexOfSelectedMarble+1
                }
            }
            else {
                if let marbleToRemove = view.subviews[0].subviews[rowIndexOfSelectedTargetMarble+1].subviews[columnIndexOfSelectedMarble] as? UIButton {
                    marbleToRemove.setTitle(marbleAbsent, for: .normal)
                    rowIndexOfRemovedMarble = rowIndexOfSelectedTargetMarble+1
                }
            }
            columnIndexOfRemovedMarble = columnIndexOfSelectedMarble
        }
        
        // If selection is horizontal
        if rowIndexOfSelectedMarble == rowIndexOfSelectedTargetMarble {
            if columnIndexOfSelectedMarble < columnIndexOfSelectedTargetMarble {
                if let marbleToRemove = view.subviews[0].subviews[rowIndexOfSelectedMarble].subviews[columnIndexOfSelectedMarble+1] as? UIButton {
                    marbleToRemove.setTitle(marbleAbsent, for: .normal)
                    columnIndexOfRemovedMarble = columnIndexOfSelectedMarble+1
                }
            }
            else {
                if let marbleToRemove = view.subviews[0].subviews[rowIndexOfSelectedMarble].subviews[columnIndexOfSelectedTargetMarble+1] as? UIButton {
                    marbleToRemove.setTitle(marbleAbsent, for: .normal)
                    columnIndexOfRemovedMarble = columnIndexOfSelectedTargetMarble+1
                }
            }
            rowIndexOfRemovedMarble = rowIndexOfSelectedMarble
        }
        
        for marbleButton in marbleButtons {
            marbleButton.isEnabled = true
            if marbleButton.title(for: .normal) == marbleSelected || marbleButton.title(for: .normal) == possibleTarget {
                marbleButton.setTitle(marbleAbsent, for: .normal)
            }
        }
        
        numMoves += 1
        
        movesButton.setTitle("Moves: \(numMoves)", for: .normal)
        
    }
    
    
    func updateUI (_ selectedMarble: UIButton)  {
        
        var rowIndexOfSelectedMarble : Int = 0
        
        var columnIndexOfSelectedMarble : Int = 0
        
        for case let stackView as UIStackView in (selectedMarble.superview?.superview?.subviews)! {
            if stackView == selectedMarble.superview {
                break
            }
            rowIndexOfSelectedMarble += 1
        }
        
        
        for case let button as UIButton in (selectedMarble.superview?.subviews)! {
            if button == selectedMarble {
                break
            }
            columnIndexOfSelectedMarble += 1
        }
        
        
        let parentView = selectedMarble.superview
        
        if columnIndexOfSelectedMarble < 6 {
            if let rightCell = parentView?.subviews[columnIndexOfSelectedMarble+1] as? UIButton {
                if rightCell.title(for: .normal) == marblePresent && columnIndexOfSelectedMarble < 5 {
                    if let rightTargetCell = parentView?.subviews[columnIndexOfSelectedMarble+2] as? UIButton {
                        if rightTargetCell.title(for: .normal) == marbleAbsent{
                            rightTargetCell.setTitle(possibleTarget, for: .normal)
                        }
                        else if rightTargetCell.title(for: .normal) == possibleTarget{
                            rightTargetCell.setTitle(marbleAbsent, for: .normal)
                        }
                    }
                }
            }
        }
        
        if columnIndexOfSelectedMarble > 0 {
            if let leftCell = parentView?.subviews[columnIndexOfSelectedMarble-1] as? UIButton {
                if leftCell.title(for: .normal) == marblePresent && columnIndexOfSelectedMarble > 1 {
                    if let leftTargetCell = parentView?.subviews[columnIndexOfSelectedMarble-2] as? UIButton {
                        if leftTargetCell.title(for: .normal) == marbleAbsent{
                            leftTargetCell.setTitle(possibleTarget, for: .normal)
                        }
                        else if leftTargetCell.title(for: .normal) == possibleTarget{
                            leftTargetCell.setTitle(marbleAbsent, for: .normal)
                        }
                    }
                }
            }
        }
        
        let grandParentView = selectedMarble.superview?.superview
        
        if rowIndexOfSelectedMarble > 0 {
            if let topRow = grandParentView?.subviews[rowIndexOfSelectedMarble-1] as? UIStackView {
                if let topCell = topRow.subviews[columnIndexOfSelectedMarble] as? UIButton {
                    if topCell.title(for: .normal) == marblePresent && rowIndexOfSelectedMarble > 1 {
                        if let topTargetRow = grandParentView?.subviews[rowIndexOfSelectedMarble-2] as? UIStackView {
                            if let topTargetCell = topTargetRow.subviews[columnIndexOfSelectedMarble] as? UIButton {
                                if topTargetCell.title(for: .normal) == marbleAbsent{
                                    topTargetCell.setTitle(possibleTarget, for: .normal)
                                }
                                else if topTargetCell.title(for: .normal) == possibleTarget{
                                    topTargetCell.setTitle(marbleAbsent, for: .normal)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if rowIndexOfSelectedMarble < 6 {
            if let bottomRow = grandParentView?.subviews[rowIndexOfSelectedMarble+1] as? UIStackView {
                if let bottomCell = bottomRow.subviews[columnIndexOfSelectedMarble] as? UIButton {
                    if bottomCell.title(for: .normal) == marblePresent && rowIndexOfSelectedMarble < 5 {
                        if let bottomTargetRow = grandParentView?.subviews[rowIndexOfSelectedMarble+2] as? UIStackView {
                            if let bottomTargetCell = bottomTargetRow.subviews[columnIndexOfSelectedMarble] as? UIButton {
                                if bottomTargetCell.title(for: .normal) == marbleAbsent{
                                    bottomTargetCell.setTitle(possibleTarget, for: .normal)
                                }
                                else if bottomTargetCell.title(for: .normal) == possibleTarget{
                                    bottomTargetCell.setTitle(marbleAbsent, for: .normal)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        initScene()
        
    }
    
    /* 
     * Function to reset the state of the game
     */
    func initScene() {
        for marbleButton in marbleButtons {
            marbleButton.setTitle(marblePresent, for: .normal)
            marbleButton.isEnabled = true
        }
        
        // Empty cells
        if let centreMarble = view.subviews[0].subviews[3].subviews[3] as? UIButton {
            centreMarble.setTitle(marbleAbsent, for: .normal)
        }
        
        undoLastMove.isEnabled = false
        
        rowIndexOfSelectedMarble  = 0
        columnIndexOfSelectedMarble  = 0
        
        rowIndexOfSelectedTargetMarble  = 0
        columnIndexOfSelectedTargetMarble  = 0
        
        rowIndexOfRemovedMarble  = 0
        columnIndexOfRemovedMarble  = 0
        
        numMoves = 0
        
        movesButton.setTitle("Moves: \(numMoves)", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


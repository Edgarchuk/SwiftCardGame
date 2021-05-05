//
//  ConcentrationViewController.swift
//  SetGame
//
//  Created by Finch on 05.05.2021.
//

import UIKit

class ConcentrationViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var concenrtation: Concentration = Concentration();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themePicker.delegate = self
        themePicker.dataSource = self
        
        concenrtation.fill(count: buttons.count)
        updateViewFromModel()
    }

    private var lastTapButtonIndex : Int?
    @IBAction func tapCard(_ sender: UIButton) {
        concenrtation.flip(index: buttons.firstIndex(of: sender)!)
        updateViewFromModel()
    }
    @IBAction func newGameTap(_ sender: Any) {
        concenrtation.newGame()
        updateViewFromModel()
    }
    fileprivate func updateButtons() {
        for i in 0..<buttons.count {
            let card = concenrtation[i]
            if card.isFlip == false {
                if card.isMatched {
                    buttons[i].setTitleAndBackgroundColor("",#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                } else {
                    buttons[i].setTitleAndBackgroundColor("",#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
                }
            } else {
                buttons[i].setTitleAndBackgroundColor(card.emoji, #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            }
        }
    }
    
    private func updateViewFromModel() {
        updateButtons()
        scoreLabel.text = "Your score: \(concenrtation.score)"
    }

}

extension ConcentrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Theme.allCases.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Theme.allCases[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        concenrtation.theme = Theme.allCases[row]
    }
    
}

//
//  ViewController.swift
//  ElementQuiz
//
//  Created by SD on 03/03/2025.
//

import UIKit
let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
var currentElementIndex = 0


class ViewController: UIViewController {

    @IBOutlet weak var modeSelector: UISegmentedControl!
    enum Mode {
        case flashCard
        case quiz
    }
    var mode: Mode = .flashCard

    @IBOutlet weak var textInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateElement()
        // Do any additional setup after loading the view.
    }
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
            if currentElementIndex >= elementList.count {
                currentElementIndex = 0
            }
            updateElement()
    }
    @IBAction func showAnswer(_ sender: Any) {
        answerLabel.text =
           elementList[currentElementIndex]
    }
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var elementImage: UIImageView!
    func updateElement() {
        let elementName =
           elementList[currentElementIndex]
        
        let image = UIImage(named: elementName)
        elementImage.image = image
        answerLabel.text = "?"
    }

}


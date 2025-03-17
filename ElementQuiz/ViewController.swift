import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
        }
    }
    var state: State = .question
    
    var answerIsCorrect = false
    var score = 0

    func updateUI() {
        let elementName = elementList[currentElementIndex]
    
        if let image = UIImage(named: elementName) {
            imageView.image = image
        }
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    
    func updateFlashCardUI(elementName: String) {
        textField.isHidden = true
        textField.resignFirstResponder()

        if state == .answer {
            answerLabel.text =
            elementList[currentElementIndex]
            state = .question
        } else if state == .question {
            answerLabel.text = "?"
        } else {
            answerLabel.text = ""
            print("Your score is: \(score) out of \(elementList.count).")
        }
    }
    
    func updateQuizUI(elementName: String) {
        textField.isHidden = false

        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌"
            }
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField:
       UITextField) -> Bool {
        var textFieldContents = textField.text!
        textFieldContents = textFieldContents.lowercased()
        if  textFieldContents == elementList[currentElementIndex].lowercased(){
            answerIsCorrect = true
            score += 1
        } else {
            answerIsCorrect = false
        }
        state = .answer
        updateUI()
        return true
    }
    
    
    @IBAction func showAnswerBtn(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    @IBAction func nextElementBtn(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count
           {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
    }

    
    @IBAction func switchSelector(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
}

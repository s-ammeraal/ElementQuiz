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
        var elementName = ""
        if (currentElementIndex < elementList.count) {
            elementName = elementList[currentElementIndex]
        }
        
        if let image = UIImage(named: elementName) {
            imageView.image = image
        }
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            if (currentElementIndex < elementList.count) {
                updateQuizUI(elementName: elementName)
            } else {
                displayScoreAlert()
            }
        }
    }
    
    func updateFlashCardUI(elementName: String) {
        modeSelector.selectedSegmentIndex = 0

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
        modeSelector.selectedSegmentIndex = 1

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
            displayScoreAlert()
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
            if mode == .quiz {
                state = .score
                updateUI()
                return
            } else {
                currentElementIndex = 0
            }
        }
        updateUI()
    }

    
    @IBAction func switchSelector(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    func displayScoreAlert() {
        let alert = UIAlertController(title:
           "Quiz Score",
           message: "Your score is \(score) out of \(elementList.count).",
              preferredStyle: .alert)
        let dismissAction =
           UIAlertAction(title: "OK",
           style: .default, handler:
           scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        present(alert, animated: true,
           completion: nil)
    }
    func scoreAlertDismissed(_ action: UIAlertAction) {
        currentElementIndex = 0
        mode = .flashCard
    }
    
}

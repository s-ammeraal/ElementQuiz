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
        mode = .flashCard
    }
    
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!

    let fixedElementList = ["Carbon", "Gold",
       "Chlorine", "Sodium"]
    var elementList: [String] = []
    
    var currentElementIndex = 0
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupQuiz()
            }
            updateUI()
        }
    }
    var state: State = .question
    
    var answerIsCorrect = false
    var score = 0

    func setupFlashCards() {
        elementList = fixedElementList
        state = .question
        currentElementIndex = 0
    }
    func setupQuiz() {
        elementList = fixedElementList.shuffled()
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        score = 0
    }

    
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
        
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
        
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
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score",
               for: .normal)
        } else {
            nextButton.setTitle("Next Question",
               for: .normal)
        }
        
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
        
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌\nCorrect Answer: " +
                   elementName
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

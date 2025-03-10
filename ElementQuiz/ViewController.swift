import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
}

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlashCardUI()
    }
    
    @IBAction func modeSelector(_ sender: Any) {
    }
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    var mode: Mode = .flashCard
    var state: State = .question
    var answerIsCorrect = false
    var score = 0
    
    func updateUI() {
        switch mode {
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }
    
    func updateFlashCardUI() {
        let elementName = elementList[currentElementIndex]
    
        if let image = UIImage(named: elementName) {
            imageView.image = image
        }
        
        if state == .answer {
            answerLabel.text =
            elementList[currentElementIndex]
            state = .question
        } else {
            answerLabel.text = "?"
        }
    }
    
    func updateQuizUI() {
        
    }
    
    @IBAction func showAnswerBtn(_ sender: Any) {
        state = .answer
        updateFlashCardUI()
    }
    
    @IBAction func nextElementBtn(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        
        updateFlashCardUI()
    }
    
}

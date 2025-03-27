import UIKit

class TriviaViewController: UIViewController {

  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!

  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private var questionsLoaded = false
  private let triviaService = TriviaQuestionService()

  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    fetchQuestions()
  }

  private func fetchQuestions() {
    questionsLoaded = false
    triviaService.fetchTriviaQuestions { [weak self] fetchedQuestions in
      guard let self = self else { return }
      self.questions = fetchedQuestions
      self.currQuestionIndex = 0
      self.numCorrectQuestions = 0
      self.questionsLoaded = !self.questions.isEmpty
      if self.questionsLoaded {
        self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
      }
    }
  }

  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    guard questionIndex < questions.count else { return }
    let question = questions[questionIndex]
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    questionLabel.text = question.question
    categoryLabel.text = question.category

    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
    let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]

    for (index, button) in buttons.enumerated() {
      if index < answers.count {
        button?.setTitle(answers[index], for: .normal)
        button?.isHidden = false
        button?.isEnabled = true
      } else {
        button?.isHidden = true
      }
    }
  }

  private func updateToNextQuestion(answer: String) {
    guard questionsLoaded, currQuestionIndex < questions.count else { return }

    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }

    currQuestionIndex += 1
    if currQuestionIndex < questions.count {
      updateQuestion(withQuestionIndex: currQuestionIndex)
    } else {
      showFinalScore()
    }
  }

  private func isCorrectAnswer(_ answer: String) -> Bool {
    guard currQuestionIndex < questions.count else { return false }
    return answer == questions[currQuestionIndex].correctAnswer
  }

  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
      self?.fetchQuestions()
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }

  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [
      UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
      UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  // MARK: - IBActions

  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }

  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }

  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }

  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

//
//  QuestionsViewController.swift
//  PersonalQuiz
//
//  Created by Виталий on 05.03.2021.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var quiestionProgressView: UIProgressView!
    @IBOutlet var rangeSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangeSlider.maximumValue = answerCount
            rangeSlider.value = answerCount / 2
        }
    }
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var rangeStackView: UIStackView!
    
    @IBOutlet var singleButtons: [UIButton]!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    @IBOutlet var rangedLabels: [UILabel]!
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answersChoosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultsVC = segue.destination as? ResultsViewController {
            resultsVC.answersChoosen = answersChoosen
        }
    }
    
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else {
            return
        }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChoosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleButtonAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChoosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangeButtonAnswerPressed() {
        let index = lrintf(rangeSlider.value)
        answersChoosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
}

// MARK: - Private methods
extension QuestionsViewController {
    private func updateUI() {
        for stackView in [singleStackView, multipleStackView, rangeStackView] {
            stackView?.isHidden = true
        }
        
        let currentQuestion = questions[questionIndex]
        
        questionLabel.text = currentQuestion.text
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        quiestionProgressView.setProgress(totalProgress, animated: true)
        
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Show stacks corresponding to question type
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .range: showRangeStackView(with: currentAnswers)
        }
    }
    
    /// Show single stack view
    ///
    /// - Parameter answer: array with answers
    ///
    /// Show single stack view with answers for current answers
    ///
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func showRangeStackView(with answers: [Answer]) {
        rangeStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}

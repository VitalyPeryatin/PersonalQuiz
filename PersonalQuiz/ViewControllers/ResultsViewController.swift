//
//  ResultsViewController.swift
//  PersonalQuiz
//
//  Created by Виталий on 05.03.2021.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet var resulLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var answersChoosen: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        var animalTypeCounters: [AnimalType:Int] = [:]
        
        for answer in answersChoosen {
            if let animalTypeCount = animalTypeCounters[answer.type] {
                animalTypeCounters[answer.type] = animalTypeCount + 1
            } else {
                animalTypeCounters[answer.type] = 0
            }
        }
        
        let animalResult: AnimalType? = animalTypeCounters.max { $0.value < $1.value }?.key
        
        if let animalResult = animalResult {
            resulLabel.text = "Вы - \(animalResult.rawValue)"
            descriptionLabel.text = animalResult.definition
        }
    }
    
}

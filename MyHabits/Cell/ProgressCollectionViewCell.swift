//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 16.05.2022.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    //MARK: - Let/var
    let store = HabitsStore.shared
    //MARK: - @IBOutlet
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
           super.awakeFromNib()
           backgroundColor = .white
           clipsToBounds = true
           layer.cornerRadius = 4
        
        progressBar.progress = store.todayProgress
        percentLabel.text = "\(store.todayProgress.description) % "
        
        
    }
}

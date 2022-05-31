//
//  DetailsTableViewCell.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 18.05.2022.
//

import UIKit
import Foundation
class DetailsTableViewCell: UITableViewCell {
    //MARK: - Let/var
    var habit: Habit?
    let store = HabitsStore.shared
    var habitShared = HabitsStore.shared.habits
    var dates: [String] = []
    
    @IBOutlet weak var tableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if ((habit?.isAlreadyTakenToday) != nil) {
            tableLabel.text = habit?.trackDates.description
        } else {
            tableLabel.text = "No data sorry"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

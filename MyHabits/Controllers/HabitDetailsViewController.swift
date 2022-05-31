//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 18.05.2022.
//

import UIKit



class HabitDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var habitName: UILabel!
    @IBOutlet weak var numDays: UILabel!
    @IBOutlet weak var streak: UILabel!
    var store = HabitsStore.shared
    var storeDetail = HabitsStore.shared.dates
    var habit: Habit?
    var dates: [String] = []
//    var streak = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emoji.text = habit?.emoji
        habitName.text = habit?.name
        numDays.text = habit?.dateString
        streak.text = habit?.streak.description
      
    }
    ///navigation to Ediit Habit VC
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem, indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditHabbitViewController") as? EditHabbitViewController else
        { return }
        self.performSegue(withIdentifier: "EditHabbitViewController", sender: store.habits[indexPath.item])
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func step(_ sender: UIStepper) {
        let val = Int(sender.value)
        
        if val >= 0 {
            let current = Date()
            let currentDateString = getDateString(date: current)
            
            // check if last day tracked was previous day
            var dateComponents = DateComponents()
            dateComponents.month = 0
            dateComponents.day = -1
            dateComponents.year = 0
            
            let oldDate = Calendar.current.date(byAdding: dateComponents, to: current)!
            let oldDateString = getDateString(date: oldDate)
            
            if dates.count == 0 {
                numDays.text = "Total Days: \(val)"
                
                let newVal = habit!.streak + 1
                habit!.streak = newVal
                streak.text = "\(newVal) Day Streak!"
                // add new date to days tracked
                dates.insert(currentDateString, at: 0)
            } else {
                       
                // increase total days if current day is not the same as last day tracked
                if currentDateString != dates[0] {
                    numDays.text = "Total Days: \(val)"
                    // add new date to days tracked
                    dates.insert(currentDateString, at: 0)
                }
                
                // increase streak if last tracked date was yesterday
                if oldDateString == dates[0] {
                    let newVal = habit!.streak + 1
                    habit!.streak = newVal
                    streak.text = "\(newVal) Day Streak!"
                    
                    if newVal >= 10 {
                        streak.backgroundColor = UIColor.green
                    }
                }
            }
            self.tableView.reloadData()
        }
}
}

///stepper
    func getDateString(date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }



//MARK: - Extension Table Delegate, Table DataSource
extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // table view methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath)
        cell.textLabel!.text = dates[indexPath.row]
        return cell
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                dates.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if segue.identifier == "EditHabbitViewController" {
    if let habitInfo = sender as? Habit {
        if let editVC = segue.destination as? EditHabbitViewController {
            editVC.delegate = self
            editVC.habit = habitInfo
        }
    }
}
}
}

extension HabitDetailsViewController : EditHabitViewControllerDelegate {
    func saveEditHabit(_ habit: Habit) {
        store.save()
    }
}
    

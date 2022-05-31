//
//  HabitEditViewController.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 18.05.2022.
//

import UIKit

protocol EditHabitViewControllerDelegate: AnyObject {
    func saveEditHabit(_ habit: Habit)
}

class EditHabbitViewController: UIViewController {
    //MARK: - IBOutlet
    let store = HabitsStore.shared
     var habits: [Habit] = []
    var habit: Habit?
    ///navigation bar
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    ///bot screen
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    ///top screen
    @IBOutlet weak var dateStackLabel: UILabel!
    @IBOutlet weak var currentTimeStackLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate: EditHabitViewControllerDelegate?
    
        //MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        colorButton.layer.cornerRadius = colorButton.frame.size.height / 2
//        textField.placeholder = Habit.name
        }
        
        //MARK: - Methods
        ///Кнопка  выбора времени для новой привычки.
        @IBAction func datePickerFormatter(_ sender: UIDatePicker) {
           let date = sender.date
    print(date)
            
          let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            currentTimeStackLabel.text = formatter.string(from: date)
   
        }
        ///Кнопка выбора цвета для новой привычки.
        @IBAction func changedColorButtonPressed(_ sender: UIButton) {
            selectColor()
        }
        
    ///Кнопка сохранения  новой привычки
        @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
            delegate?.saveEditHabit(habit!)
            dismiss(animated: true)
        }
    
    ///Скрыть окно добавления привычки.
        @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
            self.dismiss(animated: true, completion: nil)
        }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
                // create the alert
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(nameLabel.description)?", preferredStyle: UIAlertController.Style.alert)
        
                // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive, handler: nil))
        self.habit?.trackDates.remove(at: 1)
                alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
        
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
    }



    //MARK: - Extension UITextFieldDelegate
    extension EditHabbitViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         hidekeyboard()
            return true
        }
        func hidekeyboard() {
            textField.resignFirstResponder()
                
            }
                }

    extension EditHabbitViewController: UIColorPickerViewControllerDelegate {
        func selectColor() {
    let colorPickerVc = UIColorPickerViewController()
    colorPickerVc.delegate = self
    present(colorPickerVc, animated: true)
    }
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            let color = viewController.selectedColor
            colorButton.backgroundColor = color
        }
    }

    extension EditHabbitViewController: UIPickerViewDelegate {
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        }
    }

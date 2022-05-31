//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 13.05.2022.
//

import UIKit
///Делегат создания новой привычки
protocol AddHabitDelegate: AnyObject {
    func didCreate(_ habit: Habit)
}

///Добавление новой привычки
class AddHabitViewController: UIViewController {
    
//MARK: - IBOutlet
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emojiField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateStackLabel: UILabel!
    @IBOutlet weak var currentTimeStackLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    let store = HabitsStore.shared
    var date: [Date] = []
    weak var delegate: AddHabitDelegate?
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ///rounded view.
        colorButton.layer.cornerRadius = colorButton.frame.size.height / 2
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
    
///Кнопка сохранения  новой привычки в список привычек
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let newHabit =
        Habit(name: textField.text!.capitalized, emoji: emojiField.text!,
                  date: datePicker.date, trackDates: date, streak: 0,
                 color: colorButton.backgroundColor!)
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        store.save()
        print("67 строка Habit. Создаём новую привычку \(String(describing: newHabit.name)), добавляем её в стораж привычек.")
        dismiss(animated: true, completion: nil)
    }
    
///Скрыть окно добавления привычки.
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Extension  + hideKeyBoard
extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     hidekeyboard()
        return true
    }
    func hidekeyboard() {
        textField.resignFirstResponder()
        }
            }

//MARK: - Extension + UIColorPicker
extension AddHabitViewController: UIColorPickerViewControllerDelegate {
///Вызов Колор-Пикера и заверщающая функция выбора цвета.
func selectColor() {
let colorPickerVc = UIColorPickerViewController()
colorPickerVc.delegate = self
present(colorPickerVc, animated: true)
    
}
    ///Смена цвета ColorButton
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
}
//MARK: - Extension UIPicker
extension AddHabitViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        let date = datePicker.date
// print(date)
//       let formatter = DateFormatter()
//         currentTimeStackLabel.text = formatter.string(from: date)
    }
}

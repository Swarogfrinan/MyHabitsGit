import UIKit

///Протокол сохранения изменённой привычки.
protocol EditHabitViewControllerDelegate: AnyObject {
    func saveEditHabit(_ habit: Habit)
}

class EditHabbitViewController: UIViewController {
    
    //MARK: - Property
    let store = HabitsStore.shared
    var habit: Habit? {
        
        didSet {
            
            textField.text = habit?.name
            textField.textColor = habit?.color
            emojiTextField.text = habit?.emoji
            colorButton.backgroundColor = habit?.color
            datePicker.date = habit?.date ?? Date()
        }
    }
    
    //MARK: - IBOutlets
    ///navigation bar - buttons
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    ///bot screen IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emojiTextField: EmojiTextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    ///top screen IBOutlet
    @IBOutlet weak var dateStackLabel: UILabel!
    @IBOutlet weak var currentTimeStackLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate: EditHabitViewControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Уменьшение тайтла при прокрутке скрина.
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTitles()
    }
    
    //MARK: - IBAction methods
    
    ///Кнопка  выбора времени для новой привычки.
    
    @IBAction func datePickerFormatter(_ sender: UIDatePicker) {
        let date = sender.date
        print(date)
        ///Выбор формата времени Часы:Минуты
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
//        delegate?.saveEditHabit(habit!)
        let newHabit = Habit(name: textField.text ?? "No habbit name", emoji: emojiTextField.text ?? ":)", date: datePicker.date, streak: 0, color: colorButton.backgroundColor ?? .orange )
        
        for (index, storageHabit) in store.habits.enumerated() {
           if storageHabit.name == habit?.name {
                newHabit.emoji = storageHabit.emoji
                newHabit.color = storageHabit.color
                newHabit.trackDates = storageHabit.trackDates
                newHabit.streak = storageHabit.streak
                
                store.habits[index] = newHabit
                habit? = newHabit
            }
        }
        
        dismiss(animated: true)
    }
    
    ///Скрыть окно добавления привычки.
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
       showAlert()
    }
    
    
    //MARK: - Methods
    
    ///Delete Habbit.
    private func delete() {
        self.habit?.trackDates.removeAll()
        self.store.habits.removeAll()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlert() {
      
        let alert = UIAlertController(title: "Removing habit", message: "Do you want to remove habit \(String(describing: nameLabel.text))?", preferredStyle: .alert)
     
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            for (index, _) in self.store.habits.enumerated() {
//                if storageHabit.name == self.habit?.name {
//                    self.habit?.trackDates.remove(at: index)
                    self.store.habits.remove(at: index)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 , execute: {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                        let vc = HabitsViewController()
                        self.navigationController?.popToViewController(vc, animated: true)
                    })
//                }
            }
        }))
     
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupTitles() {
        colorButton.layer.cornerRadius = colorButton.frame.size.height / 2
        nameLabel.text = habit?.name
    }
}



//MARK: -  UITextFieldDelegate

extension EditHabbitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hidekeyboard()
        return true
    }
    
    func hidekeyboard() {
        textField.resignFirstResponder()
    }
    
    
}

//MARK: -  UIColorPickerViewControllerDelegate

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

//MARK: -  UIPickerViewDelegate

extension EditHabbitViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

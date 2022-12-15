import UIKit

///Протокол сохранения изменённой привычки.
protocol EditHabitViewControllerDelegate: AnyObject {
    func saveEditHabit(_ habit: Habit)
}

class EditHabbitViewController: UIViewController {
    
    //MARK: - let/var
    let store = HabitsStore.shared
    var habit: Habit?
    
    //MARK: - IBOutlets
    ///navigation bar - buttons
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    ///bot screen IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: EmojiTextField!
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
        delegate?.saveEditHabit(habit!)
        dismiss(animated: true)
    }
    
    ///Скрыть окно добавления привычки.
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        /// Create the alert
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(nameLabel.text)?", preferredStyle: UIAlertController.Style.alert)
        /// add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive, handler: { action in
            self.delete()
        }))
        ///Cancel button
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
        /// show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Methods
    
    ///Delete Habbit.
    private func delete() {
        self.habit?.trackDates.removeAll()
        self.store.habits.removeAll()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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

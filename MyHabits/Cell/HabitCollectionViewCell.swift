import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
   
    //MARK: - Let/var
    var habit: Habit?
    let store = HabitsStore.shared
    var habitShared = HabitsStore.shared.habits
    var dates: [String] = []
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var dailyTimeTaskLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
           super.awakeFromNib()
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 4
        
        setupCircleView()
        setupGesture()
    }
    
    //MARK: - Methods
    func setupCircleView() {
        ///Устанавливаем цвет кругу.
        if circleView.layer.borderColor != UIColor.white.cgColor {
        circleView.layer.borderColor = habit?.color.cgColor
        } else {
            circleView.layer.borderColor = UIColor.black.cgColor
            circleView.layer.borderWidth = 4
            emojiLabel.textColor = .white
        }
        
        circleView.backgroundColor = .white
        circleView.layer.borderWidth = 4
        circleView.frame.size.width = 60
        circleView.frame.size.height = 60
        circleView.layer.cornerRadius = circleView.frame.size.height / 2
    }
    
    func checkHabit() {
        circleView.layer.backgroundColor = circleView.layer.borderColor
      circleView.layer.borderWidth = 0
//        store.track(habit?.trackDates)
        UIView.animate(withDuration: 0.3) { [self] in
            ///setup success check-mark in centre circleView
            emojiLabel.text = "✓"
            emojiLabel.textColor = .white
            ///if white habit-color choosed.
            ///
//            if circleView.layer.borderColor != UIColor.white.cgColor {
//                ///setup black border and change check-mark  color to black.
//                emojiLabel.textColor = .black
//                circleView.layer.borderColor = UIColor.black.cgColor
//                circleView.layer.borderWidth = 4
//
//            } else {
//                emojiLabel.textColor = .black
                circleView.layer.borderColor = self.habit?.color.cgColor
            }
      }
    
   private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCircleAction))
        circleView.addGestureRecognizer(tapGesture)
    }
  

    //MARK: - Gesture
    
        @objc private func tapCircleAction(gesture: UITapGestureRecognizer) {
         
            UIView.animate(withDuration: 0.3) {
                self.checkHabit()
        
        }
        }
}

    
    



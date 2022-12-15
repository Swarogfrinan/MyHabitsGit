import UIKit

class InfoViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textInfoView: UITextView!

    //MARK: - Property
    
    let heightScreen : CGFloat = UIScreen.main.bounds.height
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfoText()
    }
    //MARK: - Methods
    func setupInfoText() {
        textInfoView.text = "21 Day Habit. The passage of the stages for which a habit is developed in 21 days is subject to the following algorithm: 1. Spend one day without reverting to old habits, try to act as if the goal is in perspective, to be within walking distance. 2. Maintain 2 days in the same state of self-control. 3. Mark in the diary the first week of changes and sum up the first results - what turned out to be difficult, what was easier, what still has to be seriously fought. 4. Congratulate yourself on passing your first major threshold at 21 days. During this time, the rejection of bad inclinations will already take the form of a conscious overcoming and a person will be able to work more towards the adoption of positive qualities. 5. Hold the plank for 40 days. The practitioner of the technique already feels freed from past negativity and is moving in the right direction with good dynamics. 6. On the 90th day of observing the technique, everything superfluous from the “past life” ceases to remind of itself, and a person, looking back, realizes himself completely renewed. Source: psychbook.ru".localized()
    }
}

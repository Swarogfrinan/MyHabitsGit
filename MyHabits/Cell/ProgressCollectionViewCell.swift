import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Let/var
    
    let store = HabitsStore.shared
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    var progressLevel: Float? {
        
        didSet {
            progressBar.progress = progressLevel ?? 0
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
           super.awakeFromNib()
           backgroundColor = .white
           clipsToBounds = true
           layer.cornerRadius = 4
        
        progressBar.progress = store.todayProgress
        progressBar.progressTintColor = .purple
        
        percentLabel.text = "\(Int(store.todayProgress*100))%"
    }
}

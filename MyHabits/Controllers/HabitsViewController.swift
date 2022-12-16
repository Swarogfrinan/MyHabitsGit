import UIKit

class HabitsViewController: UIViewController, AddHabitDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var habitsCollectionView: UICollectionView!
    @IBOutlet weak var addHabbitButton: UIBarButtonItem!
    
    //MARK: - Property
    
    let store = HabitsStore.shared
    var habits: [Habit] = []
    
    ///filtered search results
    var filtered: [Habit] = []
    var isSearching = false
        
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
    }
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        reloadHabbit()
    }
    
    //MARK: - IBAction Methods
    
    ///Вызывывает  всплывающее окно добавления новой привычки в приложение.
    @IBAction func addHabitButtonPressed(_ sender: UIBarButtonItem) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddHabitViewController") as? AddHabitViewController else
        { return }
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    
    ///Добавление привычки в главный экран коллекции в зависимости от результатов сортировки Даты выполнения привычки.
    func didCreate(_ habit: Habit) {
        dismiss(animated: true, completion: nil)
        habits.append(habit)
        habits.sort{ (habit1, habit2) -> Bool in
            habit1.dateString < habit2.dateString
        }
        ///перезагрузка даты коллекции привычек.
        reloadHabbit()
    }
    
    func reloadHabbit() {
        habitsCollectionView.reloadData()
        self.view.layoutIfNeeded()
    }
}

//MARK: - SearchBar

extension HabitsViewController : UISearchBarDelegate {
    
    // search bar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!.lowercased()
        let currentResults = habits.filter { h in
            return h.name.lowercased().contains(text) || h.emoji.lowercased().contains(text) ||
            h.date.formatted().lowercased().contains(text)
        }
        
        filtered = currentResults
        self.isSearching = true
        self.habitsCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.isSearching = false
            self.habitsCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.isSearching = false
            self.habitsCollectionView.reloadData()
        }
    }
}




//MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //add your frame height here
        return CGSize(width: collectionView.frame.width, height: 64)
    }
}

//MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
        header.progressLevel = store.todayProgress
        header.percentLabel.text = "\(Int((header.progressLevel ?? 0) * 100))%"
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filtered.count : store.habits.count
    }
    
   
    ///Условия для успешного возвращения хедера
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath)
        let habit = isSearching ? filtered[indexPath.item] : store.habits[indexPath.item]
        
        if let name = cell.viewWithTag(1) as? UILabel {
            name.text = habit.name
            name.textColor = habit.color
        }
        
        if let date = cell.viewWithTag(2) as? UILabel {
            date.text = habit.dateString
        }
        
        if let streak = cell.viewWithTag(3) as? UILabel {
            streak.text = "Day Streak : \(habit.streak.description)"
        }
        
        if let emoji = cell.viewWithTag(4) as? UILabel {
            emoji.text = habit.emoji
        }
        
        if let color = cell.viewWithTag(5) {
            color.layer.borderColor = habit.color.cgColor
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension HabitsViewController: UICollectionViewDelegate {
    
    ///Тап по привычке, переход в Детальное описание привычки.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        habitsCollectionView.deselectItem(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "habitDetailVC", sender: store.habits[indexPath.item])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "habitDetailVC" {
            if let habitInfo = sender as? Habit {
                if let detailVC = segue.destination as? HabitDetailsViewController {
                    detailVC.habit = habitInfo
                }
            }
            
        } else if segue.identifier == "AddHabitViewController" {
            if let navVC = segue.destination as? UINavigationController {
                if let addVC = navVC.topViewController as? AddHabitViewController {
                    addVC.delegate = self
                }
    }
   }
    }
 
}


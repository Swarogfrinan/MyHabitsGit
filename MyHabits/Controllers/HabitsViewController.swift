//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 13.05.2022.
//

import UIKit

///Контроллер с привычками и возможностью их добавления
class HabitsViewController: UIViewController, AddHabitDelegate, UISearchBarDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var habitsCollectionView: UICollectionView!
    @IBOutlet weak var addHabbitButton: UIBarButtonItem!
 
    //MARK: - Let/var
   let store = HabitsStore.shared
    var habits: [Habit] = []
    ///filtered search results
    var filtered: [Habit] = []
    var isSearching = false
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
        habitsCollectionView.reloadData()

    }
    
    public func reloadHabbit() {
    habitsCollectionView.reloadData()
    }
    
    //MARK: - Methods
    ///Вызывывает  всплывающее окно добавления новой привычки в приложение.
    @IBAction func addHabitButtonPressed(_ sender: UIBarButtonItem) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddHabitViewController") as? AddHabitViewController else
        { return }
        self.present(controller, animated: true, completion: nil)
    }
    ///Добавление привычки в главный экран коллекции в зависимости от результатов сортировки Даты выполнения привычки.
    func didCreate(_ habit: Habit) {
        dismiss(animated: true, completion: nil)
        habits.append(habit)
        habits.sort{ (habit1, habit2) -> Bool in
  habit1.dateString < habit2.dateString
        }
    ///перезагрузка даты коллекции привычек.
        self.habitsCollectionView.reloadData()
    }
    
    //MARK: - SearchBar
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



//MARK: - Extension+Flowlayout header
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //add your frame height here
        return CGSize(width: collectionView.frame.width, height: 64)
    }
}
//MARK: - Extension DataSource, Delegate
extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
    ///Количество секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    ///Условия для успешного возвращения хедера
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return isSearching ? filtered.count : store.habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProgressCell", for: indexPath) as! ProgressCollectionViewCell
          return header
      }
    ///Условия для успешного возвращения хедера
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath)
        let habit = isSearching ? filtered[indexPath.item] : store.habits[indexPath.item]
        
            if let name = cell.viewWithTag(1) as? UILabel {
                name.text = habit.name
            }
        
            if let emoji = cell.viewWithTag(2) as? UILabel {
                emoji.text = habit.emoji
            }
            if let dateString = cell.viewWithTag(3) as? UILabel {
                dateString.text = habit.dateString
            }
            if let color = cell.viewWithTag(4) {
                color.layer.borderColor = habit.color.cgColor
            }
            
            return cell
        }
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


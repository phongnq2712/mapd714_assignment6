/**
 * Assignment 6
 * File Name:    ViewController.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 2nd, 2021
 */

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let ref = Database.database().reference()
    private var tasks: [Todo] = []
    let tableIdentifier = "tasksTable"
    
    func loadData() {
        var flag = true
        // load table view
        ref.observe(.value) { snapshot in
            // 2
            var newItems: [String] = []
            // 3
            for child in snapshot.children {
                // 4
                if
                    let snapshot = child as? DataSnapshot,
                    let dataChange = snapshot.value as? [String:AnyObject],
                    let notes = dataChange["notes"] as? String?,
                    let isCompleted = dataChange["isCompleted"] as? Bool?,
                    let hasDueDate = dataChange["hasDueDate"] as? Bool?,
                    let dueDate = dataChange["dueDate"] as? String?,
                    let taskItem =  dataChange["name"] as? String {

                    if(notes != nil) {
                        var item = ""
                        // notes
                        item.append(taskItem + "-" + notes!)
                        // isCompleted
                        if(isCompleted != nil) {
                            let rs = isCompleted! ? 1 : 0
                            item.append("-" + String(rs))
                        }
                        // hasDueDate
                        if(hasDueDate != nil) {
                            let rs = hasDueDate! ? 1 : 0
                            item.append("-" + String(rs))
                        }
                        // dueDate
                        if(!dueDate!.isEmpty) {
                            item.append("-" + dueDate!)
                        }
                        newItems.append(item)
                    } else {
                        newItems.append(taskItem)
                    }
                }
            }
            // 5
            while (flag) {
                for i in newItems {
                    print(i)
                    let components = i.components(separatedBy: "-")
                    for n in 0...components.count - 1 {
                        if(components.count > 4) {
                            // hasDueDate
                            if(!components[4].isEmpty) {
                                if(components[3] == "0") {
                                    if(components[2] == "0") {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: false, dueDate: components[4], isCompleted: false))
                                    } else {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: false, dueDate: components[4], isCompleted: true))
                                    }
                                } else {
                                    if(components[2] == "0") {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: true, dueDate: components[4], isCompleted: false))
                                    } else {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: true, dueDate: components[4], isCompleted: true))
                                    }
                                }
                            } else {
                                if(components[3] == "0") {
                                    if(components[2] == "0") {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: false, isCompleted: false))
                                    } else {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: false, isCompleted: true))
                                    }
                                } else {
                                    if(components[2] == "0") {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: true, isCompleted: false))
                                    } else {
                                        self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: true, isCompleted: true))
                                    }
                                }
                            }
                            break
                        } else if(components.count > 3) {
                            // hasDueDate
                            if(components[3] == "0") {
                                if(components[2] == "0") {
                                    self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: false, isCompleted: false))
                                } else {
                                    self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: false, isCompleted: true))
                                }
                            } else {
                                if(components[2] == "0") {
                                    self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: true, isCompleted: false))
                                } else {
                                    self.tasks.append(Todo(name: components[0], notes: components[1], hasDueDate: true, isCompleted: true))
                                }
                            }
                            break
                        } else if(components.count > 2) {
                            // isCompleted
                            if(components[2] == "0") {
                                self.tasks.append(Todo(name: components[0], notes: components[1], isCompleted: false))
                            } else {
                                self.tasks.append(Todo(name: components[0], notes: components[1], isCompleted: true))
                            }
                            break
                        } else if(components.count > 1) {
                            // notes
                            self.tasks.append(Todo(name: components[0], notes: components[1]))
                            break
                        } else {
                            // only name
                            self.tasks.append(Todo(name: components[0]))
                        }
                    }
                }
                self.tableView.reloadData()
                flag = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    /**
     * Handling event for Add button (add a new task)
     */
    @objc private func didTapAdd()
    {
        let alert = UIAlertController(title: "New Item", message: "Enter New To Do Item", preferredStyle: .alert)
        alert.addTextField{field in
            field.placeholder = "Enter item"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self](_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    // enter new to do list item
                    self!.ref.child(text).setValue([
                        "name": text
                    ])
                    DispatchQueue.main.async {
                        let newEntry = [text]
                        UserDefaults.standard.setValue(newEntry, forKey: "")
                        self?.tasks.append(Todo(name: text))
                        self?.tableView.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
      
}

extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let completeAction = UITableViewRowAction(style: .default, title: "Complete") { action, indexPath in
            // Mark 'Completed' for this task
            let cell = self.tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            let rowData = self.tasks[indexPath.row]
            cell.dueDate = "Completed"
            cell.backgroundColor = UIColor.systemGray5
            // update 'isCompleted' = true
            self.updateSwipeLeft(taskName: rowData.name)
//            if(rowData.isCompleted) {
//                cell.dueDate = "Completed"
//            } else {
//                if(rowData.dueDate.isEmpty) {
//                    cell.dueDate = ""
//                } else {
//                    cell.dueDate = rowData.dueDate
//                }
//            }
            self.tableView.cellForRow(at: indexPath)
        }
        completeAction.backgroundColor = .yellow
                
        return [completeAction]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.pressButton(index: indexPath.row)
        }
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func updateSwipeLeft(taskName: String)
    {
        let ref = self.ref.child(taskName)
        ref.updateChildValues([
            "isCompleted": true
        ])
    }
}

extension ViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Step 1 - Instantiate an object of type UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! CustomTableViewCell
        let rowData = tasks[indexPath.row]
        //cell.name = rowData["Name"]!
        cell.name = rowData.name
        if(rowData.isCompleted)
        {
            cell.backgroundColor = UIColor.systemGray5
            cell.dueDate = "Completed"
        }

        // Add Edit button target (add target only once when the cell is created)
//        cell.editButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
//        cell.editButton.tag = indexPath.row
        
        // switch view
//        let switchView = UISwitch(frame: .zero)
//        switchView.setOn(false, animated: true)
//        switchView.tag = indexPath.row
//        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
//        cell.accessoryView = switchView
        // swipe right
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeRight.direction = .right
//        cell.addGestureRecognizer(swipeRight)
//        swipeRight.view?.tag = indexPath.row
        
        // swipe left
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeLeft.direction = .left
//        self.view.addGestureRecognizer(swipeLeft)
    
        return cell
    }
    
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction {
//            case .right:
//                print("Swiped right")
//                //pressButton(gesture)
//            case .left:
//                print("Swiped left")
//            default:
//                break
//            }
//        }
//    }
    
    /**
     * Selector for changing value of switch 'Due Date'
     */
    func switchChanged(index: Int)
    {
        // get indexPath for current cell
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            let cell = self.tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            let rowData = tasks[index]
//            if(sender.isOn)
//            {
                if(rowData.isCompleted) {
                    cell.dueDate = "Completed"
                } else {
                    if(rowData.dueDate.isEmpty) {
                        cell.dueDate = ""
                    } else {
                        cell.dueDate = rowData.dueDate
                    }
                }
//            } else {
//                cell.dueDate = ""
//            }
            self.tableView.cellForRow(at: indexPath)
        }
    }
    
    /**
     * Selector for pressing button Edit
     */
    func pressButton(index: Int) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            vc.taskNameText = tasks[index].name
            vc.notesText = tasks[index].notes
            vc.isCompletedText = tasks[index].isCompleted
            vc.hasDueDateText = tasks[index].hasDueDate
            
            if(!tasks[index].dueDate.isEmpty) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YY/MM/dd"
                let dueDate = dateFormatter.date(from:tasks[index].dueDate)
                vc.dueDateText = dueDate
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

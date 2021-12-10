/**
 * Assignment 6
 * File Name:    ViewController.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 10th, 2021
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
    /**
     * Swipe right to left
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: "Complete") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            // Mark 'Completed' for this task
            let cell = self.tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            let rowData = self.tasks[indexPath.row]
            cell.dueDate = "Completed"
            self.tasks[indexPath.row].isCompleted = true
            cell.backgroundColor = UIColor.systemGray5
            // update 'isCompleted' = true
            self.updateSwipeLeft(taskName: rowData.name)
            self.tableView.cellForRow(at: indexPath)
            self.tableView.setEditing(false, animated: true)
        }
        completeAction.backgroundColor = .yellow

        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let rowData = self.tasks[indexPath.row]
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.remove(child: rowData.name)
            
            self.tableView.cellForRow(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
//        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    /**
     *  Swipe left to right
     */
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.pressButton(index: indexPath.row)
            self.tableView.setEditing(false, animated: true)
        }
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    /**
     * Hanling for 'Delete' long swipe button from right to left
     */
    func remove(child: String) {
        let ref = self.ref.child(child)
        ref.removeValue { error, _ in
            print(error)
        }
    }
    
    /**
     * Hanling for 'Complete' swipe button from right to left
     */
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
    
        return cell
    }
    
    /**
     * Hanling for 'Edit' swipe button from left to right
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

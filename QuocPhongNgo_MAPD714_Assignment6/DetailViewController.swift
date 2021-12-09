/**
 * Assignment 6
 * File Name:    DetailViewController.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 2nd, 2021
 */

import UIKit
import Firebase
import FirebaseDatabase

class DetailViewController: UIViewController {

    @IBOutlet weak var hasDueDate: UISwitch!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var isCompleted: UISwitch!
    @IBOutlet weak var taskName: UITextField!
    var taskNameText: String?
    var notesText: String?
    var isCompletedText: Bool?
    var hasDueDateText: Bool?
    var dueDateText: Date?
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.text = taskNameText
        notes.text = notesText
        isCompleted.isOn = isCompletedText ?? false
        hasDueDate.isOn = hasDueDateText ?? false
        if(hasDueDateText != nil && hasDueDateText == false) {
            dueDate.isEnabled = false
        } else {
            dueDate.isEnabled = true
        }
        if(dueDateText != nil) {
            dueDate.date = dueDateText!
        }
        
    }

    /**
     * Handling event for Update button
     */
    @IBAction func btnUpdateClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to update?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self](_) in
            // remove a task
            self!.update(child: self?.taskNameText ?? "")
            // return todo list screen
            if let vc = self?.storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        present(alert, animated: true)
    }
    
    /**
     * Handling event for Delete button
     */
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self](_) in
            // remove a task
            self!.remove(child: self?.taskNameText ?? "")
            // return todo list screen
            if let vc = self?.storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {                
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        present(alert, animated: true)
    }
    
    /**
     * Update for a task
     */
    func update(child: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
    
        let ref = self.ref.child(child)
        ref.updateChildValues([
            "name":taskName.text!,
            "notes": notes.text!,
            "isCompleted": isCompleted.isOn,
            "hasDueDate": hasDueDate.isOn,
            "dueDate": dateFormatter.string(from: dueDate.date)
        ])
    }
    
    /**
     * Delete a task
     */
    func remove(child: String) {
        let ref = self.ref.child(child)
        ref.removeValue { error, _ in
            print(error)
        }
    }
    
    /**
     * Handling event for Cancel button
     */
    @IBAction func btnCancelClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to cancel these changes?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self](_) in
            // return todo list screen
            if let vc = self?.storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        present(alert, animated: true)
    }
    
    /**
     * Handling event hasDueDate switch
     */
    @IBAction func hasDueDateChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            dueDate.isEnabled = true
        } else {
            dueDate.isEnabled = false
        }
    }
}

/**
 * Assignment 6
 * File Name:    CustomTableViewCell.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 2nd, 2021
 */

import UIKit
import FirebaseDatabase

class CustomTableViewCell: UITableViewCell {
    
    weak var editButton: UIButton!
    
    var name:String = "" {
        didSet {
            if(name != oldValue) {
                nameLabel.text = name
            }
        }
    }
    var dueDate:String = "" {
        didSet {
            if(dueDate != oldValue)
            {
                dueDateLabel.text = dueDate
            }
        }
    }
    var nameLabel: UILabel!
    var dueDateLabel: UILabel!
    var switchUI: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        let nameValueRect = CGRect(x:80, y:0, width: 200, height: 40)
        nameLabel = UILabel(frame: nameValueRect)
        contentView.addSubview(nameLabel)
        
        let genreValueRect = CGRect(x:80, y:16, width: 200, height: 40)
        dueDateLabel = UILabel(frame: genreValueRect)
        contentView.addSubview(dueDateLabel)
        
        //Initialize Edit button
//        let editButton = UIButton(frame: CGRect(x: 8, y: 4.5, width: 48, height: 28))
//        self.editButton = editButton
//        self.frame = frame
        
        //Setup Edit button
//        addSubview(editButton)
//        let editImage = UIImage(systemName: "square.and.pencil")
//        editButton.setImage(editImage, for: UIControl.State.normal)
//        editButton.setTitleColor(.blue, for: .normal)
//        editButton.center.y = self.center.y
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

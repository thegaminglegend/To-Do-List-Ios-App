//
//  ToDoItemTableViewCell.swift
//  MyToDoList
//  Author: Mengen Zhao
//  Date: 4/27/23.
//  Professor: Dr. O
//  Class: CIT 352
//  Description: This is a to do list app that stores user's list of things to do and display each instances
//  This class has controls for ToDoItemTableViewCell
//

//Imports
import UIKit

class ToDoItemTableViewCell: UITableViewCell {

    //Reference Variables
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    //Built in Function
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //Built in Function
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

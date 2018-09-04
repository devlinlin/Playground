//
//  ListDetailViewController.swift
//  checklist
//
//  Created by ChandlerZou on 2018/3/27.
//  Copyright © 2018年 邹奂霖. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
//    func listDetailViewControllerDone(_ controller: ListDetailViewController){}
    func listDetailViewController(_ controller: ListDetailViewController, didFinishingAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishingEditing checklist: Checklist)
    
    
}
class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    //implement iconPickerViewCOntrollerDelegate
   
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // MARK: - data source
    
    weak var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?
    var iconName = "Folder"
    
//    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        if let checklist = checklistToEdit{
            textField.text = checklist.name
            title = "Edit Checklist"
            iconName = checklist.iconName
            doneBarButton.isEnabled = true
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    // make textField first respond
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range,in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    
    // MARK: - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacement string: String) -> Bool{
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    
    
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let checklist = checklistToEdit{
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishingEditing: checklist)
        }else{
            let checklist = Checklist(name: textField.text!, iconName: iconName)
//            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishingAdding: checklist)
        }
    }
    // MARK: - Icon Picker View Controller Delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
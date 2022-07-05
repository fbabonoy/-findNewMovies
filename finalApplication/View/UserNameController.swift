//
//  ViewController.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/5/22.
//

import UIKit

protocol SetUserName {
    func setUserName(name: String)
}

class UserNameController: UIViewController {

    var txtField = ""
    var userExist = 0
    var userNameDelegate: SetUserName?
    
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Write your name here."
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
        
    private lazy var saveAction = UIAction { _ in
        self.checkForUser()
        
    }
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(frame: .zero, primaryAction: saveAction)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("save", for: .normal)
        saveButton.setTitleColor(UIColor.systemBlue, for: .normal)
        
        return saveButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUp()
    }
    
    func checkForUser(){
        let mainView = MainScreenController()
        if self.txtField == "" {
            textField.placeholder = "Write your name here."
            return
        }
        if userExist == 0 {
            mainView.userName = self.txtField
            self.navigationController?.pushViewController(mainView, animated: false)
        } else {
            userNameDelegate?.setUserName(name: self.txtField)
            dismiss(animated: true)
        }
       
    }

    func setUp(){
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        let layout = view.safeAreaLayoutGuide

        textField.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true

        saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -20).isActive = true
        
    }
}

extension UserNameController: UITextFieldDelegate {
 
    func textFieldDidChangeSelection(_ textField: UITextField) {
        txtField = textField.text ?? ""
    }

}

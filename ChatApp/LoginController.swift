//
//  LoginController.swift
//  ChatApp
//
//  Created by Vicky Mohammad on 2017-06-29.
//  Copyright © 2017 Vicky Mohammad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class loginController: UIViewController{
    
    //create white input container for login
    let inputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        //round edge of the rectangle
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true//any item will be covered from the curve
        return view
    }()
    
    //I skipped lazy var
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 160)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        //direct the button
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    func handleRegister() {
        //guard the variable so optional will not be allowed
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Email and password form not valid")
            return
        }
        
        //create user with firebase
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            //if there is error print
            if error != nil {
                print(error as Any)
                //create an alert to the app
                let alert = UIAlertController(title: "Error occured. Sorry! ", message: "Password should be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    
                return
            }//end if error
            
            //guard uid var
            guard let uid = user?.uid else { return }
            
            //connect the firabse database
            let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-4d338.firebaseio.com/")
            //create child values
            let userReference = ref.child("users").child(uid)
            let value = ["name": name, "email": email]
            userReference.updateChildValues(value, withCompletionBlock: { (childError, childReference) in
                if childError != nil {
                    print(childError as Any)
                    return
                }//end if child error
                
                //when registered dismiss the login view
                self.dismiss(animated: true, completion: nil)
            })
        })
        //print when successful
        print("Registered name: \(name) and email: \(email)")
    }
    
    let nameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Name"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Email"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Password"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isSecureTextEntry = true//hash black circle dot encrytion
        return text
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.jpg")
        imageView.layer.cornerRadius = CGFloat((200/2)-(200/8))
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //fix the content image aspect ratio to original
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //i skipped lazy var
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["Login", "Register"])
        segControl.tintColor = UIColor.white
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.selectedSegmentIndex = 1//higlight the register icon
        segControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return segControl
    }()
    
    func handleLoginRegisterChange(){
        //change the title login button to login instead of register
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        //change the height contatiner view
        
        //change the container height when login
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        //same as the bottom in short form
        /*if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            inputsContainerViewHeightAnchor?.constant = 100
        }else{
            inputsContainerViewHeightAnchor?.constant = 150
        }*/
        
        //change name height field 
        nameTextFieldHeightAnchor?.isActive = false
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.isHidden = true
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        } else if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            nameTextField.isHidden = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        }//end if
        nameTextFieldHeightAnchor?.isActive = true
        
        //change name height field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //change name height field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change the status bar to white
        //add info.plist View controller-based status bar appearance = NO to change it to white
        UIApplication.shared.statusBarStyle = .lightContent
        //view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        //change the background color with my paramerter definition
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        //add a subview to view
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        //constraint
        setupInputsContainerView()
        setupRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }//end view did load func
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -20).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }//end constraint for segmented control
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }//end profile constraint
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView(){
        //add constraint, location and size
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        //add sub view for the texfield
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //constraint for the text field name
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true//multiplyer to make 3 texfield
        
        //constraint for seperator view
        nameSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true//line
        
        //constraint for the text field email
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true//multiplyer to make 3 texfield
        //constraint for seperator view
        emailSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true//line
        
        //constraint for the text field password
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true//multiplyer to make 3 texfield
        //constraint for seperator view
    }//end constraint function
    
    func setupRegisterButton(){
        //add constraint for button
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 20).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }//end constraint
    
}//end login controller class

extension UIImageView {
    func setRoundedImage() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }//end round image func
}//end extension

extension UIColor{
    //change the parameter for UIColor when invoking from (red: 26/255) to (r: 26)
    convenience init(r: CGFloat, g:CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }//end init
}//end extension



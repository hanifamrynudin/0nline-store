//
//  RegisterController.swift
//  online-store
//
//  Created by Hanif Fadillah Amrynudin on 22/12/23.
//


import UIKit

@available(iOS 15.0, *)
class RegisterController: UIViewController, UIGestureRecognizerDelegate {
    private let contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "REGISTER"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = UIColor(ciColor: .blue)
        return label
    }()
    
    private let emailLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        // Add any other configurations you need for the email text field
        return textField
    }()
    
    private let passwordLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your password"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        
        // Add button to show/hide password
        let showHideButton = UIButton(type: .custom)
        showHideButton.setImage(UIImage(named: "IconEyeHide"), for: .normal)
        showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8) // Adjust the padding
        showHideButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        showHideButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        showHideButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)


        textField.rightView = showHideButton
        textField.rightViewMode = .always

        // Add target to update isEnabled based on text field content
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)

        return textField
    }()
    
    private let passwordConfirmLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password Confirm"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your password"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        
        // Add button to show/hide password
        let showHideButton = UIButton(type: .custom)
        showHideButton.setImage(UIImage(named: "IconEyeHide"), for: .normal)
        showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8) // Adjust the padding
        showHideButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        showHideButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        showHideButton.addTarget(self, action: #selector(togglePasswordConfirmationVisibility(_:)), for: .touchUpInside)


        textField.rightView = showHideButton
        textField.rightViewMode = .always

        // Add target to update isEnabled based on text field content
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)

        return textField
    }()

    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        updateShowHideButtonImage(sender)
    }
    
    @objc func togglePasswordConfirmationVisibility(_ sender: UIButton) {
        passwordConfirmTextField.isSecureTextEntry.toggle()
        updateShowHideButtonImage(sender)
    }
    
    func updateShowHideButtonImage(_ button: UIButton) {
        let imageName = passwordTextField.isSecureTextEntry ? "IconEyeHide" : "IconEye"
        button.setImage(UIImage(named: imageName), for: .normal)
    }

    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        // Enable/disable the button based on whether there is text in the text field
        if let text = textField.text, !text.isEmpty {
            if let showHideButton = textField.rightView as? UIButton {
                showHideButton.isEnabled = true
            }
        } else {
            if let showHideButton = textField.rightView as? UIButton {
                showHideButton.isEnabled = false
            }
        }
    }
    
    private let btnNext:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("REGISTER", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func goToRegister() {
        // Ambil nilai dari email, password, dan passwordConfirmTextField
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = passwordConfirmTextField.text else {
            // Handle jika ada field yang kosong
            return
        }

        // Validasi bahwa password dan confirmPassword sesuai
        guard password == confirmPassword else {
            // Handle jika password tidak sesuai
            return
        }

        // Panggil fungsi registerUser untuk membuat permintaan registrasi
        registerUser(email: email, password: password) { [weak self] error in
            if let error = error {
                print("Registration failed with error: \(error.localizedDescription)")
            } else {
                print("Registration successful!")
                // Pindah ke layar selanjutnya jika registrasi berhasil
                DispatchQueue.main.async {
                    let nextScreen = LoginController()
                    self?.navigationController?.pushViewController(nextScreen, animated: true)
                }
            }
        }
    }

    // Fungsi untuk melakukan registrasi ke API
    private func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        // API URL
        let urlString = "https://tes-skill.datautama.com/test-skill/api/v1/auth/register"
        
        // Request Body
        let parameters: [String: Any] = [
            "name":"user",
            "email": email,
            "password": password
        ]
        
        // Convert parameters to Data
        guard let requestData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(nil)
            return
        }
        
        // Create URLRequest
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        // Create URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle response
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil)
                return
            }
            
            // Parse JSON response
            do {
                if let jsonData = data,
                   let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let code = json["code"] as? String,
                   code == "20000" {
                    // Registration successful
                    completion(nil)
                } else {
                    completion(nil)
                }
            } catch {
                completion(error)
            }
        }
        
        // Start the task
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "IconBack"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        contentView.addSubview(loginLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordConfirmLabel)
        contentView.addSubview(passwordConfirmTextField)
        contentView.addSubview(btnNext)
        
        view.addSubview(contentView)
        setupAutoLayOut()
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupAutoLayOut() {
        let margins = view.layoutMarginsGuide
        
        contentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loginLabel.topAnchor.constraint(equalTo:margins.topAnchor, constant:20).isActive = true
        loginLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo:loginLabel.bottomAnchor, constant: 15).isActive = true
        emailLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo:emailLabel.bottomAnchor, constant: 15).isActive = true
        emailTextField.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //
        
        passwordLabel.topAnchor.constraint(equalTo:emailTextField.bottomAnchor, constant: 15).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo:passwordLabel.bottomAnchor, constant: 15).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //
        
        passwordConfirmLabel.topAnchor.constraint(equalTo:passwordTextField.bottomAnchor, constant: 15).isActive = true
        passwordConfirmLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        passwordConfirmTextField.topAnchor.constraint(equalTo:passwordConfirmLabel.bottomAnchor, constant: 15).isActive = true
        passwordConfirmTextField.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        passwordConfirmTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //

        btnNext.bottomAnchor.constraint(equalTo:margins.bottomAnchor, constant: -20).isActive = true
        btnNext.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        btnNext.rightAnchor.constraint(equalTo:contentView.rightAnchor, constant:-20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnNext.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    }
    
    
}

//
//  LoginController.swift
//  online-store
//
//  Created by Hanif Fadillah Amrynudin on 22/12/23.
//



import UIKit

@available(iOS 15.0, *)
class LoginController: UIViewController, UIGestureRecognizerDelegate {
    
    private let contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LOGIN"
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

    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
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
        btn.setTitle("LOGIN", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    @objc func goToRegister() {
        // Ambil nilai dari email dan passwordTextField
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            // Handle jika ada field yang kosong
            return
        }

        // Panggil fungsi loginUser untuk membuat permintaan login
        loginUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                print("Login successful! Token: \(token)")

                // Store the token securely, such as in UserDefaults or Keychain
                UserDefaults.standard.set(token, forKey: "AuthToken")

                // Pindah ke layar selanjutnya jika login berhasil
                DispatchQueue.main.async {
                    let nextScreen = ProductListController()
                    self?.navigationController?.pushViewController(nextScreen, animated: true)
                }
            case .failure(let error):
                print("Login failed with error: \(error.localizedDescription)")
                // Handle error, tampilkan pesan error kepada pengguna jika diperlukan
            }
        }
    }


    // Fungsi untuk melakukan login ke API
    // Fungsi untuk melakukan login ke API
    private func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // API URL
        let urlString = "https://tes-skill.datautama.com/test-skill/api/v1/auth/login"
        
        // Request Body
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        // Convert parameters to Data
        guard let requestData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid request"])))
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
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
                return
            }
            
            // Parse JSON response
            // Parse JSON response
            do {
                if let jsonData = data,
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                    let code = json["code"] as? String,
                    code == "20000",
                    let data = json["data"] as? [String: Any],
                    let token = data["token"] as? String {
                    // Login successful
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
                }
            } catch {
                completion(.failure(error))
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

        btnNext.bottomAnchor.constraint(equalTo:margins.bottomAnchor, constant: -20).isActive = true
        btnNext.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        btnNext.rightAnchor.constraint(equalTo:contentView.rightAnchor, constant:-20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnNext.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    }
}




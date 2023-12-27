//
//  MainController.swift
//  online-store
//
//  Created by Hanif Fadillah Amrynudin on 22/12/23.
//


import UIKit

@available(iOS 15.0, *)
class MainController: UIViewController {
    
    private let container:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconStore: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "IconStore")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .systemBackground
        return img
    }()
    
    private let btnLogin:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("LOGIN", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let btnRegister:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("REGISTER", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        container.addSubview(iconStore)
        container.addSubview(btnLogin)
        container.addSubview(btnRegister)
        
        view.addSubview(container)
        
        setupAutoLayOut()
    }
    
    func setupAutoLayOut() {
        
        container.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        iconStore.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconStore.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconStore.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        iconStore.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        btnLogin.bottomAnchor.constraint(equalTo:btnRegister.topAnchor, constant:-20).isActive = true
        btnLogin.leftAnchor.constraint(equalTo:container.leftAnchor, constant:20).isActive = true
        btnLogin.rightAnchor.constraint(equalTo:container.rightAnchor, constant:-20).isActive = true
        btnLogin.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnLogin.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        btnRegister.bottomAnchor.constraint(equalTo:container.bottomAnchor, constant:-50).isActive = true
        btnRegister.leftAnchor.constraint(equalTo:container.leftAnchor, constant:20).isActive = true
        btnRegister.rightAnchor.constraint(equalTo:container.rightAnchor, constant:-20).isActive = true
        btnRegister.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnRegister.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    }
    
    @objc func goToLogin() {
        print("login")
        let nextScreen = LoginController()
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    @objc func goToRegister() {
        let nextScreen = RegisterController()
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}

//
//  VarianController.swift
//  online-store
//
//  Created by Hanif Fadillah Amrynudin on 22/12/23.
//


import UIKit

protocol VarianControllerDelegate {
    func updateData( nameVarian: String, price: String, stock: String, image: UIImage)
}

class VarianController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var delegate: VarianControllerDelegate!

    private var varianNumber: Int
    private var nameVarian: String
    private var price: String
    private var stock: String
    private var varianImage:  UIImage
    
    
    init(varianNumber: Int, nameVarian: String, price: String, stock: String, varianImage: UIImage) {
        self.varianNumber = varianNumber
        self.nameVarian = nameVarian
        self.price = price
        self.stock = stock
        self.varianImage = varianImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4.0
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "IconImage") // Placeholder image or nil
        return imageView
    }()
    
    private let varianLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let varianTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Varian Name"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        // Add any other configurations you need for the email text field
        return textField
    }()
    
    private let emailLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Harga"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "0"
        textField.keyboardType = .numberPad // Only allow numeric input
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect

        // Create a container view for the left view
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftViewContainer.backgroundColor = UIColor.lightGray

        // Add a UILabel with the currency symbol to the container view
        let currencyLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 40, height: 40))
        currencyLabel.text = " Rp"
        currencyLabel.textColor = .black

        // Add the currency label to the container view
        leftViewContainer.addSubview(currencyLabel)

        // Apply corner radius only to the left side
        let path = UIBezierPath(roundedRect: leftViewContainer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        leftViewContainer.layer.mask = maskLayer

        // Set the container view as the left view
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always


        // Add any other configurations you need for the email text field
        return textField
    }()


    
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Stock"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    // Create a UITextField for stock input
    private let currentStockField : UITextField = {
        var currentStock = 0
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.layer.borderWidth = 0.3
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8.0
        textField.keyboardType = .numberPad // Only allow numeric input
        textField.text = String(currentStock)
        textField.textAlignment = .center
        return textField
    }()

    // Create buttons for incrementing and decrementing stock
    private let incButton : UIButton = {
        let incrementButton = UIButton(type: .system)
        incrementButton.setTitle("+", for: .normal)
        incrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        incrementButton.layer.borderWidth = 0.3
        incrementButton.layer.borderColor = UIColor.lightGray.cgColor
        incrementButton.layer.cornerRadius = 8.0
        incrementButton.addTarget(self, action: #selector(incrementStock), for: .touchUpInside)
        return incrementButton
    }()
    
    private let decButton : UIButton = {
        let decrementButton = UIButton(type: .system)
        decrementButton.setTitle("-", for: .normal)
        decrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        decrementButton.layer.borderWidth = 0.3
        decrementButton.layer.borderColor = UIColor.lightGray.cgColor
        decrementButton.layer.cornerRadius = 4.0  // Adjusted corner radius for smaller size
        decrementButton.addTarget(self, action: #selector(decrementStock), for: .touchUpInside)
        return decrementButton
    }()

    
    private lazy var stockTextField: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a horizontal stack view to arrange the components
        let stackView = UIStackView(arrangedSubviews: [decButton, currentStockField, incButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        
        // Add the stack view to the container view
        containerView.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            decButton.widthAnchor.constraint(equalToConstant: 50),
            incButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        return containerView
    }()
        
    private let btnNext:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("SAVE", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "IconBack"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let titleLabel = UILabel()
        
        varianTextField.text = nameVarian
        if varianTextField.text != "" {
            titleLabel.text = "Edit Varian"
        } else {
            titleLabel.text = "Add Varian Product \(varianNumber)"
        }
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel])
        stackView.spacing = 8 // Adjust the spacing between the button and the title
        stackView.alignment = .center
        
        let customBackButton = UIBarButtonItem(customView: stackView)
        navigationItem.leftBarButtonItem = customBackButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // Add tap gesture recognizer to the containerView
        let containerTapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(containerTapGesture)

        // Add tap gesture recognizer to the imageView
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(imageTapGesture)
        imageView.isUserInteractionEnabled = true  // Enable user interaction for the imageView
    
        view.addSubview(contentView)
        setupAutoLayOut()
    }
    
    @objc func containerTapped() {
        print("taped!")
        openImagePicker()
    }

    // Handle tap on the imageView
    @objc func imageTapped() {
        print("tapped!")
        openImagePicker()
    }

    // Function to open the image picker
    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // Delegate method to handle the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Do something with the selected image, for example, set it to the imageView
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func incrementStock() {
        print("add")
        
       if var currentStock = Int(currentStockField.text ?? "0") {
           // Increment stock
           currentStock += 1
           currentStockField.text = "\(currentStock)"
       }
    }

    @objc private func decrementStock() {
        print("remove")
        print("add")
        
       if var currentStock = Int(currentStockField.text ?? "0"), currentStock > 0 {
           // Increment stock
           currentStock -= 1
           currentStockField.text = "\(currentStock)"
       }
    }


    
    func setupAutoLayOut() {
        
        contentView.addSubview(varianLabel)
        contentView.addSubview(varianTextField)
        varianTextField.text = nameVarian
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        emailTextField.text = String(price)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stockTextField)
        currentStockField.text = String(stock)
        contentView.addSubview(btnNext)
        
        contentView.addSubview(containerView)
        imageView.image = varianImage
        containerView.addSubview(imageView)
        
        let margins = view.layoutMarginsGuide
        
        contentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Center the containerView
        containerView.topAnchor.constraint(equalTo:margins.topAnchor, constant: 20).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Set width and height of the containerView
        containerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Center the imageView inside the containerView
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        // Set width and height of the imageView
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        varianLabel.topAnchor.constraint(equalTo:containerView.bottomAnchor, constant: 15).isActive = true
        varianLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        varianTextField.topAnchor.constraint(equalTo:varianLabel.bottomAnchor, constant: 15).isActive = true
        varianTextField.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        varianTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        varianTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //
        
        emailLabel.topAnchor.constraint(equalTo:varianTextField.bottomAnchor, constant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo:emailLabel.bottomAnchor, constant: 15).isActive = true
        emailTextField.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //
        
        descriptionLabel.topAnchor.constraint(equalTo:emailTextField.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        
        stockTextField.topAnchor.constraint(equalTo:descriptionLabel.bottomAnchor, constant: 15).isActive = true
        stockTextField.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        stockTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stockTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true // Adjust the width as needed
        stockTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //

        
        btnNext.bottomAnchor.constraint(equalTo:margins.bottomAnchor, constant: -20).isActive = true
        btnNext.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant:20).isActive = true
        btnNext.rightAnchor.constraint(equalTo:contentView.rightAnchor, constant:-20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnNext.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    }
    
    @objc func goToRegister() {
        
        if delegate != nil {
            if varianTextField.text != "" {
                delegate?.updateData(nameVarian: varianTextField.text!, price: emailTextField.text!, stock: currentStockField.text!, image: imageView.image!)
                self.navigationController?.popViewController( animated: true)
            } else {
                print("namevarian nil")
            }
        } else {
            print("delegate nil")
        }
            
    }
}




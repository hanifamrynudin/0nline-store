//
//  ProductController.swift
//  online-store
//
//  Created by Hanif Fadillah Amrynudin on 22/12/23.
//



import UIKit


class ProductController: UIViewController, UIGestureRecognizerDelegate {
        
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Create Product"
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
       return label
   }()
    
    private var idProduct : Int?
    private var authToken : String?
    
    private let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    private let emailLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Product Name"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        // Add any other configurations you need for the email text field
        return textField
    }()
    
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.textColor = .black
        textView.layer.borderWidth = 0.3
        textView.layer.borderColor = UIColor.lightGray.cgColor // Set border color
        textView.layer.cornerRadius = 8.0
        textView.isScrollEnabled = true
        textView.textColor = .black
        return textView
    }()
    
    
    private var base64ImageString = ""
    
    private let varianLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Varian Product"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    private let varianLabel1: UILabel = {
        let label = UILabel()
        label.text = "Add Varian Product 1"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private let varianLabel2: UILabel = {
        let label = UILabel()
        label.text = "Add Varian Product 2"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private let varianLabel3: UILabel = {
        let label = UILabel()
        label.text = "Add Varian Product 3"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    var productImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "IconStore")
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
    
    // Elements for the right side
     let nameLabel: UILabel = {
        let label = UILabel()
         // Set your product image here
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     let stockLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
     let editButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(UIImage(named: "IconEdit"), for: .normal) // Ganti dengan nama sistem ikon yang sesuai
         button.tintColor = .blue
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()
    
    let noDataLabel : UILabel = {
        let label = UILabel()
        label.text = "No data available"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private func containerData(varianNumber: Int) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerTap(_:)))
        
        
        if nameLabel.text !=  "" {
            // Data is available, display the image and labels
            container.addSubview(productImageView)
            container.addSubview(nameLabel)
            container.addSubview(priceLabel)
            container.addSubview(stockLabel)
            container.addSubview(editButton)

            // Constraints for the left side (image)
            productImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
            productImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
            productImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
            productImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            productImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

            // Constraints for the right side (labels)
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20).isActive = true
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true

            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true

            stockLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true

            // Constraints for the edit button
            editButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
            editButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            editButton.tag = varianNumber

            editButton.addGestureRecognizer(tapGesture)
           

        } else {
            // Data is not available, display only labels in the center
            

            // Add a UITapGestureRecognizer to the container
            container.tag = varianNumber

            container.addGestureRecognizer(tapGesture)

            // Add the label to the container
            container.addSubview(varianLabel1)

            // Set up constraints for the label inside the container
            varianLabel1.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            varianLabel1.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            varianLabel1.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            varianLabel1.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            varianLabel1.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        
        container.layer.cornerRadius = 8.0
        container.layer.borderWidth = 1.0
        container.layer.borderColor = UIColor.blue.cgColor

        return container
    }
    
    
    
    let productImageView2: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "IconStore")
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
    
    // Elements for the right side
     let nameLabel2: UILabel = {
        let label = UILabel()
         // Set your product image here
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     let priceLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     let stockLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "IconEdit"), for: .normal) // Ganti dengan nama sistem ikon yang sesuai
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func containerData2(varianNumber: Int) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerTap(_:)))

        if nameLabel2.text !=  ""  {
            // Data is available, display the image and labels
            container.addSubview(productImageView2)
            container.addSubview(nameLabel2)
            container.addSubview(priceLabel2)
            container.addSubview(stockLabel2)
            container.addSubview(editButton2)

            // Constraints for the left side (image)
            productImageView2.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
            productImageView2.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
            productImageView2.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
            productImageView2.widthAnchor.constraint(equalToConstant: 80).isActive = true
            productImageView2.heightAnchor.constraint(equalToConstant: 80).isActive = true

            // Constraints for the right side (labels)
            nameLabel2.leadingAnchor.constraint(equalTo: productImageView2.trailingAnchor, constant: 20).isActive = true
            nameLabel2.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true

            priceLabel2.leadingAnchor.constraint(equalTo: nameLabel2.leadingAnchor).isActive = true
            priceLabel2.topAnchor.constraint(equalTo: nameLabel2.bottomAnchor, constant: 8).isActive = true

            stockLabel2.leadingAnchor.constraint(equalTo: nameLabel2.leadingAnchor).isActive = true
            stockLabel2.topAnchor.constraint(equalTo: priceLabel2.bottomAnchor, constant: 8).isActive = true

            // Constraints for the edit button
            editButton2.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
            editButton2.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
            editButton2.widthAnchor.constraint(equalToConstant: 30).isActive = true
            editButton2.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editButton2.tag = varianNumber

            editButton2.addGestureRecognizer(tapGesture)
        } else {
            // Data is not available, display only labels in the center
            

            // Add a UITapGestureRecognizer to the container
            container.addGestureRecognizer(tapGesture)
            container.tag = varianNumber
            
            // Add the label to the container
            container.addSubview(varianLabel2)

            // Set up constraints for the label inside the container
            varianLabel2.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            varianLabel2.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            varianLabel2.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            varianLabel2.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            varianLabel2.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        
        container.layer.cornerRadius = 8.0
        container.layer.borderWidth = 1.0
        container.layer.borderColor = UIColor.blue.cgColor

        return container
    }
    
    
    
    let productImageView3: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "IconStore")
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
    
    // Elements for the right side
     let nameLabel3: UILabel = {
        let label = UILabel()
         // Set your product image here
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     let priceLabel3: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     let stockLabel3: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
     let editButton3: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(UIImage(named: "IconEdit"), for: .normal) // Ganti dengan nama sistem ikon yang sesuai
         button.tintColor = .blue
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()
    
    let noDataLabel3 : UILabel = {
        let label = UILabel()
        label.text = "No data available"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private func containerData3(varianNumber: Int) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContainerTap(_:)))

        if nameLabel3.text !=  "" {
            // Data is available, display the image and labels
            container.addSubview(productImageView3)
            container.addSubview(nameLabel3)
            container.addSubview(priceLabel3)
            container.addSubview(stockLabel3)
            container.addSubview(editButton3)

            // Constraints for the left side (image)
            productImageView3.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
            productImageView3.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
            productImageView3.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
            productImageView3.widthAnchor.constraint(equalToConstant: 80).isActive = true
            productImageView3.heightAnchor.constraint(equalToConstant: 80).isActive = true

            // Constraints for the right side (labels)
            nameLabel3.leadingAnchor.constraint(equalTo: productImageView3.trailingAnchor, constant: 20).isActive = true
            nameLabel3.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true

            priceLabel3.leadingAnchor.constraint(equalTo: nameLabel3.leadingAnchor).isActive = true
            priceLabel3.topAnchor.constraint(equalTo: nameLabel3.bottomAnchor, constant: 8).isActive = true

            stockLabel3.leadingAnchor.constraint(equalTo: nameLabel3.leadingAnchor).isActive = true
            stockLabel3.topAnchor.constraint(equalTo: priceLabel3.bottomAnchor, constant: 8).isActive = true

            // Constraints for the edit button
            editButton3.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
            editButton3.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
            editButton3.widthAnchor.constraint(equalToConstant: 30).isActive = true
            editButton3.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editButton3.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            editButton3.tag = varianNumber

            editButton3.addGestureRecognizer(tapGesture)
        
        } else {
            // Data is not available, display only labels in the center
            
            // Add a UITapGestureRecognizer to the container
            container.addGestureRecognizer(tapGesture)
            container.tag = varianNumber

            // Add the label to the container
            container.addSubview(varianLabel3)

            // Set up constraints for the label inside the container
            varianLabel3.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            varianLabel3.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            varianLabel3.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            varianLabel3.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            varianLabel3.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        
        container.layer.cornerRadius = 8.0
        container.layer.borderWidth = 1.0
        container.layer.borderColor = UIColor.blue.cgColor

        return container
    }
    
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
    
    private lazy var containerDataView1 : UIView = {
        return self.containerData(varianNumber: 1)
        
    }()
    private lazy var containerDataView2 : UIView = {
        return self.containerData2(varianNumber: 2)
        
    }()
    private lazy var containerDataView3 : UIView = {
        return self.containerData3(varianNumber: 3)
        
    }()
    
    @objc private func handleContainerTap(_ sender: UITapGestureRecognizer) {
        // Handle the container tap here using the sender's tag to identify which container was tapped
        if let containerView = sender.view {
            let varianNumber = containerView.tag
            let priceText = priceLabel.text ?? "0"
            let nameLabel = nameLabel.text ?? ""
            let stockText = stockLabel.text ?? "0"
            let varianImage = productImageView.image!
            let priceText2 = priceLabel2.text ?? "0"
            let nameLabel2 = nameLabel2.text ?? ""
            let stockText2 = stockLabel2.text ?? "0"
            let varianImage2 = productImageView2.image!
            let priceText3 = priceLabel3.text ?? "0"
            let nameLabel3 = nameLabel3.text ?? ""
            let stockText3 = stockLabel3.text ?? "0"
            let varianImage3 = productImageView3.image!
            
            
            var nextScreen = VarianController(varianNumber: varianNumber, nameVarian: nameLabel, price: priceText, stock: stockText, varianImage: varianImage)
            
            if varianNumber == 1 {
                nextScreen = VarianController(varianNumber: varianNumber, nameVarian: nameLabel, price: priceText, stock: stockText, varianImage: varianImage)
            } else if varianNumber == 2 {
                nextScreen = VarianController(varianNumber: varianNumber, nameVarian: nameLabel2, price: priceText2, stock: stockText2, varianImage: varianImage2)
            } else {
                nextScreen = VarianController(varianNumber: varianNumber, nameVarian: nameLabel3, price: priceText3, stock: stockText3, varianImage: varianImage3)
            }
            
            navigationController?.pushViewController(nextScreen, animated: true)
            nextScreen.delegate = self
        }
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "IconBack"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel])
        stackView.spacing = 8 // Adjust the spacing between the button and the title
        stackView.alignment = .center
        
        let addIcon = UIButton(type: .custom)
        addIcon.setImage(UIImage(named: "IconDelete"), for: .normal)
        addIcon.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        addIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let customBackButton = UIBarButtonItem(customView: stackView)
        navigationItem.leftBarButtonItem = customBackButton
        
        // Configure the right bar button item
        if titleLabel.text == "Create Product" {
            btnNext.addTarget(self, action: #selector(save), for: .touchUpInside)
            // If there are no variants, hide the add button
            navigationItem.rightBarButtonItem = nil
        } else {
            // If there are variants, show the add button
            let customAddButton = UIBarButtonItem(customView: addIcon)
            navigationItem.rightBarButtonItem = customAddButton
            btnNext.addTarget(self, action: #selector(update), for: .touchUpInside)
        
        }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupScrollView()
        
        // Retrieve the token from UserDefaults
        if let token = UserDefaults.standard.string(forKey: "AuthToken") {
            // Token is available, you can use it for API requests
            print("Token is available: \(token)")
            authToken = token
        } else {
            // Token is nil, handle the case where the user is not logged in
            print("Token is nil. Please login first.")
            // You may want to navigate back to the login screen or show a login screen
        }
    }
    
    @objc func deleted() {
        print("taped!")
        // Display a confirmation alert
        let alert = UIAlertController(title: "Delete Product", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // User confirmed, call the API to delete the product
            self.deleteProduct()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showEmptyFieldsAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
    @objc func save() {
        print("taped!")
        
        guard let title = emailTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let name = nameLabel.text, !name.isEmpty,
              let price = priceLabel.text, !price.isEmpty,
              let stock = stockLabel.text, !stock.isEmpty
        else {
               // Display an alert because one or more fields are empty
               showEmptyFieldsAlert()
               return
           }
        
        // Step 1: Load the image from the asset
        guard let image = productImageView.image else {
            print("Failed to load the image")
            return
        }

        // Step 2: Convert the image to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to Data")
            return
        }

        // Step 3: Convert Data to base64-encoded string
        base64ImageString = imageData.base64EncodedString()

        // Create the variants array
        let variantsCreate: [[String: Any]] = [
            [
                "name": nameLabel.text ?? "",
                "image": "data:image/png;base64,\(base64ImageString)",
                "price": Int(priceLabel.text ?? "") ?? 0,
                "stock": Int(stockLabel.text ?? "") ?? 0
            ],
            // Add more variants as needed
        ]
        
        // Display a confirmation alert
        let alert = UIAlertController(title: "Save Product", message: "Are you sure you want to save this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler: { [self] _ in
            // User confirmed, call the API to delete the product
            self.createProduct(title: emailTextField.text ?? "", description: descriptionTextField.text ?? "", variants: variantsCreate) { success, message in
                if success {
                    // Product created successfully
                    print(message ?? "Product created successfully")
                } else {
                    // Failed to create product
                    print(message ?? "Failed to create product")
                }
                
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func update() {
        print("taped!")
        // Display a confirmation alert
        let alert = UIAlertController(title: "Update Product", message: "Are you sure you want to update this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { _ in
            // User confirmed, call the API to delete the product
            self.updateProduct()
            self.updateProductVariant(idVariant: "97", name: self.nameLabel.text!, productImageView: self.productImageView, price: Int(self.priceLabel.text!)!, stock: Int(self.stockLabel.text!)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        print("taped!")
    }
    
    
    // Add the configure method
    func configure(with product: Product) {
        // Configure the UI of the ProductController with the product data
        // For example:
        idProduct = product.id
        titleLabel.text = product.title
        emailTextField.text = product.title
        descriptionTextField.text = product.description
        
        if !product.variants.isEmpty {
            varianLabel1.text = product.variants[0].name
            productImageView.loadImage(fromURLString: product.variants[0].image)
            nameLabel.text = product.variants[0].name
            priceLabel.text = "\(product.variants[0].price)"
            stockLabel.text = "\(product.variants[0].stock)"
            containerDataView1 = containerData(varianNumber: 1)
        }
        // Check if there is a second variant before accessing it
        if product.variants.count > 1 {
            varianLabel1.text = product.variants[0].name
            varianLabel2.text = product.variants[1].name
            productImageView.loadImage(fromURLString: product.variants[0].image)
            nameLabel.text = product.variants[0].name
            priceLabel.text = "\(product.variants[1].price)"
            stockLabel.text = "\(product.variants[1].stock)"
            productImageView2.loadImage(fromURLString: product.variants[1].image)
            nameLabel2.text = product.variants[1].name
            priceLabel2.text = "Price: \(product.variants[1].price)"
            stockLabel2.text = "Stock: \(product.variants[1].stock)"
            containerDataView1 = containerData(varianNumber: 1)
            containerDataView2 = containerData2(varianNumber: 2)
        }
        // Check if there is a third variant before accessing it
        if product.variants.count > 2 {
            varianLabel1.text = product.variants[0].name
            varianLabel2.text = product.variants[1].name
            varianLabel3.text = product.variants[2].name
            productImageView.loadImage(fromURLString: product.variants[0].image)
            nameLabel.text = product.variants[0].name
            priceLabel.text = "\(product.variants[0].price)"
            stockLabel.text = "\(product.variants[0].stock)"
            productImageView2.loadImage(fromURLString: product.variants[1].image)
            nameLabel2.text = product.variants[1].name
            priceLabel2.text = "Price: \(product.variants[1].price)"
            stockLabel2.text = "Stock: \(product.variants[1].stock)"
            productImageView3.loadImage(fromURLString: product.variants[2].image)
            nameLabel3.text = product.variants[2].name
            priceLabel3.text = "Price: \(product.variants[2].price)"
            stockLabel3.text = "Stock: \(product.variants[2].stock)"
            containerDataView1 = containerData(varianNumber: 1)
            containerDataView2 = containerData2(varianNumber: 2)
            containerDataView3 = containerData3(varianNumber: 3)
        }
    }
    
    func createProduct(title: String, description: String, variants: [[String: Any]], completion: @escaping (Bool, String?) -> Void) {
            
        // Create the request URL
        let url = URL(string: "https://tes-skill.datautama.com/test-skill/api/v1/product")!
        
        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add your authorization header
        request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "title": title,
            "description": description,
            "variants": variants
        ]
        
        
        // Convert the request body to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(false, "Failed to serialize request data")
            return
        }
        
        // Set the request body
        request.httpBody = jsonData
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle the response
            
            // Check for errors
            if let error = error {
                completion(false, "Error: \(error.localizedDescription)")
                return
            }
            
            // Check if there is data
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            // Parse the JSON data
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let responseDict = json as? [String: Any],
               let code = responseDict["code"] as? String,
               code == "20000" {
                // Success
                completion(true, "Product created successfully")
            } else {
                // Failure
                completion(false, "Failed to create product. Check the response.")
            }
        }
        
        // Resume the data task
        task.resume()
    }


    
    func updateProduct() {
        guard let productId = idProduct else {
            // Handle the case where product ID is not available
            return
        }
        
        let apiUrlString = "https://tes-skill.datautama.com/test-skill/api/v1/product/update-product/\(productId)"
        
        guard let url = URL(string: apiUrlString) else {
            print("Invalid URL")
            return
        }
        
        // Prepare the request body
        var parameters: [String: Any] = [:]

        if let title = emailTextField.text {
            parameters["title"] = title
        }

        if let description = descriptionTextField.text {
            parameters["description"] = description
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            print("\(jsonData)")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add your authorization header
            request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
            
            // Attach the request body
            request.httpBody = jsonData
            
            // Make the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        // Check if the data is a valid JSON object
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let code = jsonResponse["code"] as? String, code == "20000" {
                                print("Product update successful")
                                
                                // Perform UI updates or navigate back to the previous screen
                                DispatchQueue.main.async {
                                    // Example: Pop the view controller
                                    // Call fetchProductList to refresh the data
                                    self.navigationController?.popViewController(animated: true)
                                }
                            } else {
                                print("Product update failed")
                            }
                        } else {
                            print("Invalid JSON format")
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            print("Error converting parameters to JSON: \(error)")
        }
    }
    
    func updateProductVariant(idVariant: String, name: String, productImageView: UIImageView, price: Int, stock: Int){
        // API endpoint URL
        let apiUrl = "https://tes-skill.datautama.com/test-skill/api/v1/product/update-variant/\(idVariant)"

        // Prepare the request URL
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        // Step 1: Load the image from the asset
        guard let image = productImageView.image else {
            print("Failed to load the image")
            return
        }

        // Step 2: Convert the image to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to Data")
            return
        }

        // Step 3: Convert Data to base64-encoded string
        base64ImageString = imageData.base64EncodedString()

        
        // Prepare the request headers
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the request parameters
        let parameters: [String: Any] = [
            "name": name,
            "image": base64ImageString,
            "price": price,
            "stock": stock
        ]

        // Convert the parameters to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to serialize JSON data");
            return
        }

        // Attach the JSON data to the request
        request.httpBody = jsonData

        // Create a URLSession task for the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Request error: \(error.localizedDescription)");
                return
            }

            // Check for data
            guard let responseData = data else {
                print("No data received");
                return
            }

            // Decode the JSON response
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]

                // Check for the "code" value in the response
                if let code = jsonResponse?["code"] as? String, code == "20000" {
                    // Success
                    print("Success update variant product");
                } else {
                    // Failure
                    let errorMessage = jsonResponse?["message"] as? String ?? "Unknown error"
                    print(errorMessage);
                }
            } catch {
                // Error decoding JSON
                print("Error decoding JSON response");
            }
        }

        // Execute the URLSession task
        task.resume()
    }


    func deleteProduct() {
        
        let listProduct = ProductListController()
        
        guard let productId = idProduct else {
            // Handle the case where product ID is not available
            return
        }

        // Construct the API URL with the product ID
        let apiUrl = "https://tes-skill.datautama.com/test-skill/api/v1/product/\(productId)/delete"

        // Create the URL object
        if let url = URL(string: apiUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            // Add your authorization header
            request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle the response or error here
                if let error = error {
                    print("Error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Successful deletion
                    print("Product deleted!")

                    // Perform UI updates or navigate back to the previous screen
                    DispatchQueue.main.async {
                        // Example: Pop the view controller
                        // Call fetchProductList to refresh the data
                        self.navigationController?.popViewController(animated: true)
                        listProduct.refreshData()
                    }
                } else {
                    // Handle other status codes or unexpected responses
                    print("Unexpected response")
                }
            }

            task.resume()
        }
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
        private func setupScrollView() {
        let margins = view.layoutMarginsGuide
            view.addSubview(scrollView)
            scrollView.addSubview(scrollStackViewContainer)
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        setupAutoLayOut()
    }
    
    func setupAutoLayOut() {
        scrollStackViewContainer.addArrangedSubview(emailLabel)
        scrollStackViewContainer.addArrangedSubview(emailTextField)
        scrollStackViewContainer.addArrangedSubview(descriptionLabel)
        scrollStackViewContainer.addArrangedSubview(descriptionTextField)
        scrollStackViewContainer.addArrangedSubview(varianLabel)
        scrollStackViewContainer.addArrangedSubview(containerDataView1)
        scrollStackViewContainer.addArrangedSubview(containerDataView2)
        scrollStackViewContainer.addArrangedSubview(containerDataView3)
        scrollStackViewContainer.addArrangedSubview(btnNext)
        
        descriptionTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true //
        btnNext.heightAnchor.constraint(equalToConstant:50).isActive = true
        
    }
    
    @objc func goToRegister() {
        let nextScreen = ProductListController()
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
}




extension ProductController: VarianControllerDelegate {
    func updateData(nameVarian: String, price: String, stock: String, image: UIImage) {
        self.nameLabel.text = nameVarian
        self.priceLabel.text = price
        self.stockLabel.text = stock
        self.productImageView.image = image
    }
    
}

extension Data {
    func base64EncodedString() -> String {
        return self.base64EncodedString(options: [])
    }
}

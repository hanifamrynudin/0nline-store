//
//  ProductListController.swift
//  online-store
//
//  Created by Hanif Fadillah Amrynudin on 22/12/23.
//


import UIKit

class ProductListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, ProductCellDelegate {

    var authToken: String?
    var productList: [Product] = []

    private let searchController = UISearchController(searchResultsController: nil)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 150
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setImage(UIImage(named: "IconLogOut"), for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.text = "Product"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        let addIcon = UIButton(type: .custom)
        addIcon.setImage(UIImage(named: "IconAdd"), for: .normal)
        addIcon.addTarget(self, action: #selector(goAddProduct), for: .touchUpInside)
        addIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let customBackButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = customBackButton
        let customAddButton = UIBarButtonItem(customView: addIcon)
        navigationItem.rightBarButtonItem = customAddButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupCollectionView()
        
       
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

        
        setupSearchBar()
        
        view.addSubview(floatingButton)
        
        collectionView.refreshControl = refreshControl

       // ...

       fetchProductList(authToken: authToken)
    }
    
    
    @objc func refreshData() {
        // Panggil fungsi untuk mereload data
        fetchProductList(authToken: authToken)
    }
    
    func productCellDidTap(_ cell: ProductCollectionViewCell) {
        print("Product cell tapped!")
        // Handle cell tap, for example, navigate to ProductController
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let product = productList[indexPath.item]

        let productController = ProductController()
        // Configure the ProductController with the selected product
        productController.configure(with: product)

        navigationController?.pushViewController(productController, animated: true)
    }
    
    func fetchProductList(authToken: String?) {
        
        // Pastikan authToken tidak nil sebelum melakukan permintaan
        guard let authToken = authToken else {
            print("Token is nil. Please login first.")
            return
        }

        // Buat URL sesuai dengan spesifikasi API
        let apiUrl = "https://tes-skill.datautama.com/test-skill/api/v1/product"
        guard var urlComponents = URLComponents(string: apiUrl) else {
            print("Invalid API URL")
            return
        }
        

        // Set parameter-page dan per_page sesuai kebutuhan Anda
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "10")
            // Anda dapat menambahkan parameter lain sesuai kebutuhan
        ]

        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Set header Authorization dengan token yang diperoleh dari login
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        // Buat URLSessionDataTask untuk melakukan permintaan
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Decode JSON respons
                let decoder = JSONDecoder()
                let productListResponse = try decoder.decode(ProductListResponse.self, from: data)

                // Akses data produk dari respons
                let products = productListResponse.data.items

                // Update UI di thread utama
                DispatchQueue.main.async {
                    
                    // Assign data produk ke productList dan reload collection view
                    self.productList = products
                    self.collectionView.reloadData()

                    // Berhenti animasi refreshControl
                    self.refreshControl.endRefreshing()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        // Mulai permintaan
        task.resume()
    }
    @objc func containerTapped() {
        print("taped!")
    }

    // Handle tap on the imageView
    @objc func imageTapped() {
        print("tapped!")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 60 - 8, y: view.frame.size.height - 90 - 8, width: 60, height: 60)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    
    @objc func logoutButtonTapped() {
        // Display a confirmation alert
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            // User confirmed, call the API to delete the product
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func goAddProduct() {
        let nextScreen = ProductController()
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    func setupSearchBar() {
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        
        // Add constraints for the collection view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupFloatingButton() {
        view.addSubview(floatingButton)

        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 50),
            floatingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the total number of products in your data
        return productList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
            fatalError("Unable to dequeue ProductCollectionViewCell")
        }

        let product = productList[indexPath.item]
        cell.configure(with: product)
        cell.delegate = self // Set the delegate

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
        cell.cellTapped()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the size of each item based on the collection view width
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - 30) / 2 // 30 is the total spacing (10 + 10 + 10)
        return CGSize(width: itemWidth, height: 150) // Adjust the height as needed
    }
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ProductCellDelegate?
    var navigationController: UINavigationController?

    // Fungsi untuk menanggapi ketukan pada sel
    
    @objc func cellTapped() {
        delegate?.productCellDidTap(self)
    }

    func configure(with product: Product, navigationController: UINavigationController?) {
        // Konfigurasi sel
        // ...

        // Atur target aksi untuk deteksi ketukan pada sel
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)

        // Simpan navigationController untuk digunakan nanti saat sel di tap
        self.navigationController = navigationController
    }

    
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
    
    
    private let nameProductLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        // Set other properties for the label
        return label
    }()
    
    private let totalVariantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        // Set other properties for the label
        return label
    }()

    private let totalStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        // Set other properties for the label
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .blue
        // Set other properties for the label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        
        // Mengaktifkan interaksi pengguna pada imageView agar gesture recognizer dapat bekerja
        imageView.isUserInteractionEnabled = true
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        addSubview(nameProductLabel)
        addSubview(totalVariantsLabel)
        addSubview(totalStockLabel)
        addSubview(priceLabel)

        // Add constraints for the subviews
        // Adjust the constraints based on your layout requirements

        NSLayoutConstraint.activate([
            
            // Center the containerView
            containerView.topAnchor.constraint(equalTo:topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            // Set width and height of the containerView
            containerView.widthAnchor.constraint(equalToConstant: 150),
            containerView.heightAnchor.constraint(equalToConstant: 150),
            
            // Center the imageView inside the containerView
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            // Set width and height of the imageView
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            

            
            nameProductLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            nameProductLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameProductLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),

            totalVariantsLabel.topAnchor.constraint(equalTo: nameProductLabel.bottomAnchor, constant: 8),
            totalVariantsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            totalVariantsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),

            totalStockLabel.topAnchor.constraint(equalTo: totalVariantsLabel.bottomAnchor, constant: 4),
            totalStockLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            totalStockLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),

            priceLabel.topAnchor.constraint(equalTo: totalStockLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
        ])
    }
    
    
    func configure(with product: Product) {
        // Configure the cell with product data
        nameProductLabel.text = "\(product.title)"
        imageView.loadImage(fromURLString: product.image)
        totalVariantsLabel.text = "Total Variants: \(product.total_variant)"
        totalStockLabel.text = "Total Stock: \(product.total_stok)"
        
        // Set the price text with different font size for "(Harga Terendah)"
        let priceText = "Rp. \(product.price) "
        let lowestPriceText = "(Harga Terendah)"
        let attributedText = NSMutableAttributedString(string: priceText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
        attributedText.append(NSAttributedString(string: lowestPriceText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]))

        priceLabel.attributedText = attributedText
    }
    
}

extension UIImageView {
    func loadImage(fromURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }else {
                print("Failed to load image from URL: \(url)")
                return
            }
        }
    }
}


protocol ProductCellDelegate: AnyObject {
    func productCellDidTap(_ cell: ProductCollectionViewCell)
}

struct ProductListResponse: Codable {
    let code: String
    let message: String
    let data: ProductListData
}

struct ProductListData: Codable {
    let items: [Product]
    let per_page: Int
    let total: Int
    let last_page: String?
    let next_page: String?
    let prev_page: String?
}

// Tambahkan kode sesuai dengan struktur JSON yang sebenarnya
// Pastikan sesuai dengan struktur respons API produk
struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let total_variant: Int
    let total_stok: Int
    let price: Int
    let image: String
    let variants: [ProductVariant]
}

struct ProductVariant: Codable {
    let id: Int
    let image: String
    let name: String
    let price: Int
    let stock: Int
}

//
//struct Product {
//    let name: String
//    let image: UIImage
//    let description: String
//    let totalVariants: Int
//    let totalStock: Int
//    let price: Double
//    // Other properties and initializers as needed
//}
//
//var productList: [Product] = [
//    Product(name: "Product 1",image: ((UIImage(named: "tas_1")) ?? UIImage(named: "IconEye"))!, description: "Produk 1 adalah blablablaa" , totalVariants: 3, totalStock: 50, price: 29.99),
//    Product(name: "Product 2",image:  ((UIImage(named: "tas_1")) ?? UIImage(named: "IconEye"))!, description: "Produk 2 adalah blablablaa", totalVariants: 2, totalStock: 30, price: 19.99),
//    Product(name: "Product 3",image:  ((UIImage(named: "tas_1")) ?? UIImage(named: "IconEye"))!, description: "Produk 3 adalah blablablaa", totalVariants: 2, totalStock: 30, price: 19.99),
//    // Add more products as needed
//]

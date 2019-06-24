//
//  HomeController.swift
//  Test Apps
//
//  Created by Arief Zainuri on 24/06/19.
//  Copyright © 2019 Arief Zainuri. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeController: UIViewController, UICollectionViewDelegate {

    // widget
    @IBOutlet weak var propertyCollection: UICollectionView!
    @IBOutlet weak var addProperty: UIButton!
    
    // properties
    var properties = [Property]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollection()
        
        getData()
        
        userClick()
    }
    
    private func userClick() {
        addProperty.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPropertyClick)))
    }
    
    private func getData() {
        properties.removeAll()
        SVProgressHUD.show()
        Networking.instance.getPropertyTypes { (property, error) in
            if let error = error {
                if error == "Token expired." {
                    PublicFunction.instance.showUnderstandDialog(self, "Token Expired", "", "Login", completionHandler: {
                        self.present(LoginController(), animated: true)
                    })
                } else {
                    PublicFunction.instance.showUnderstandDialog(self, "Error", error, "Understand")
                }
                SVProgressHUD.dismiss()
                return
            }
            
            DispatchQueue.main.async {
                self.properties = property!
                self.propertyCollection.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func initCollection() {
        propertyCollection.register(UINib(nibName: "PropertyCell", bundle: nil), forCellWithReuseIdentifier: "PropertyCell")
        
        let cell = propertyCollection.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: IndexPath(item: 0, section: 0)) as! PropertyCell
        let layout = propertyCollection.collectionViewLayout as! UICollectionViewFlowLayout
        let height = cell.property.frame.height + 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: height)
        
        propertyCollection.delegate = self
        propertyCollection.dataSource = self
    }

}

// collection view delegate
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
        cell.data = properties[indexPath.item].name
        return cell
    }
    
}

// click event
extension HomeController {
    @objc func addPropertyClick() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Property", message: "Enter property name", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            if textField.text?.trim() == "" {
                PublicFunction.instance.showUnderstandDialog(self, "Empty Property", "Cant fill property with blank words", "Understand")
                return
            }
            
            SVProgressHUD.show()
            
            Networking.instance.postProperty(property: (textField.text?.trim())!, completion: { (error) in
                if let error = error {
                    PublicFunction.instance.showUnderstandDialog(self, "Post Error", error, "Understand")
                    return
                }
                
                SVProgressHUD.dismiss()
                
                self.getData()
            })
        }))
        
        present(alert, animated: true)
    }
}

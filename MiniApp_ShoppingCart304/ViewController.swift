//
//  ViewController.swift
//  MiniApp_ShoppingCart304
//
//  Created by Harrison Hall on 10/25/21.
//

import UIKit
public struct Cart : Codable {
    var item : String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addItemsText: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    var shoppingCart : [Cart] = []
  //  var itemNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        // Keep saved items
        if let items = UserDefaults.standard.data(forKey: "cartItems"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Cart].self, from: items){
                shoppingCart = decoded
            }
        }
        
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = shoppingCart[indexPath.row].item
        return cell
    }
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            shoppingCart.remove(at: indexPath.row)
          //  itemNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(shoppingCart){
                UserDefaults.standard.set(encoded, forKey: "cartItems")
            }
        }
    }
    
    // Add and then save
    @IBAction func addShoppingItem(_ sender: Any) {
        let alert = UIAlertController(title: "Error:", message: "You have already added this item", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        for blah in shoppingCart {
            if addItemsText.text! == blah.item {
            present(alert, animated: true, completion: nil)
            return
        }
        }
        
        shoppingCart.append(Cart(item: addItemsText.text!))
      //  itemNames.append(addItemsText.text!)
        addItemsText.text = ""
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(shoppingCart){
            UserDefaults.standard.set(encoded, forKey: "cartItems")
        }
        
        tableViewOutlet.reloadData()
        
    }
    
    

}


//
//  ViewController.swift
//  Project2
//
//  Created by Alexis Orellano on 3/3/19.
//  Copyright © 2019 Alexis Orellano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var words = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(words[indexPath.row])"
        return cell
    }
    
}

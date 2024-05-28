//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Cesar Fernandez on 5/24/24.
//
// File created on page 533

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var confirmationLabel: UILabel!
    
    //page 534 addition
    let minutesToPrepare: Int
    //page 534 addition
    init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    
    }
    //page 534 addition
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationLabel.text = "Thank you for your order! Your Wait time is approximately \(minutesToPrepare) minutes"
    }

}

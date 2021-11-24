//
//  InterfaceController.swift
//  project-squirrel-dragon Watch WatchKit Extension
//
//  Created by Justine Wright on 2021/11/24.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var button: WKInterfaceButton!
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    @IBAction func buttonTapped() {

        button.setTitle("Tap tap")
    }

}

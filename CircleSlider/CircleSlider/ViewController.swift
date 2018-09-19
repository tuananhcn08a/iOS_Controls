//
//  ViewController.swift
//  CircleSlider
//
//  Created by The New Macbook on 9/19/18.
//  Copyright © 2018 FPT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let seekBar = TACircleSlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        seekBar.frame = CGRect(x: (self.view.frame.size.width - 200) * 0.5, y: (self.view.frame.size.height - 200) * 0.5, width: 200, height: 200)
        
        seekBar.startAngle = 120
        seekBar.endAngle = 60
        seekBar.currentAngle = 120
        self.view.addSubview(seekBar)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        seekBar.frame = CGRect(x: (self.view.frame.size.width - 200) * 0.5, y: (self.view.frame.size.height - 200) * 0.5, width: 200, height: 200)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        seekBar.moveToAngle(angle: 270, duration: 1.0)
    }
}


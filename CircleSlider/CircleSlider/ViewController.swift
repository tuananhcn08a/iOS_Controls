//
//  ViewController.swift
//  CircleSlider
//
//  Created by The New Macbook on 9/19/18.
//  Copyright © 2018 FPT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TACircleSliderDelegate {
    
    @IBOutlet weak var cSlider: TACircleSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cSlider.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    func sliderDidChangeValue(value: CGFloat) {
        print(value)
    }
}


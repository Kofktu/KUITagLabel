//
//  ViewController.swift
//  Example
//
//  Created by Kofktu on 2016. 9. 21..
//  Copyright © 2016년 Kofktu. All rights reserved.
//

import UIKit
import KUITagLabel

class ViewController: UIViewController {

    @IBOutlet weak var tagLabel: KUITagLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let config = KUITagConfig(insets: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0),
                                  titleColor: UIColor.blueColor(),
                                  titleFont: UIFont.systemFontOfSize(15.0),
                                  backgroundColor: UIColor.yellowColor())
        
        tagLabel.onSelectedHandler = { [weak self] (tag) in
            print("tag : \(tag.title)")
        }
        
//        tagLabel.text = "테스트1232j13kj12l3j2l1kj3l12kj3l1j3l2k13l21j3l"
        
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.add(KUITag(title: "테스트", config: config))
        tagLabel.add(KUITag(title: "테스트1", config: config))
//        tagLabel.add(KUITag(title: "테스트", config: config))
//        tagLabel.add(KUITag(title: "테스트1", config: config))
//        tagLabel.add(KUITag(title: "테스트", config: config))
//        tagLabel.add(KUITag(title: "테스트1", config: config))
//        tagLabel.add(KUITag(title: "테스트", config: config))
//        tagLabel.add(KUITag(title: "테스트1", config: config))
//        tagLabel.add(KUITag(title: "테스트", config: config))
//        tagLabel.add(KUITag(title: "테스트1", config: config))
//        tagLabel.add(KUITag(title: "테스트", config: config))
//        tagLabel.add(KUITag(title: "테스트1", config: config))
        tagLabel.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


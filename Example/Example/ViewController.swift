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
        
        let config = KUITagConfig(titleColor: UIColor.magentaColor(),
                                  titleFont: UIFont.boldSystemFontOfSize(15.0),
                                  titleInsets: UIEdgeInsets(top: 2.0, left: 6.0, bottom: 2.0, right: 6.0),
                                  backgroundColor: UIColor.yellowColor(),
                                  cornerRadius: 4.0,
                                  borderWidth: 0.0,
                                  borderColor: nil,
                                  backgroundImage: nil)
        
//        let config = KUITagConfig(titleColor: UIColor.blueColor(),
//                                  titleFont: UIFont.systemFontOfSize(15.0),
//                                  backgroundColor: UIColor.yellowColor())
//
        
        tagLabel.onSelectedHandler = { [weak self] (tag) in
            print("tag : \(tag.title)")
            
            self?.tagLabel.removeAll()
            self?.tagLabel.refresh()
        }
        
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
        tagLabel.refresh()
    }

}

//
//  ViewController.swift
//  Example
//
//  Created by Kofktu on 2016. 9. 21..
//  Copyright © 2016년 Kofktu. All rights reserved.
//

import UIKit
import KUITagListView

class ViewController: UIViewController {

    @IBOutlet weak var tagListView: KUITagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let config = KUITagConfig(insets: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0),
                                  titleColor: UIColor.blackColor(),
                                  titleFont: UIFont.systemFontOfSize(15.0))
        
        tagListView.onSelectedHandler = { [weak self] (tag) in
            print("tag : \(tag.title)")
        }
        
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.add(KUITag(title: "테스트", config: config))
        tagListView.add(KUITag(title: "테스트1", config: config))
        tagListView.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  FullTextViewController.swift
//  RSSNews
//
//  Created by Roman on 11.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

class FullTextViewController: UIViewController {
    
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var fullTextLabel: UILabel!
    
    var fullText: String?
    var header: String?
    var imageNews: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullTextLabel.text = fullText
        headerLabel.text = header
        fullImage.image = imageNews
        
    }
    

}

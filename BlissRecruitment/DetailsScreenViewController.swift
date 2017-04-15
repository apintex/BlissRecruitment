//
//  DetailsScreenViewController.swift
//  BlissRecruitment
//
//  Created by António Pinto on 14/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import UIKit

class DetailsScreenViewController: UIViewController {

    var detailQuestion: questions? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        if let detailQuestion = detailQuestion {
//            if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
//                detailDescriptionLabel.text = detailCandy.name
//                candyImageView.image = UIImage(named: detailCandy.name)
//                title = detailCandy.category
//            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

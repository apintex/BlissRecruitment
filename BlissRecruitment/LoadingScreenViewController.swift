//
//  LoadingScreenViewController.swift
//  BlissRecruitment
//
//  Created by António Pinto on 13/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import UIKit
import KDLoadingView
import Alamofire

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingView: KDLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadingView.startAnimating()
        
        let utilityQueue = DispatchQueue.global(qos: .userInitiated)
        Alamofire.request("https://private-bbbe9-blissrecruitmentapi.apiary-mock.com/health").validate().responseJSON(queue: utilityQueue) { response in
            
            switch response.result {
            case .success:

                if let parsedData = try? JSONSerialization.jsonObject(with: response.data!) as! [String:Any] {
                    print(parsedData)
                    let a = parsedData["status"]
                    print("Valor de a: \(a ?? "sem valor")")
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



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
import SwifterSwift

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingView: KDLoadingView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var btTryConnection: UIButton!
    
    var healthStatus:Bool = false {
        didSet {
            if healthStatus {
                //Go to ListaViewController
                //Stop animation spinner
                self.loadingView.stopAnimating()
                self.lbStatus.text = ""
                self.setHidenStatusOfButton(true)
                
                performSegue(withIdentifier: "QuestionsListSegue", sender: nil)
                
            }else{
                //show button to try
                //Stop animation spinner
                self.loadingView.stopAnimating()
                self.lbStatus.text = "Unavailable services!"
                self.setHidenStatusOfButton(false)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        checkInternetAndServices()
        
    }
    
    func checkInternetAndServices() {
        
        setHidenStatusOfButton(true)
        
        //Check internet connection
        if currentReachabilityStatus != .notReachable {
            //Check health of service
            callHealthService()
        }else{
            //show button to try
            //Stop animation spinner
            self.loadingView.stopAnimating()
            self.lbStatus.text = "Unavailable Internet!"
            self.setHidenStatusOfButton(false)
        }
    }

    func callHealthService() {
        
        //Start animation spinner
        loadingView.startAnimating()
        lbStatus.text = "Checking internet and services..."
        
        //let utilityQueue = DispatchQueue.global(qos: .userInitiated)
        //Alamofire.request("https://private-bbbe9-blissrecruitmentapi.apiary-mock.com/health").validate().responseJSON(queue: utilityQueue) { response in
        Alamofire.request("https://private-bbbe9-blissrecruitmentapi.apiary-mock.com/health").validate().responseJSON() { response in
            
            switch response.result {
            case .success:
                
                if let parsedData = try? JSONSerialization.jsonObject(with: response.data!) as! [String:Any] {
                    let status:String = parsedData["status"] as! String
                    print("Valor status: \(status )")
                    
                    if status == "OK" {
                        self.healthStatus = true
                    }else{
                        self.healthStatus = false
                    }
                }
                
            case .failure(let error):
                print(error)
                self.healthStatus = false
                
            }
        }
    }

    @IBAction func onBtTryConnectionClick(_ sender: UIButton) {
        
        checkInternetAndServices()
    }
    
    
    
    func setHidenStatusOfButton(_ status: Bool) {
        btTryConnection?.isHidden = status
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        let destinationViewController = segue.destination
//        if let LoadingScreenViewController = destinationViewController as? LoadingScreenViewController,
//            let identifier = segue.identifier {
//                
//            }
//        }
    }
 

}



//
//  DetailsScreenViewController.swift
//  BlissRecruitment
//
//  Created by António Pinto on 14/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import ReachabilitySwift

class DetailsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbImageUrl: UILabel!
    @IBOutlet weak var lbThumbUrl: UILabel!
    @IBOutlet weak var lbPublishedAt: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btVote: UIButton!
    
    var dArrayChoices = [choices]()
    
    var detailQuestion: questions? {
        didSet {
            //setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))

        
        tableView.delegate = self
        tableView.dataSource = self
        
        setData()
        
    }

    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        self.navigationItem.title = "Details"
        //view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        
        btVote.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData() {
        if let detailQuestion = detailQuestion {
            let imageUrlString = detailQuestion.qThumbURL
            
            imgImage?.imageFromServerURL(urlString: imageUrlString, defaultImage: nil)
            lbId?.text = String(format:"%d", detailQuestion.qId)
            lbQuestion?.text = detailQuestion.qQuestion
            lbImageUrl?.text = detailQuestion.qImageUrl
            lbThumbUrl?.text = detailQuestion.qImageUrl
            lbPublishedAt?.text = String(describing: detailQuestion.qPublishedAt)
            
            let choicesTemp = detailQuestion.qChoices
            
            for i in 0..<choicesTemp.count {
                let obj = (choicesTemp as AnyObject)[i] as! NSDictionary
                addChoice(cChoice: obj["choice"] as! String, cVotes: obj["votes"] as! Int)
            }
        }
    }
    
    func addChoice(cChoice:String,
                     cVotes:Int) -> Void {
        
        let c:choices = choices(cChoice: cChoice, cVotes: cVotes)
        
        dArrayChoices.append(c)
    }
    
    @IBAction func onVoteClick(_ sender: UIButton) {
        callUpdateVotesService(question: Int(lbId.text!)!)
    }
    
    func callUpdateVotesService(question:Int) {
        
        
        let parameters = NSDictionary(object: "question_id", forKey: question as NSCopying)
        
        Alamofire.request("https://private-anon-eab296671d-blissrecruitmentapi.apiary-mock.com/questions/", method: HTTPMethod.post, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                let alert = UIAlertController(title: "Vote", message: "Update OK!", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Continuar", style: .default) { (alert: UIAlertAction!) -> Void in
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion:nil)
                break
                
            case .failure(_):
                print(response.result.error ?? "")
                break
                
            }
        }
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dArrayChoices.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choiceCell", for: indexPath) as! DetailsScreenTableViewCell
        
        // your cell coding
        let c = dArrayChoices[indexPath.row]
        
        cell.lbChoice.text = c.cChoice
        cell.lbVotes.text = String(format:"%d", c.cVotes)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btVote.isEnabled = true
        let c = dArrayChoices[indexPath.row]
        print(c.cChoice)
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

//
//  QuestionsListScreenTableViewController.swift
//  BlissRecruitment
//
//  Created by António Pinto on 13/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import ReachabilitySwift


class QuestionsListScreenTableViewController: UITableViewController {

    let reachability = Reachability()!

    let colors:[UIColor] = [HexColor("FFFFFF")!, HexColor("C2DEFF")!]
    
    var dArrayQuestions = [questions]()
    var filteredQuestions = [questions]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    deinit {
//        reachability.stopNotifier()
//        NSNotificationCenter.defaultCenter().removeObserver(self,
//                                                            name: ReachabilityChangedNotification,
//                                                            object: reachability)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        setUpView()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All","Cat1","Cat2"]
        tableView.tableHeaderView = searchController.searchBar
        
        importQuestionsData(limit: 10, offset: 0)
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                LoadingIndicatorView.hide()
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
                LoadingIndicatorView.show("Connection lost! Wating signal...")
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        

    }

    func setUpView() {
        self.navigationItem.title = "Questions"
        //view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        let ext = AppDelegate()
        print(ext.externalOpenQuery ?? "INTERNAL_Will")
    }

    
    override func viewDidAppear(_ animated: Bool) {
        let ext = AppDelegate()
        print(ext.externalOpenQuery ?? "INTERNAL_Did")
    }
    
    func importQuestionsData(limit:Int, offset:Int) {
        let urlString:String = "https://private-bbbe9-blissrecruitmentapi.apiary-mock.com/questions?" + String(limit) + "&" + String(offset)
        let url = URL(string: urlString)
        
        // Load Data
        let data = try! Data(contentsOf: url!)
        
        // Deserialize JSON
        let jsonResults = try! JSONSerialization.jsonObject(with: data, options: [])
        for i in 0..<(jsonResults as AnyObject).count {
            let obj = (jsonResults as AnyObject)[i] as! NSDictionary
    
            let dateFormatter = DateFormatter()
            // TODO: implement dateFromSwapiString
            let publishedAt = dateFormatter.date(fromSwapiString: obj["published_at"] as! String)
            
            let choices = obj["choices"] as! NSArray

            addQuestion(qId: obj["id"] as! Int,
                        qQuestion: obj["question"] as! String,
                        qImageUrl: obj["image_url"] as! String,
                        qThumbURL: obj["thumb_url"] as! String,
                        qPublishedAt: publishedAt! as NSDate,
                        qChoices: choices)
        }
    }
    
    func addQuestion(qId:Int,
                     qQuestion:String,
                     qImageUrl:String,
                     qThumbURL:String,
                     qPublishedAt:NSDate,
                     qChoices:NSArray) -> Void {
        
        let quest:questions = questions(qId: qId, qQuestion: qQuestion, qImageUrl: qImageUrl, qThumbURL: qThumbURL, qPublishedAt: qPublishedAt, qChoices: qChoices)
        
        dArrayQuestions.append(quest)
    }
    
    
//    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }
    

    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredQuestions.count
        }
        return dArrayQuestions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionsListScreenTableViewCell

        let quest:questions
        
        cell.backgroundColor = UIColor.clear
        
        if searchController.isActive && searchController.searchBar.text != "" {
            quest = filteredQuestions[indexPath.row]
        } else {
            quest = dArrayQuestions[indexPath.row]
        }
        
        // Configure the cell...
        cell.lbQuestion.text = quest.qQuestion
        cell.lbId.text = String(quest.qId)
        cell.lbPublishedAt.text = String(describing: quest.qPublishedAt)
        
        let imageUrlString = quest.qThumbURL
        cell.imgQuestion.imageFromServerURL(urlString: imageUrlString, defaultImage: nil)
        
        return cell
    }
 

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredQuestions = dArrayQuestions.filter({( quest : questions) -> Bool in
            //let categoryMatch = (quest.qQuestion == scope)
            //return categoryMatch && quest.qQuestion.lowercased().contains(searchText.lowercased())
            return quest.qQuestion.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let quest:questions
                
                if searchController.isActive && searchController.searchBar.text != "" {
                    quest = filteredQuestions[indexPath.row]
                } else {
                    quest = dArrayQuestions[indexPath.row]
                }
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailsScreenViewController
                
                //let myConfBeaconVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailsScreenViewController
                //myConfBeaconVC.detailQuestion = quest
                //navigationController?.pushViewController(myConfBeaconVC, animated: true)
                
                controller.detailQuestion = quest
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = false
            }
        }
    }
 

}

extension QuestionsListScreenTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension QuestionsListScreenTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String, defaultImage : String?) {
        if let di = defaultImage {
            self.image = UIImage(named: di)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}




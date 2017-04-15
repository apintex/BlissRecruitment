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


class QuestionsListScreenTableViewController: UITableViewController {

    let colors:[UIColor] = [HexColor("FFFFFF")!, HexColor("C2DEFF")!]
    
    var dArrayQuestions = [questions]()
    var filteredQuestions = [questions]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
    }

    func setUpView() {
        self.navigationItem.title = "Distâncias"
        //view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        let ext = AppDelegate()
        print(ext.externalOpenQuery ?? "INTERNAL")
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
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    
    
    
    
    
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
        
//        if let checkedUrl = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
//            //imageView.contentMode = .scaleAspectFit
//            downloadImage(url: checkedUrl)
//        }

        if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
            //imageView.contentMode = .scaleAspectFit
            //imageView.image = image
            cell.imgQuestion.image = image
        }

        cell.imgQuestion.image = UIImageView.imageFromServerURL("https://dummyimage.com/120x120/000/fff.png")

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
                
                controller.detailQuestion = quest
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
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

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}

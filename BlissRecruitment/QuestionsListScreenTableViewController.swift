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
        searchController.searchBar.scopeButtonTitles = ["All"]
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
//            print(obj["id"] as! Int)
//            print(obj["question"] as! String)
//            print(obj["image_url"] as! String)
//            print(obj["thumb_url"] as! String)
//            print(obj["published_at"] as! String)
    
            let dateFormatter = DateFormatter()
            // TODO: implement dateFromSwapiString
            let publishedAt = dateFormatter.date(fromSwapiString: obj["published_at"] as! String)
            print(String(describing: publishedAt))
            
            
            let choices = obj["choices"] as! NSArray
//            for c in 0..<choices.count {
//                let obj:NSDictionary = choices[c] as! NSDictionary
//                print(obj["choice"]!)
//                print(obj["votes"]!)
//            }
            
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
//        cell.lbQuestion.text = dArrayQuestions[indexPath.row].qQuestion
//        cell.lbPublishedAt.text = String(describing: dArrayQuestions[indexPath.row].qPublishedAt)

        cell.lbQuestion.text = quest.qQuestion
        cell.lbPublishedAt.text = String(describing: quest.qPublishedAt)

        
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}

//
//  CouesesTableViewController.swift
//  myNetworkPractice
//
//  Created by Emil on 05.09.2022.
//

import UIKit
import Alamofire

class CoursesTableViewController: UITableViewController {

    
    var cources: [Cources] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cources.count
    }
//MARK: identif "cell" connected with storyboard cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseCell
        let cource = cources[indexPath.row]
        cell.confingure(with: cource)
        
        return cell
    }

}

extension CoursesTableViewController {
    func fatchCources() {
        guard let url = URL(string: URLExamples.exampleFive.rawValue) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            
            do {
                //MARK: conwert letters to camelcase
                //let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.cources = try JSONDecoder().decode([Cources].self, from: data )
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func alamoFireGetButtonPressed() {
        AF.request(URLExamples.exampleTwo.rawValue)
            .validate()
            .responseJSON { responceData in
                switch responceData.result {
                case .success(let value):
                    self.cources = Cources.getCourses(from: value)
                    
//                    guard let coursesData = value as? [[String:Any]] else {return}
//
//                    for courceData in coursesData {
//                        let cource = Cources(courseData: courceData)
//                        self.cources.append(cource)
//                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
    
    func alamoFirePostButtonPressed() {
        let course = ["name": "Test",
                      "imageUrl": URLExamples.imageUrl.rawValue,
                      "numberOfLessons": "10",
                      "numberOfTests": "1"]
        
        AF.request(URLExamples.postRequest.rawValue, method: .post, parameters: course)
            .validate()
            .responseDecodable(of: Cources.self) { responce in
                switch responce.result {
                case .success(let cource):
                    self.cources.append(cource)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
}

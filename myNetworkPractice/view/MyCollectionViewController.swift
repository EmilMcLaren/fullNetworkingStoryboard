//
//  MyCollectionViewController.swift
//  myNetworkPractice
//
//  Created by Emil on 06.09.2022.
//

import UIKit



private let reuseIdentifier = "cell"
let allActions = UserActions.allCases


enum URLExamples: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case exampleOne = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    case exampleTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case exampleThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case exampleFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
    case exampleFive = "https://swiftbook.ru//wp-content/uploads/api/api_courses_capital"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
    case imageUrl = "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png"
}


enum UserActions: String, CaseIterable {
    case downloadImage = "Download Image"
    case exampleOne = "Example One"
    case exampleTwo = "Example Two"
    case exampleThree = "Example Three"
    case exampleFour = "Example Four"
    case ourCourses = "Our Courses"
    case ourCoursesV2 = "Our Courses V2"
    case postReqWithDict = "Post Req With Dict"
    case postReqWithModel = "Post Req With Model"
    case alamoFireGet = "Alamo Fire Get"
    case alamoFirePost = "Alamo Fire Post"
}


class MyCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allActions.count
    }

    // first cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for: indexPath) as! UserActionCellClass
    
        let userAction = allActions[indexPath.item]
        cell.userActionsLabel.text = userAction.rawValue
    
        return cell
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "getImage" {
//            let imageVC = segue.destination as! ImageViewController
//            imageVC.viewDidLoad()
//        }
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userActions = allActions[indexPath.row]

        switch userActions {
        case .downloadImage:
            performSegue(withIdentifier: "getImage", sender: nil)
        case .exampleOne:
            exampOneButton()
        case .exampleTwo:
            exampTwoButton()
        case .exampleThree:
            exampThreeButton()
        case .exampleFour:
            exampFourButton()
        case .ourCourses:
            performSegue(withIdentifier: "showCourses", sender: nil)
        case .ourCoursesV2:
            performSegue(withIdentifier: "showCoursesV2", sender: nil)
        case .postReqWithDict:
             postRequestWithDict()
        case .postReqWithModel: 
            postRequestWithModel()
        case .alamoFireGet:
            performSegue(withIdentifier: "alamoFireGet", sender: nil)
        case .alamoFirePost:
            performSegue(withIdentifier: "alamoFirePost", sender: nil)
        }
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        performSegue(withIdentifier: "showCourses", sender: nil)
//    }
    //MARK: identif "showCourses" connected with segue to CourcesTV
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "getImage" {
            let coursesVC = segue.destination as! CoursesTableViewController
            switch segue.identifier {
            case "showCourses":
                coursesVC.fatchCources()
            case "alamoFireGet":
                coursesVC.alamoFireGetButtonPressed()
            case "alamoFirePost":
                coursesVC.alamoFirePostButtonPressed()
            default:
                break
            }
            coursesVC.fatchCources()
        }
    }
    
//MARK: for add dintance between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
//MARK: for size of cells
extension MyCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 40, height: 110)
    }
    
    
    //MARK: alert
    private func successAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "You can see the results in the Debug aria",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func failedAlert() {
        let alert = UIAlertController(title: "Failed",
                                      message: "You can see error in the Debug aria",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    
    
    private func postRequestWithDict() {
        guard let url = URL(string: URLExamples.postRequest.rawValue) else { return }
        let course = ["name": "Test",
                      "imageUrl": URLExamples.imageURL.rawValue,
                      "numberOfLessons": "10",
                      "numberOfTests": "1"]
        
        
        guard let courseData = try? JSONSerialization.data(withJSONObject: course, options: []) else {return}
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = courseData
        
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if let error = error {
                print(error)
            }
            
            guard let responce = responce, let data = data else { return }
            
            print(responce)
            
            do {
                let course = try JSONDecoder().decode(Cources.self, from: data)
                DispatchQueue.main.async {
                    self.successAlert()
                    print(course)
                }
            } catch let error {
                print(error)
            }

        }.resume()
    }
    
    
    
    
    private func postRequestWithModel() {
        guard let url = URL(string: URLExamples.postRequest.rawValue) else { return }
        let course = CourseV3(name: "Test",
                              imageUrl: URLExamples.imageURL.rawValue,
                              numberOfLessons: "10",
                              numberOfTests: "1")
        
        
        guard let courseData = try? JSONEncoder().encode(course) else { return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = courseData
        
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if let error = error {
                print(error)
            }
            
            guard let responce = responce, let data = data else { return }
            
            print(responce)
            
            do {
                let course = try JSONDecoder().decode(CourseV3.self, from: data)
                DispatchQueue.main.async {
                    self.successAlert()
                    print(course)
                }
            } catch let error {
                print(error)
            }

        }.resume()
    }
    
}


//MARK: network
extension MyCollectionViewController {
    
    private func exampOneButton() {
        guard let url = URL(string: URLExamples.exampleOne.rawValue) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            
            do {
                let cource = try JSONDecoder().decode(Cources.self, from: data )
                print(cource)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
    private func exampTwoButton() {
        guard let url = URL(string: URLExamples.exampleTwo.rawValue) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            
            do {
                let cource = try JSONDecoder().decode([Cources].self, from: data )
                print(cource)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
    private func exampThreeButton() {
        guard let url = URL(string: URLExamples.exampleThree.rawValue) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            
            do {
                let cource = try JSONDecoder().decode(WebDescription.self, from: data )
                print(cource)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
    private func exampFourButton() {
        guard let url = URL(string: URLExamples.exampleFour.rawValue) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            
            do {
                let cource = try JSONDecoder().decode(Cources.self, from: data )
                print(cource)
                DispatchQueue.main.async {
                    self.successAlert()
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.failedAlert()
                }
            }
        }.resume()
    }
    
}

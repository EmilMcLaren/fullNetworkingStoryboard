//
//  CourseCell.swift
//  myNetworkPractice
//
//  Created by Emil on 06.09.2022.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var courceImage: UIImageView!
    @IBOutlet weak var courceNameLabel: UILabel!
    @IBOutlet weak var courceLesson: UILabel!
    @IBOutlet weak var courceTest: UILabel!
    
    
    func confingure(with cource: Cources) {
        courceNameLabel.text = cource.name
//        courceLesson.text = "Number of Lesson \(cource.numberOfLessons ?? 0)"
//        courceTest.text = "Number of Tests \(cource.numberOfTests ?? 0)"
        
        courceLesson.text = "Number of Lesson \(cource.numberOfLessons ?? "0")"
        courceTest.text = "Number of Tests \(cource.numberOfTests ?? "0")"
        
        DispatchQueue.global().async {
            guard let stringUrl = cource.imageUrl,
                    let imageUrl = URL(string: stringUrl),
                  let imageData = try? Data(contentsOf: imageUrl) else {
                      return
                  }
            DispatchQueue.main.async {
                self.courceImage.image = UIImage(data: imageData)
            }
        }
    }
}

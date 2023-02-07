//
//  ImageViewController.swift
//  myNetworkPractice
//
//  Created by Emil on 05.09.2022.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        getImage()
    }
    
    private func getImage() {
        guard let url = URL(string: URLExamples.imageURL.rawValue) else {return}
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                print(error)
                return
            }
            
            if let responce = responce {
                print(responce)
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
    }
    


}

//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Swapnil Tamrakar on 2/7/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width : scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        overviewLabel.sizeToFit()
        if let posterPath = movie["poster_path"] as? String
        {
            let smallImageUrl = NSURL(string: "https://image.tmdb.org/t/p/w45"+posterPath)
            let largeImageUrl = NSURL(string: "https://image.tmdb.org/t/p/original"+posterPath)
            let smallImageRequest = NSURLRequest(url:smallImageUrl as! URL)
            let largeImageRequest = NSURLRequest(url:largeImageUrl as! URL)
            
            self.posterImageView.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImageView.setImageWith(
                            largeImageRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.posterImageView.image = largeImage;
                                
                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
        }
        let vote = (movie["vote_average"] as! Float) / 2
        
        cosmosView.rating = Double(vote)
        cosmosView.text = String(vote)+"/5"
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        cosmosView.settings.updateOnTouch = false
        
        // Show only fully filled stars
        cosmosView.settings.fillMode = .precise
        
        // Do any additional setup after loading the view.
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

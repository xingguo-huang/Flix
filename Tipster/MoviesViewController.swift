//
//  MovieViewController.swift
//  Tipster
//
//  Created by hxg on 2/24/22.
//

//import Foundation
import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()// this is to create a dictionary of array, video explained, need revisit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self // recipt to memorise
        tableView.delegate = self // recipt to memorise
        
        print("Hello") // I did not see this printed!!! fixed by choosing the module name to be Tipster
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 self.tableView.reloadData() //call the func tableView below as soon as movies above fetched new data
                 
                 print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String

        
        
//        cell.textLabel!.text = title // "row: \(indexPath.row)" important note: Flix-TableView setup 6'18''
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
//        cell.synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath) // verify it is a url
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass the selected movie to the details view controller
        let detailViewController = segue.destination as! MovieDetailsViewController
        detailViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true) // to deselect the grayed movie
        
    }
    
}

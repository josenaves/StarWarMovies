//
//  ViewController.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 19/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import CoreData

protocol MovieSelectionDelegate: class {
    func movieSelected(_ selectedMovie: Movie)
}

class MovieListViewController: UITableViewController {
    
    weak var delegate: MovieSelectionDelegate?

    var dataProvider: DataProvider!
    
    static let dateFormatterPrint = DateFormatter()

    lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episodeId", ascending:true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nsError = error as NSError
            fatalError("Fatal error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieListViewController.dateFormatterPrint.dateFormat = "yyyy"

        self.title = "Star Wars Movies"
        dataProvider.fetchMovies { (error) in
            if error != nil {
                self.showAlertMessage(message: "Error fetching movies!")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = fetchedResultsController.object(at: indexPath)
        
        let releaseYear = MovieListViewController.dateFormatterPrint.string(from: movie.releaseDate)
        cell.textLabel?.text = "Episode \(movie.episodeId): \(movie.title) - \(releaseYear)"
        cell.detailTextLabel?.text = movie.director
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = fetchedResultsController.object(at: indexPath)
        if delegate != nil {
            delegate?.movieSelected(selectedMovie)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailsSegue" {
            let vc = segue.destination as! MovieDetailsViewController
            self.delegate = vc
        }
    }
}

extension MovieListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}

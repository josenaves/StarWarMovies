//
//  MovieDetailsViewController.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 21/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: Movie?
    
    static let dateFormatterPrint = DateFormatter()

    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelDirectorName: UILabel!
    @IBOutlet weak var labelProducerName: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelPlot: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelMovieName?.text = movie?.title
        labelDirectorName?.text = movie?.director
        labelProducerName?.text = movie?.producer
        labelPlot.text = movie?.openingCrawl
        
        MovieDetailsViewController.dateFormatterPrint.dateFormat = "MM/dd/yyyy"
        if let releaseDate = movie?.releaseDate {
            labelReleaseDate?.text = MovieDetailsViewController.dateFormatterPrint.string(from: releaseDate)
        }
    }
}

extension MovieDetailsViewController: MovieSelectionDelegate {
    func movieSelected(_ selectedMovie: Movie) {
        self.movie = selectedMovie
    }
}

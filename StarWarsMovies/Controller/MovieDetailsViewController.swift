//
//  MovieDetailsViewController.swift
//  StarWarsMovies
//
//  Created by José Naves Moura Neto on 21/05/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: Movie? {
        didSet {
            print("------- didSet")
            labelMovieName.text = movie?.title
        }
    }

    @IBOutlet weak var labelMovieName: UILabel!
}

extension MovieDetailsViewController: MovieSelectionDelegate {
    func movieSelected(_ selectedMovie: Movie) {
        movie = selectedMovie
        print("------- movieSelected")
    }
}

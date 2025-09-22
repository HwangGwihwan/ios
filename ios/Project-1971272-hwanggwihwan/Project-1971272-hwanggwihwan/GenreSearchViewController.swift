//
//  GenreSearchViewController.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/09.
//

import UIKit

class GenreSearchViewController: UIViewController {

    
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var bluesButton: UIButton!
    @IBOutlet weak var jazzButton: UIButton!
    @IBOutlet weak var reggaeButton: UIButton!
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var hiphopButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var music: [Music] = Project_1971272_hwanggwihwan.load("music.json")
    var selectedGenres: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func genreButtonTapped(_ sender: UIButton) {
        guard let genre = sender.titleLabel?.text?.lowercased() else { return }
        
        let transparentGreen = UIColor(red: 0/255, green: 249/255, blue: 0/255, alpha: 0.3)
        
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
            sender.backgroundColor = transparentGreen
        } else {
            selectedGenres.insert(genre)
            sender.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.7)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGenreDetails",
           let destinationVC = segue.destination as? GenreDetailsViewController {
            destinationVC.filteredMusic = music.filter { selectedGenres.contains($0.genre.lowercased()) }
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showGenreDetails", sender: self)
    }
    
    private func setupButtons() {
        let buttons = [popButton, countryButton, bluesButton, jazzButton, reggaeButton, rockButton, hiphopButton]
        let transparentGreen = UIColor(red: 0/255, green: 249/255, blue: 0/255, alpha: 0.3)
        
        buttons.forEach { button in
            button?.backgroundColor = transparentGreen
            button?.setTitleColor(.blue, for: .normal)
            button?.layer.cornerRadius = 8
            button?.layer.masksToBounds = true
        }
    }
}



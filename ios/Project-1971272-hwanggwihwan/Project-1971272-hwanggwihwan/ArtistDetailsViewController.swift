//
//  ArtistDetailsViewController.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/02.
//

import UIKit

class ArtistDetailsViewController: UIViewController {

    @IBOutlet weak var MusicTableView: UITableView!
    
    var filteredMusic: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MusicTableView.dataSource = self
        MusicTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMusicDetails" {
            if let destinationVC = segue.destination as? MusicDetailsViewController,
               let indexPath = MusicTableView.indexPathForSelectedRow {
                destinationVC.music = filteredMusic[indexPath.row]
            }
        }
    }
}

extension ArtistDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath)
        
        let music = filteredMusic[indexPath.row]
        cell.textLabel?.text = music.track_name
        cell.detailTextLabel?.text = music.artist_name
        
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMusicDetails", sender: self)
    }
}

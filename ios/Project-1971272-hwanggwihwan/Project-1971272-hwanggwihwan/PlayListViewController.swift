//
//  PlayListViewController.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/09.
//

import UIKit
import FirebaseFirestore

class PlayListViewController: UIViewController {

    @IBOutlet weak var PlaylistTableView: UITableView!
    
    let db = Firestore.firestore()
    var playlists: [Music] = []
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        PlaylistTableView.dataSource = self
        PlaylistTableView.delegate = self
        
        fetchPlaylists()
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchPlaylists() {
        listener = db.collection("playlists").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.playlists = querySnapshot?.documents.compactMap {
                    let data = $0.data()
                    let artistName = data["artist_name"] as? String ?? ""
                    let trackName = data["track_name"] as? String ?? ""
                    let releaseDate = data["release_date"] as? Int ?? 0
                    let genre = data["genre"] as? String ?? ""
                    let lyrics = data["lyrics"] as? String ?? ""
                    let len = data["len"] as? Int ?? 0
                    let topic = data["topic"] as? String ?? ""
                    return Music(artist_name: artistName, track_name: trackName, release_date: releaseDate, genre: genre, lyrics: lyrics, len: len, topic: topic)
                } ?? []
                DispatchQueue.main.async {
                    self.PlaylistTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMusicDetails",
           let destinationVC = segue.destination as? MusicDetailsViewController,
           let indexPath = PlaylistTableView.indexPathForSelectedRow {
            let selectedMusic = playlists[indexPath.row]
            destinationVC.music = selectedMusic
        }
    }
}

extension PlayListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        
        let playlist = playlists[indexPath.row]
        cell.textLabel?.text = playlist.track_name
        cell.detailTextLabel?.text = playlist.artist_name
        
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMusicDetails", sender: self)
    }
}

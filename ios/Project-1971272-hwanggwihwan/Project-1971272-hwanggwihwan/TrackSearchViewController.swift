//
//  TrackSearchViewController.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/06.
//

import UIKit

class TrackSearchViewController: UIViewController {
    
    @IBOutlet weak var TrackPickerView: UIPickerView!
    @IBOutlet weak var Search: UIButton!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var music: [Music] = Project_1971272_hwanggwihwan.load("music.json")
    var uniqueTracks: [String] = []
    var filteredTracks: [String] = []
    var selectedTrack: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 노래 제목 중복되지 않게
        let trackSet = Set(music.map { $0.track_name })
        uniqueTracks = Array(trackSet)
        filteredTracks = uniqueTracks
        
        TrackPickerView.dataSource = self
        TrackPickerView.delegate = self
        SearchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // Function to filter music by selected track name
    func filterMusicByTrack(_ track: String) -> [Music] {
        return music.filter { $0.track_name == track }
    }
    
    // Function to pass filtered music to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTrackDetails" {
            if let destinationVC = segue.destination as? TrackDetailsViewController {
                if let selectedTrack = selectedTrack {
                    destinationVC.filteredMusic = filterMusicByTrack(selectedTrack)
                }
            }
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showTrackDetails", sender: self)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension TrackSearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredTracks.count
    }
    
    // UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredTracks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTrack = filteredTracks[row]
        hideKeyboard()
    }
}

extension TrackSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTracks = uniqueTracks
        } else {
            filteredTracks = uniqueTracks.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        TrackPickerView.reloadAllComponents()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

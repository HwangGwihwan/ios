//
//  NameSearchViewController.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/02.
//

import UIKit

class NameSearchViewController: UIViewController {

    @IBOutlet weak var NamePickerView: UIPickerView!
    @IBOutlet weak var Search: UIButton!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var music: [Music] = Project_1971272_hwanggwihwan.load("music.json")
    var uniqueArtists: [String] = []
    var filteredArtists: [String] = []
    var selectedArtist: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //가수 이름 중복되지 않게
        let artistSet = Set(music.map { $0.artist_name })
        uniqueArtists = Array(artistSet)
        filteredArtists = uniqueArtists
        
        NamePickerView.dataSource = self
        NamePickerView.delegate = self
        SearchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // Function to filter music by selected artist
    func filterMusicByArtist(_ artist: String) -> [Music] {
        return music.filter { $0.artist_name == artist }
    }
    
    // Function to pass filtered music to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArtistDetails" {
            if let destinationVC = segue.destination as? ArtistDetailsViewController {
                if let selectedArtist = selectedArtist {
                    destinationVC.filteredMusic = filterMusicByArtist(selectedArtist)
                }
            }
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showArtistDetails", sender: self)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension NameSearchViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredArtists.count
    }
    
    // UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredArtists[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedArtist = filteredArtists[row]
        hideKeyboard()
    }
}

extension NameSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredArtists = uniqueArtists
        } else {
            filteredArtists = uniqueArtists.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        NamePickerView.reloadAllComponents()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

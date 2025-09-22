//
//  MusicDetailsViewController.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/02.
//

import UIKit
import FirebaseFirestore

class MusicDetailsViewController: UIViewController {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var lenLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var lyricsLabel: UILabel!
    
    var music: Music?
    let db = Firestore.firestore()
    var isAddedToPlaylist = false
    var documentID: String? // Firestore 문서 ID를 저장할 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let music = music {
            artistNameLabel.text = "가수:  " + music.artist_name
            trackNameLabel.text = "제목:  " + music.track_name
            releaseDateLabel.text = "발매 연도:  " + String(music.release_date) + "년"
            genreLabel.text = "장르:  " + music.genre
            lenLabel.text = "길이:  " + String(music.len) + "초"
            topicLabel.text = "주제:  " + music.topic
            lyricsLabel.text = "가사\n" + music.lyrics
            
            // 상태와 문서 ID를 불러와서 설정합니다.
            isAddedToPlaylist = UserDefaults.standard.bool(forKey: musicKey(music))
            documentID = UserDefaults.standard.string(forKey: musicDocumentKey(music))
        }
        
        updatePlaylistButtonImage() // 초기 상태에 맞게 버튼 이미지 설정
    }
    
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Playlist(_ sender: UIBarButtonItem) {
        guard let music = music else { return }
        
        if isAddedToPlaylist {
            // Firestore에서 데이터 삭제
            if let documentID = documentID {
                db.collection("playlists").document(documentID).delete { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.isAddedToPlaylist.toggle() // 상태를 변경
                        self.updatePlaylistButtonImage() // 버튼 이미지를 업데이트
                        
                        // 상태와 문서 ID를 삭제합니다.
                        UserDefaults.standard.set(self.isAddedToPlaylist, forKey: self.musicKey(music))
                        UserDefaults.standard.removeObject(forKey: self.musicDocumentKey(music))
                    }
                }
            }
        } else {
            // Firestore에 데이터 저장
            var ref: DocumentReference? = nil
            ref = db.collection("playlists").addDocument(data: [
                "artist_name": music.artist_name,
                "track_name": music.track_name,
                "release_date": music.release_date,
                "genre": music.genre,
                "lyrics": music.lyrics,
                "len": music.len,
                "topic": music.topic
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added!")
                    self.isAddedToPlaylist.toggle() // 상태를 변경
                    self.updatePlaylistButtonImage() // 버튼 이미지를 업데이트
                    
                    // 상태와 문서 ID를 저장합니다.
                    self.documentID = ref?.documentID
                    UserDefaults.standard.set(self.isAddedToPlaylist, forKey: self.musicKey(music))
                    UserDefaults.standard.set(self.documentID, forKey: self.musicDocumentKey(music))
                }
            }
        }
    }
    
    // 상태에 따라 버튼 이미지를 업데이트하는 메서드
    func updatePlaylistButtonImage() {
        if isAddedToPlaylist {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "minus")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "plus")
        }
    }
    
    // UserDefaults 키를 생성하는 메서드
    private func musicKey(_ music: Music) -> String {
        return "\(music.artist_name)_\(music.track_name)_\(music.release_date)_\(music.genre)_\(music.len)_\(music.topic)_isAddedToPlaylist"
    }
    
    // UserDefaults 문서 ID 키를 생성하는 메서드
    private func musicDocumentKey(_ music: Music) -> String {
        return "\(music.artist_name)_\(music.track_name)_\(music.release_date)_\(music.genre)_\(music.len)_\(music.topic)_documentID"
    }
}

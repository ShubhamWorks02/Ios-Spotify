//
//  ViewPlaylistVC.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 07/07/23.
//

import UIKit
import Kingfisher

class ViewPlaylistVC: UIViewController, Storyboarded, AdditionalInfoAlbum {
    
    func getAdditionalInfo(footerDetails: DisplayAlbumFooterView) {
        self.lblReleasedate.text = "Release Date :- \(footerDetails.releaseDate)"
        self.lblSongCount.text = "\(footerDetails.totalSongs) Songs"
        self.artistId = footerDetails.artistId
        self.lblCopyRights.text = footerDetails.copyRight
        viewModel.getArtist(id: artistId)
    }

    // MARK: - Outlets
    @IBOutlet private weak var lblOwnerName: UILabel!
    @IBOutlet private weak var lblPlaylistName: UILabel!
    @IBOutlet private weak var tblSongs: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet private weak var imgPlaylist: UIImageView!
    @IBOutlet private weak var lblSongCount: UILabel!
    @IBOutlet private weak var lblArtistName: UILabel!
    @IBOutlet private weak var lblCopyRights: UILabel!
    @IBOutlet private weak var imgArtist: UIImageView!
    @IBOutlet private weak var lblReleasedate: UILabel!
    
    // MARK: - Variables
    var coordinator: ViewPlaylistCoordinator?
    var songData: LibraryDisplay?
    var viewModel = ViewSongsViewModel()
    var songs: DisplaySong = DisplaySong(type: nil, data: [])
    var artistId = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    @IBAction func btnPlayClick(_ sender: UIButton) {
        coordinator?.goToViewSong(currentSong: 0)
    }
    
    private func setUpUI() {
        aiLoading.startAnimating()
        imgArtist.layer.cornerRadius = imgArtist.bounds.width / 2
        tblSongs.tableHeaderView = headerView
        tblSongs.register(UINib(nibName: "AlbumSongCell", bundle: nil), forCellReuseIdentifier: "AlbumSongCell")
        if let songData = songData {
            lblOwnerName.text = songData.ownerDisplayName
            lblPlaylistName.text = songData.name
            imgPlaylist.kf.setImage(with: URL(string: songData.image ?? ""), placeholder: UIImage(named: "RoundProfile"))
            if songData.type == LibraryItemType.playlist {
                tblSongs.tableFooterView = nil
                viewModel.getPlaylistSong(id: songData.id ?? "")
            } else if songData.type == LibraryItemType.album {
                viewModel.delegate = self
                viewModel.getAlbumSong(id: songData.id ?? "")
            }
        }
        
        
    }
    
    private func bindViewModel() {
     
        viewModel.songs.bind { [weak self] songs in
            if let sSelf = self, let songs = songs {
                sSelf.songs = songs
                sSelf.coordinator?.songs = sSelf.songs
                sSelf.tblSongs.reloadData()
                sSelf.aiLoading.stopAnimating()
            }
        }
        
        viewModel.albumArtist.bind { [weak self] albumArtist in
            if let self = self, let imgUrl = albumArtist?.images?.first?.url {
                self.imgArtist.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: "RoundProfile"))
                self.lblArtistName.text = albumArtist?.name
            }
        }
        
        viewModel.failure.bind { [weak self] message in
            self?.showAlert(title: message)
        }
    }
}

// MARK: - Tableview datasource
extension ViewPlaylistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if songData?.type == LibraryItemType.playlist {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell else {
                return UITableViewCell()
            }
            
            if let song = songs.data?[indexPath.row] {
                cell.configureCell(song: song)
            }
            return cell
        } else if songData?.type == LibraryItemType.album {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumSongCell", for: indexPath) as? AlbumSongCell else {
                return UITableViewCell()
            }
            
            if let song = songs.data?[indexPath.row] {
                cell.configureCell(data: song)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - Tableview Delegate
extension ViewPlaylistVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.goToViewSong(currentSong: indexPath.row)
    }
    
}

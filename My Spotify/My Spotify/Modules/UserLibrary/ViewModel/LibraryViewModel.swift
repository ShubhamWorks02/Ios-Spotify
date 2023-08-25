//
//  LibraryViewModel.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 06/07/23.
//

class LibraryViewModel {
  
    // MARK: - Variables
    var success = Dynamic<LibraryPlaylist?>(nil)
    var failure = Dynamic<String>("")
    var libraryItems = Dynamic<[LibraryDisplayData]>([])
    
    // MARK: - Get initial data
    func getAllLibraryData() {
        libraryItems.value.removeAll()
        APIManager.shared.call(type: .getUserPlaylists) { [weak self] (result: Result<LibraryPlaylist, CustomError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let libraryPlaylist):
                let data = libraryPlaylist.items?.map({ item in
                    LibraryDisplay(name: item.name, ownerDisplayName: item.owner?.displayName, image: item.images?.first?.url, type: LibraryItemType.playlist, id: item.id)
                })
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: false, type: LibraryItemType.playlist, data: data ?? []))
                self.libraryItems.fire()
                
            case .failure(let error):
                self.failure.value = error.body
            }
        }
        
        APIManager.shared.call(type: .getAlbums) { [weak self] (result: Result<LibraryAlbum, CustomError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let libraryAlbums):
                let data = libraryAlbums.items?.map({ items in
                    LibraryDisplay(name: items.album.name, ownerDisplayName: items.album.artists?.first?.name, image: items.album.images?.first?.url, type: LibraryItemType.album, id: items.album.id)
                })
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: false, type: LibraryItemType.album, data: data ?? []))
                self.libraryItems.fire()
                
            case .failure(let error):
                self.failure.value = error.body
            }
        }
        
        APIManager.shared.call(type: .getUserArtists) { [weak self] (result: Result<LibraryArtist, CustomError>) in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let libraryArtists):
                let data = libraryArtists.artists?.items?.map({ item in
                    LibraryDisplay(name: item.name, ownerDisplayName: "", image: item.images?.first?.url, type: LibraryItemType.artists, id: item.id)
                })
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: false, type: LibraryItemType.artists, data: data ?? []))
                self.libraryItems.fire()
                
            case .failure(let error):
                self.failure.value = error.body
            }
        }
    }
    
    // MARK: - Get library playlist
    func getLibraryPlaylist() {
        APIManager.shared.call(type: .getUserPlaylists) { [weak self] (result: Result<LibraryPlaylist, CustomError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let libraryPlaylist):
              
                let data = libraryPlaylist.items?.map({ item in
                    LibraryDisplay(name: item.name, ownerDisplayName: item.owner?.displayName, image: item.images?.first?.url, type: LibraryItemType.playlist, id: item.id)
                })
                
                self.libraryItems.value.removeAll()
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: true, type: LibraryItemType.playlist, data: data ?? []))
                self.libraryItems.fire()
                
            case .failure(let error):
                self.failure.value = error.body
            }
        }
    }
    
    // MARK: - Get library artists
    func getLibraryArtists() {
        APIManager.shared.call(type: .getUserArtists) { [weak self] (result: Result<LibraryArtist, CustomError>) in
        
            guard let self = self else {
                return
            }
            switch result {
            case .success(let libraryArtists):
                
                let data = libraryArtists.artists?.items?.map({ item in
                    LibraryDisplay(name: item.name, ownerDisplayName: "", image: item.images?.first?.url, type: LibraryItemType.artists, id: item.id)
                })
                self.libraryItems.value.removeAll()
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: false, type: LibraryItemType.artists, data: data ?? []))
                self.libraryItems.fire()
                
            case .failure(let error):
                self.failure.value = error.body
            }
        }
    }
    
    // MARK: - Get user album
    func getLibraryAlbum() {
        APIManager.shared.call(type: .getAlbums) { [weak self] (result: Result<LibraryAlbum, CustomError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let libraryAlbum):
                
                let data = libraryAlbum.items?.map({ items in
                    LibraryDisplay(name: items.album.name, ownerDisplayName: items.album.artists?.first?.name, image: items.album.images?.first?.url, type: LibraryItemType.album, id: items.album.id)
                })
                self.libraryItems.value.removeAll()
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: true, type: LibraryItemType.album, data: data ?? []))
                self.libraryItems.fire()
                
            case .failure(let error):
                self.failure.value = error.body
            }
        }
    }
    
    // MARK: - Get user saved podcasts
    func getUserPodcasts() {
        APIManager.shared.call(type: .getUserPodcats) { [weak self] (result: Result<LibraryPodcast, CustomError>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let libraryPodcast):
                let data = libraryPodcast.items?.map { item in
                    LibraryDisplay(name: item.show?.name, ownerDisplayName: item.show?.publisher, image: item.show?.images?.first?.url, type: .podcast, id: item.show?.id, description: item.show?.description ?? "")
                }
                self.libraryItems.value.removeAll()
                self.libraryItems.value.append(LibraryDisplayData(index: 0, isFiltered: true, type: LibraryItemType.podcast, data: data ?? []))
            case .failure(let error):
                self.failure.value = error.body
            }
        }
    }
    
}

//
//  HomePlaylist.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 05/07/23.
//

import Foundation

// MARK: - Welcome
struct HomePlaylist: Codable {
    let href: String?
    let items: [Playlist]?
}

//
//  AuthModel.swift
//  My Spotify
//
//  Created by Shubham Bhatt on 05/07/23.
//

struct AuthTokenResponse: Codable {
    
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let refreshToken: String?
    let scope: String?
}

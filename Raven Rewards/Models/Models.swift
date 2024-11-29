//
//  Models.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/9/24.
//

import Foundation


struct RealUser: Codable {
    let username: String
    let email: String
}

struct Comment: Codable {
    let username: String
    let comment: String
    let dateString: String
}

struct UserInfo: Codable {
    let name: String
    let bio: String
}

struct Post: Codable {
    let id: String
    let caption: String
    let postedDate: String
    let postUrlString: String
    var likers: [String]

    var date: Date {
        guard let date = DateFormatter.formatter.date(from: postedDate) else { fatalError() }
        return date
    }

    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        return "\(username)/posts/\(id).png"
    }
}

enum Gender {
    case male, female, other
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let profilePhoto: URL
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}


public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

/// Represents a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL // either video url or full res photo
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let owner: User
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

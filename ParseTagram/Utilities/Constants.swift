//
//  Constants.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import Foundation
import UIKit

let loggedInNotificationKey = "logged_in"
let getPostsNotificationKey = "feed_posts_reloaded"
let getCommentsNotificationKey = "comments_obtained"
let signedUpNotificationKey = "signed_up"
let profileUpdatedNotificationKey = "profileUpdated"
let wasSuccessfulKey = "wasSuccessful"
let errorReturnedKey = "errorText"
let commentTextKey = "commentText"
let idKey = "id"

let defaultImageName = "person.circle.fill"
let genericFailMessage = "Unable to complete your request"

struct ProfileViewControllerConstants {
    static let cameraViewSegueId = "toProfileCameraView"
    static let imageCellId = "postImageCell"
}

struct ParseConstants {
    static let postsClass = "Posts"
    static let commentsClass = "Comments"
    static let authorKey = "author"
    static let captionKey = "caption"
    static let objectIdKey = "objectId"
    static let imageKey = "image"
    static let profileImageKey = "profileImage"
    static let textKey = "text"
    static let postKey = "post"
    static let errorKey = "error"
    static let errorbasis = "Error! "
    static let errorString1 = "postless post found"
    static let errorString2 = "post with id not found"
    static let queryLimit = 20
    static let queryIncrement = 5
    struct AppKeys {
        static let applicationId = "MXoyBk5g6qXyhfGs5ljHHoEpJOBzgGhpI0Ej5Sg5"
        static let clientKey = "cXEv3HYBe4u69CUvLxIBSeXYoWsOMldwWVMM0mne"
        static let serverUrl = "https://parseapi.back4app.com"
    }
}

struct LoginViewControllerConstants {
    static let signInErrorText = "To sign in, please type in your username and password"
    static let signUpErrorText = "To sign up, please type in your username and password"
    static let loggedInDefaultKey = "loggedIn"
    static let homeScreenSegue = "homeScreenSegue"
}

struct FeedViewControllerConstants {
    static let feedCellId = "feedCell"
    static let loadCellId = "loadCell"
    static let cameraSegue = "showCamera"
    static let showCommentCellId = "showCommentCell"
    static let addCommentCellId = "newCommentCell"
}

struct FeedTableViewCellConstants {
    static let imageBorderColor : CGColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 0.504093536)
    static let imageBorderWidth : CGFloat = 1
}

struct LoadingCellConstansts {
    static let loadingText = "Loading posts..."
    static let doneLoadingText = "No posts to load"
}

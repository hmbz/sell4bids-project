//
//  GlobalStrings.swift
//  Sell4Bids
//
//  Created by admin on 8/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import SocketIO

//TODO:- Api Call Strings
let BaseUrl = "https://apis.sell4bids.com" // Live Server
//let BaseUrl = "http://192.168.29.115:3000" // Local Server
//let BaseUrl = "https://devapis.sell4bids.com" // Dev Server

let SignUpURL = "\(BaseUrl)/authentication/signup"
let SocialLoginUrl = "\(BaseUrl)/authentication/socialMediaLogin"
let updateProfileURL = "\(BaseUrl)/users/updateUserDetails"
let filterURL = "\(BaseUrl)/items/filter"
let itemDetailUrl = "\(BaseUrl)/items/itemDetails"
let getFilterUrl = "\(BaseUrl)/items/filter"
let acceptOfferStatusChangeUrl = "\(BaseUrl)/items/setAcceptingOffers"
let ordersStatusChangeUrl = "\(BaseUrl)/items/orderingStatus"
let updateQuantityUrl = "\(BaseUrl)/items/setQuantity"
let itemVisibilityUrl = "\(BaseUrl)/items/hideItem"
let itemRelistUrl = "\(BaseUrl)/items/reListing"
let endListingUrl = "\(BaseUrl)/items/endingList"
let turboChargeUrl = "\(BaseUrl)/items/turboCharge"
let automaticallyRelistingUrl = "\(BaseUrl)/items/AutoReListing"
let biddingHistoryUrl = "\(BaseUrl)/items/itemBiddingHistory"
let sellerShareLocationUrl = "\(BaseUrl)/items/sellerShareLocation"
let bidItemUrl = "\(BaseUrl)/items/bidItem"
let buyerOfferUrl = "\(BaseUrl)/items/buyerOffer"
let buyItemUrl = "\(BaseUrl)/items/buyItem"
let unwatchedUrl = "\(BaseUrl)/users/unwatchItem/"
let watchedUrl = "\(BaseUrl)/users/watchItem/"
let reportItemUrl = "\(BaseUrl)/items/reportItem"
let sellerDetailsUrl = "\(BaseUrl)/users/sellerDetails"
let buyerCounterOfferUrl = "\(BaseUrl)/items/buyerCounterOffer"
let rejectBuyerCounterOfferUrl = "\(BaseUrl)/items/rejectOfferBuyer"
let acceptBuyerCounterOfferUrl = "\(BaseUrl)/items/acceptOfferBuyer"
let getLastChatUrl = "\(BaseUrl)/chat/getLastChats"
let getChatUrl = "\(BaseUrl)/chat/getChat"
let getNotificationUrl = "\(BaseUrl)/notifications/getNotifications"
let readNotificationUrl = "\(BaseUrl)/notifications/readNotification/"
let setUserTokenUrl = "\(BaseUrl)/users/setUserToken"
let getNotificationCountUrl = "\(BaseUrl)/notifications/getNotificationCount"
let socialMediaLoginUrl = "\(BaseUrl)/authentication/socialMediaLogin"
let loginUrl = "\(BaseUrl)/authentication/login"
let acceptOrderUrl = "\(BaseUrl)/items/acceptOrder"
let rejectOrderUrl = "\(BaseUrl)/items/rejectOrder"
let sellerMarkedPaidUrl = "\(BaseUrl)/items/sellerMakedPaid"
let getOrderUrl = "\(BaseUrl)/items/getOrders"
let buyerRatingUrl = "\(BaseUrl)/items/buyerRating"
let rejectSellerOfferUrl = "\(BaseUrl)/items/rejectOfferSeller"
let acceptSellerOfferUrl = "\(BaseUrl)/items/acceptOfferSeller"
let addItemUrl = "\(BaseUrl)/items/addItem"
let addVehicleUrl = "\(BaseUrl)/items/addVehicle"
let getVehicleYearUrl = "\(BaseUrl)/vehicles/getYears"
let getVehicleMakeUrl = "\(BaseUrl)/vehicles/getMake"
let getVehicleModelUrl = "\(BaseUrl)/vehicles/getModel"
var getVehicleTrimUrl = "\(BaseUrl)/vehicles/getTrim"
var getVehicleFuelTypeUrl = "\(BaseUrl)/vehicles/getFuelType"

//MARK:- Custom Messages Strings

//TODO:- SELL4BIDS IMPORTANT STRINGS
let appName = "Sell4Bids"
let StrNetworkError = "Network Error"
let AllowEmail = "You must have to share email to get app content"
let StrCheckNetworkAvailibility = "Please check your network connection and try again."

//TODO:- LOGIN SCREEN MESSAGES
let StrSuccessLogin = "You have been signed in successfully."
let StrFacebookLoginFailed = "Login With Facebook Failed"
let strInvalidEmailValidation = "Please enter a valid email address."
let strEmptyEmailValidation = "Please enter your email address."
let strEmptyNameValidation = "Name cannot be empty."
let strUsernameLengthValidation = "Name must be between 3 - 64 characters"
let strEmptyPassValidation = "Please enter your password."
let strInvalidPassValidation = "Password must be at least 8 characters."
let StrLogIn = "Login"
//TODO:- LOGOUT SCREEN SCREEN
let StrSignUp = "Sign up"

//TODO:- NETWORKING RESPONSE
let StrTechnicalIssue = "Oops, there seems to be Technical Issue."


let StrEmailSendToAC = "Please verify your account by clicking the link sent to your email."

let StrLogOutFromSell4Bids = "You have been successfully signed out from Sell4Bids"
let StrEstablishContactSuccessMessage = "Thank you for choosing Sell4bids, Your Message send Sucessfully!, We will contact you as soon as possible"


let strFileSizeTooLarge = "File Size too large please try again later"
let strServerDown = "Server down. please try again later"
let StrWrongCredentials = "Unable to login with provided credentials."
let StrVerficationSendCheckEmail = "A verification email has been sent to your email address. Please check your Inbox for Account Activation Instructions."

let StrServerError = "Server not responding Please try again later"
let StrCancelRegeuest = "Cancelled request"
let StrInternalError = "Internal error occurs please try again later"
let StrAcceptOffer = "Accept Offers"
let StrStopAcceptingOffer = "Stop accepting offers"
let StrBuyNow = "Buy Now"
let strLoginRequired = "Login Required"
let strLoginRequiredForListing = "You have to login first to continue"
let StrYes = "Yes"
let StrNo = "No"
let strCancel = "Cancel"
let StrOfferStatus = "Offer status"
//let "StrOrderStatus".localizableString(loc: LanguageChangeCode) = "Order status"
let StrReportItem = "Report Item"
let StrStopNewOrders = "Stop new orders"
let StrGetNewOrders = "Get new orders"
let StrUpdateQuantity = "Update Quantity"
let StrHideItem = "Hide item"
let StrShowItem = "Show item"
let StrItemVisibility = "Item Visibility"
let StrRelistItem = "Relist item"
let StrEndListItem = "End listing"
let StrTurboCharge = "Turbo Charge"
let StrStopAutomaticallyRelisting = "Stop automatically relisting"
let StrAutomaticallyRelisting = "Automatically relisting"
let StrOk = "Ok".localizableString(loc: LanguageChangeCode)
let StrSelectLocation = "Select Location"
let StrOrderPlacedSuccessfully = "Your order has been placed successfully"
let StrBids = "Bids"
let StrRemoveFromWatchlist = "Remove from Watch List"
let StrAddToWatchlist = "Add to Watch List"
let StrWatchlist = "WatchList"
let StrItemShare = "Check out this housing that i found on The Sell4Bids Marketplace."
let StrCounterOffer = "Counter Offer"
let StrChat = "My Chat"
let strOrderConfirmation = "Order Confirmation"
let strOrderRejection = "Order Rejection"
let strMarkedAsPaid = "Marked as paid"
let strBuyerRated = "Buyer Rated"
let strPleaseGiveReason = "Please give a reason."
let strSellerRejectOffer = "Seller Rejected Offer"
let strSellerAcceptOffer = "Seller Accepted Offer"
let strMaximumPhotoAllowed = "Maximum of 14 photos are allowed to be uploaded."
let strMaximumPhotoLimitReached = "Maximum Photo limit reached."
let strListing = "Listing"
let strEmptyImageArray = "Please select photo to continue"
let strEmptyTitleTextField  = "Please enter title of your item at least 3 words"
let strEmptyCategory = "Please select category"
let strVehicleLocationError = "Currently, vehicle listing is not available in this country"
let strBidNowValidation = "Please enter right Bid Price"
let strCounterOfferEmptyPrice = "Please Enter counter Offer Price"
let strCounterOfferEmptyQuantity = "Please Enter counter Offer quantity"
let strCounterOfferQuantityCheck = "Please enter quantity according to stock"
let strCounterOfferSuccessfullySend = "Counter offer successfully send"

//View Controller Names
let StrOrders = "Orders"
let StrOffers = "Offers"

// Action Strings
let  actionChat = "chat"
let  actionWatching = "watching"
let  actionSelling = "selling"
let  actionBuying = "buying"
let  actionBought = "bought"
let  actionBids = "bids"
let  actionWarning = "winning"
let  actionFollower = "followers"
let  actionFollowing = "following"
let  actionBlocklist = "blocklist"
let  actionItems = "items"
let  actionVehicles = "vehicles"
let  actionRealEstate = "realestates"
let  actionServices = "services"
let  actionJobs = "jobs"

// Housing Listing
let strRealEstateSelection = "Please select house type option for your listing"
let strBedRoomsSelection = "Please select bedroom option for your listing"
let strBathroomsSelection = "Please select private bathroom option for your listing"
let strLaundrySelection = "Please select laundry option for your listing"
let strParkingSelection = "Please select parking option for your listing"
let strAvailableOnDateSelection = "Please select Available Date for your listing"
let strSquareFeetValidation = "Please enter a square feet with a minimum of 1 characters."

//Questions
let StrQStopBuyerToSendOffer = "Do you want to stop buyers to send offers?"
let StrQAllowBuyerToSendOffer = "Do you want buyers to send offers?"
let StrQStopBuyerToSendOrder = "Do you want to stop buyers to send new orders?"
let StrQAllowBuyerToSendOrder = "Do you want buyers to send new orders?"
let StrQHideItemFromBuyers = "Item will not be visible to buyers. Do you want to hide the Item?"
let  StrQShowItemToBuyer = "Item will be visible to new buyers. Do you want to un-hide the Item?"
let StrQDoRelistItem = "Do you want to re-list this Item?"
let StrQTurboChargeItem = "Item will be shown first to new users. Do you want to turbo charge the Item?"
let StrQDisableAutomaticallyRelisting = "Item will not be automatically re-listed for 03 more days after expiration. Do you want to disable automatic re-listing of the Item?"
let StrQEnableAutomaticallyRelisting = "Item will be automatically re-listed for 03 more days after expiration. Do you want automatic re-listing for the Item?"
let StrQWantToBuyItem = "Do you want to buy this item"
let StrQWantToAcceptOffer = "Do you want to accept the offer?"
let strQConfirmOrder = "Do you want to confrim this order?"
let strQRejectCounterOffer = "Do you want to reject this offer?"
let strQRejectOrder = "Do you want to reject this order?"
let strQConfirmPayment = "Do you confrim to recieved payments"
let strEdTextFieldPlaceholder = "Type or you can ask me anything"
let strSellerBlocked = "Seller is blocked"
let strQuantityAccordingToStock = "Please enter quantity according to available stock"
let strEmptyQuantity = "Please enter quantity to continue"
let zeroQuantity = "Please enter valid qunatity"
let photoalert = "  Please add atleast 01 photo of your item.  "
let exceedStrng = "Title must not exceed 70 characters. "

//MARK:-  Listing items Strings
let relatedCatagory = "Please enter a suitable title for your item."
let descStrng = "   Please enter a description for your item with minimum 20 characters. "
let limitStrng = " Description must not exceed 1200 characters. "

// For Listing Messeges
struct listingFinalMessage {
    static let instance = listingFinalMessage()
    let service = "Your service listing has been submitted successfully and will be listed on the Sell4Bids marketplace after approval."
    let job = "Your job listing has been submitted successfully and will be listed on the Sell4Bids marketplace after approval."
    let item = "Your item listing has been submitted successfully and will be listed on the Sell4Bids marketplace after approval."
    let vehicle = "Your vehicle listing has been submitted successfully and will be listed on the Sell4Bids marketplace after approval."
}

//TODO:- For Validation
let strDescriptionValidation = "Please enter description with a minimum of 20 characters."
let strEmptyPriceField = "Please enter price to continue"
let StrUpodateEmptyQuantity = "Please enter quantity to continue"



let allowedCharcterforNameString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
let allowedCharacterForEmailString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 @."

//TODO:- Important String
let gifName = "red"
let privacyPolicyUrl = "https://sell4bids.com/privacy"
let termOfUseUrl = "https://sell4bids.com/terms"

//Important Strings used for connecting Strings
var socket : SocketIOClient?
var manager = SocketManager(socketURL: URL(string: BaseUrl)!, config: [.log(false),.connectParams(["uid" : SessionManager.shared.userId]), .compress])
let GoogleMapsAPIServerKey = "AIzaSyDrU4jdzEOaKS-eDk2H0_C9Sv__HOhdaVI"

//MARK:- StoryBoard
struct sell4bidsStoryBoard {
    static let instance = sell4bidsStoryBoard()
    let main = "Main"
    let home = "Home"
    let descrioption = "Description"
}


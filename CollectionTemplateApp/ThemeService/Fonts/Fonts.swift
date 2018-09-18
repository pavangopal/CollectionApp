//
//  Fonts.swift
//  DemoApp-iOS
//
//  Created by Albin CR on 2/6/17.
//  Copyright © 2017 Albin CR. All rights reserved.
//
import Foundation


public protocol Fonts{
    
    var storyHeadlineFont: UIFont {get}
    var storyTextElementFont: UIFont {get}
    var storySummaryElementFont: UIFont {get}
    var storyBlockQuoteElementFont: UIFont {get}
    var storyBlurbElementFont: UIFont{get}
    var storyBigFactElementFont: UIFont {get}
    var questionElementFont: UIFont{get}
    var answerElementFont: UIFont{get}
    var storyQuoteElementFont: UIFont {get}
    var storyTitleElementFont: UIFont {get}
    
    var storyKeyEventFont:UIFont{get}
    var alsoReadElementFont:UIFont{get}
    
    var storySectionFont: UIFont {get}
    var storyPostedTimeFont: UIFont {get}
    
    var imageCaptionFont: UIFont {get}
    var imageAttributionFont:UIFont{get}
    
    var blockQuoteAttributionFont:UIFont{get}
    
    var primaryBoldFont : UIFont {get}
    
    var sorterElementFont:UIFont {get}
    
    var pagerTopBarMenuFont:UIFont {get}
    
    
    var searchScreenSectionFont:UIFont{get}
    var searchScreenStoryTitleFont:UIFont{get}
    var searchScreenAuthorTimeStampFont:UIFont{get}
    
    var errorMessageFont: UIFont{get}
    
    var sponsoredTextFont: UIFont{get}
    
}

enum FontSize{

    case Small
    case Medium
    case Large
    
}

enum FontFamilyName:String{
    
    case OpenSans =  "OpenSans"
    case OpenSansSemibold = "OpenSans-Semibold"
    
    case Merriweather = "Merriweather"
    case MerriweatherRegular = "Merriweather-Regular"
    case MerriweatherBold = "Merriweather-Bold"
    case MerriweatherItalic = "Merriweather-Italic"
    case MerriweatherBoldItalic = "Merriweather-BoldItalic"
    
    case LibelSuitRegular = "LibelSuit-Regular"
    
    case OswaldRegular = "Oswald-Regular"
    case OswaldMedium = "Oswald-Medium"
    case OswaldBold = "Oswald-Bold"
    
    case CooperHewittBold = "CooperHewitt-Bold"
    case CooperHewittLight = "CooperHewitt-Light"
    case CooperHewittSemibold = "CooperHewitt-Semibold"
    case LatoBold = "Lato-Bold"
    
    case LatoRegular = "Lato-Regular"
    case LatoSemibold = "Lato-Semibold"
    case LatoLight = "Lato-Light"
    
    
    
}

extension Fonts{
    
    
  public func getCorrectedFont(fontName:String,size:CGFloat) -> UIFont{
        //TODO: Phase 3
        
        if let currentFontType = UserDefaults.standard.value(forKey: "FontSize") as? FontSize{
            
            switch currentFontType{
                
            case .Small:
                
                return UIFont(name: fontName, size: size)!
                
            case .Medium:
                return UIFont(name: fontName, size: size)!
                
                
            case .Large:
                return UIFont(name: fontName, size: size)!
                
            }
        }else{
            return UIFont(name: fontName, size: size)!
        }
    }
    
    
    
    var searchScreenSectionFont:UIFont{
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.OpenSansSemibold.rawValue, size: 12.0)
        }
    }
    
    var searchScreenStoryTitleFont:UIFont{
        
            return self.getCorrectedFont(fontName: FontFamilyName.OpenSansSemibold.rawValue, size: 15.0)
    }
    
    var searchScreenAuthorTimeStampFont:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.OpenSans.rawValue, size: 12.0)
            
        }
    }
    
    var primaryBoldFont:UIFont{
        get {

            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 16.0)
        }
    }
    
    var blockQuoteAttributionFont:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 12.0)
            
        }
    }
    
    var storyTextElementFont:UIFont{
        get {
            
            return UIFont(name: FontFamilyName.MerriweatherRegular.rawValue, size: 16)!
        }
    }
    
    var storyHeadlineFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 20.0)
            
        }
    }
    
    var storySectionFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 12.0)
            
        }
    }
    
    var storyPostedTimeFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 12.0)
            
        }
    }
    
    var storySummaryElementFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 16.0)
            
        }
    }
    
    //TODO:Replace the actual font
    var storyTitleElementFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 20.0)
            
        }
    }
    
    //TODO:Replace the actual font
    var explainerTitleElementFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 18.0)
        }
    }
    
    var explainerTitleIndexElementFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 20.0)
            
        }
    }
    
    var storyQuoteElementFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherItalic.rawValue, size: 18.0)
        }
    }
    
    var storyBlockQuoteElementFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherItalic.rawValue, size: 18.0)
        }
    }
    
    var storyBigFactElementFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBoldItalic.rawValue, size: 20.0)
        }
    }
    var storyBigFactAttributtionFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherItalic.rawValue, size: 18.0)
        }
    }

    
    var storyDetailAuthorFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 13.0)
        }
    }
    
    
    
    var imageCaptionFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBoldItalic.rawValue, size: 13.0)
        }
    }

    var storyBlurbElementFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherItalic.rawValue, size: 18.0)
        }
    }
    
    var questionElementFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 16.0)
        }
    }
    
    var answerElementFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherRegular.rawValue, size: 16.0)
        }
    }
    
    //TODO://change this to actuall font
    
    var storyKeyEventFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 11.0)
        }
    }
    
    var sponsoredTextFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 13.0)
        }
    }
    
    var alsoReadElementFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherRegular.rawValue, size: 16.0)
        }
    }
    
    var imageAttributionFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBoldItalic.rawValue, size: 13.0)
        }
    }

    var sorterElementFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherRegular.rawValue, size: 13.0)
        }
    }
    
    //HOME-Layout
    
    var pagerTopBarMenuFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.OswaldMedium.rawValue, size: 20.0)
        }
    }
    
    var listCellStoryHeadlineFont: UIFont {
        get {
            
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 18.0)
            
        }
    }
    
    
    var listCellEngagmentFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.Merriweather.rawValue, size: 11.0)
            
        }
    }
    
    var collectionTitleFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoBold.rawValue, size: 28.0)
        }
    }
    
    var showMoreButtonFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.OswaldMedium.rawValue, size: 18.0)
        }
    }
    
    var ChannelTitleFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.OswaldBold.rawValue, size: 30.0)
        }
    }
    
    var BigStoryViewAllFont: UIFont {
        get{
            return self.getCorrectedFont(fontName: FontFamilyName.OswaldRegular.rawValue, size: 13.0)
        }
    }
    
    var VideoStaticTitleFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherBold.rawValue, size: 30.0)
        }
    }
    
    var errorMessageFont: UIFont {
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.MerriweatherRegular.rawValue, size: 15.0)
        }
    }
    
    
    //New
    
    var homeHeadlineRegular:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoBold.rawValue, size: 18.0)
        }
    }
    
    var homeHeadlineBold:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoBold.rawValue, size: 18.0)
        }
    }
    
    var homeHeadlineLight:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoLight.rawValue, size: 18.0)
        }
    }
    
    var homeSubHeadlineRegular:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoRegular.rawValue, size: 16.0)
        }
    }
    
    var homeAuthorFont:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoRegular.rawValue, size: 14.0)
        }
    }
    
    var homeTimestampFont:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoRegular.rawValue, size: 14.0)
        }
    }
    
    var homeSectionFont:UIFont{
        get {
            return self.getCorrectedFont(fontName: FontFamilyName.LatoRegular.rawValue, size: 14.0)
        }
    }
}



extension UIFont{
    
    func setCustomFont(font name:String,font type:UIFontTextStyle)->UIFont{
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle:type)
        let font = UIFont(name: name, size: preferredDescriptor.pointSize)
        return font!
    }
    
}


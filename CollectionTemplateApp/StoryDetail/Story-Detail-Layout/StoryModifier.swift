//
//  DisplayStringGenerator.swift
//  TheQuint-Staging
//
//  Created by Pavan Gopal on 12/26/17.
//  Copyright © 2017 Pavan Gopal. All rights reserved.
//

import Foundation
import Quintype
import TwitterKit

class StoryModifier{
    
    class func getDisplayText(storyDetailLayout:[[StoryDetailLayout]],story:Story){
        
        let parentSectionColor = ThemeService.shared.theme.primarySectionColor
        var primaryTextColor = ThemeService.shared.theme.primaryTextColor
        
//        if story.story_template == .Video{
//            primaryTextColor = .white
//        }
        
        let sectionColor = ThemeService.shared.theme.primarySectionColor
        
        for sectionLayout in storyDetailLayout{
            for itemLayout in sectionLayout{
                
                switch itemLayout.layoutType{
                    
                case .StoryDetailHeaderImageCell:
                    
                    let titleAttributtes = textOption.imageElementText(color:.white).textAttributtes
                    let attributionAttributes = textOption.imageElementAttribution(color:.white).textAttributtes
                    
                    let titleAttributtedString = Helper.getAttributtedString(for: story.hero_image_caption, textOption: titleAttributtes)
                    let attributtionString = Helper.getAttributtedString(for: story.hero_image_attribution, textOption: attributionAttributes)
                    
                    let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "<br>",alignment: .left)
                    
                    story.imageAttributtedCaptionText = finalAttributtedString
                    
                case .StoryTextElementCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        let textAttribute = textOption.textElement(color: primaryTextColor).textAttributtes
                        
                        storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        
                    }
                    
                    break
                    
                case .ExplainerSummaryCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        let textAttribute = textOption.textElement(color: .white).textAttributtes
                        
                        storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        
                    }
                    
                    break
                    
                case .QuestionElementCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        let textAttribute = textOption.questionElement(color: .white).textAttributtes
                        
                        storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        
                    }
                    break
                    
                case .AnswerElementCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        let textAttribute = textOption.answerElement(color: ThemeService.shared.theme.primaryTextColor).textAttributtes
                        
                        storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        
                    }
                    break
                    
                case .TitleElementCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        if story.story_template == StoryTemplet.Explainer{
                            let textAttribute = textOption.explainerTitleText(color: primaryTextColor).textAttributtes
                            storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        }else{
                            let textAttribute = textOption.titleElement(color: primaryTextColor).textAttributtes
                            storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        }
                    }
                    break
                    
                case .ExplainerTitleCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        let textAttribute = textOption.explainerTitleText(color: primaryTextColor).textAttributtes
                        
                        storyElement.displayText = Helper.getAttributtedString(for: unwrappedText, textOption: textAttribute) ?? nil
                        
                    }
                    break
                    
                    
                case .StorySummaryCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        var modifiedText = unwrappedText
                        
                        let textAttributtes = textOption.summaryElement(color: ThemeService.shared.theme.primaryTextColor).textAttributtes
                        
                        modifiedText = modifiedText.replacingOccurrences(of: "\n", with: "")
                        modifiedText = modifiedText.replacingOccurrences(of: "<br>", with: "\n")
                        
                        let data = modifiedText.data(using: String.Encoding.utf8)
                        
                        let attrString = NSAttributedString(htmlData: data, options: textAttributtes, documentAttributes: nil)
                        
                        let mutableString = attrString?.mutableCopy() as? NSMutableAttributedString
                        
                        mutableString?.removeAttribute(kCTForegroundColorFromContextAttributeName as NSAttributedStringKey, range: NSRange.init(location: 0, length: mutableString?.length ?? 0))
                        storyElement.displayText = mutableString
                        
                    }
                    
                case .BlockQuoteCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    let titleAttributtes = textOption.blockQuoteElement(color: sectionColor).textAttributtes
                    let attributionAttributes = textOption.blockQuoteAttributtion(color:primaryTextColor).textAttributtes
                    
                    let titleAttributtedString = Helper.getAttributtedString(for: storyElement.metadata?.content, textOption: titleAttributtes)
                    let attributtionString = Helper.getAttributtedString(for: storyElement.metadata?.attribution, textOption: attributionAttributes)
                    
                    let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "\n")
                    
                    storyElement.displayText = finalAttributtedString
                    
                    
                case .BlurbElementCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    storyElement.displayText = Helper.getAttributtedString(for: storyElement.metadata?.content, textOption: textOption.blurbElementText(color: sectionColor).textAttributtes)
                    
                    break
                    
                case .QuoteCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    let titleAttributtes = textOption.quoteElementText(color: sectionColor).textAttributtes
                    let attributionAttributes = textOption.quoteElementAttribution(color:primaryTextColor).textAttributtes
                    
                    let titleAttributtedString = Helper.getAttributtedString(for: storyElement.metadata?.content, textOption: titleAttributtes)
                    let attributtionString = Helper.getAttributtedString(for: storyElement.metadata?.attribution, textOption: attributionAttributes)
                    
                    let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "\n")
                    
                    storyElement.displayText = finalAttributtedString
                    
                case .BigfactCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    let titleAttributtes = textOption.bigFactText(color:primaryTextColor).textAttributtes
                    let attributionAttributes = textOption.bigFactAttributtion(color: sectionColor).textAttributtes
                    
                    let titleAttributtedString = Helper.getAttributtedString(for: storyElement.metadata?.content, textOption: titleAttributtes)
                    let attributtionString = Helper.getAttributtedString(for: storyElement.metadata?.attribution, textOption: attributionAttributes)
                    
                    let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "\n")
                    
                    storyElement.displayText = finalAttributtedString
                    
                case .QuestionandAnswerCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    let answerElementAttributtes = textOption.answerElement(color:ThemeService.shared.theme.primaryTextColor).textAttributtes
                    
                    let answerAttributtedString = Helper.getAttributtedString(for: storyElement.metadata?.answer, textOption: answerElementAttributtes)
                    
                    storyElement.displayText = answerAttributtedString
                    
                case .StoryImageCell:
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    let titleAttributtes = textOption.imageElementText(color:primaryTextColor).textAttributtes
                    let attributionAttributes = textOption.imageElementAttribution(color:primaryTextColor).textAttributtes
                    
                    let titleAttributtedString = Helper.getAttributtedString(for: storyElement.title, textOption: titleAttributtes)
                    let attributtionString = Helper.getAttributtedString(for: storyElement.image_attribution, textOption: attributionAttributes)
                    
                    let finalAttributtedString = Helper.combineAttributedStrings(str1: titleAttributtedString, str2: attributtionString, seperator: "<br>",alignment: .center)
                    
                    storyElement.displayText = finalAttributtedString
                    
                case .AlsoReadCell:
                    
                    guard let storyElement = itemLayout.storyElement else{
                        continue
                    }
                    
                    if let unwrappedText = storyElement.text{
                        
                        let textAttributes = textOption.alsoReadELement(color: ThemeService.shared.theme.primaryLinkColor).textAttributtes
                        let staticString = "Also Read: "
                        let separatorAttributtes = Helper.getPlainAttributtedString(string: staticString, textColor: primaryTextColor)
                        
                        if let displayString = Helper.getAttributtedString(for: unwrappedText, textOption: textAttributes){
                            separatorAttributtes.append(displayString)
                        }
                        
                        
                        storyElement.displayText = separatorAttributtes
                        
                    }
                    
                default:
                    break
                }
                
            }
        }
    }
    
    
    
    class func updateStoryTempletBasedOnMetaData(story:Story){
        if ((story.storyMetadata?.viewType == .CounterView) ) || ((story.storyMetadata?.viewType) == .View){
            story.story_template = .ViewCounterView
            return
        }
        
        if story.storyMetadata?.storyTheme == .Longform || story.storyMetadata?.storyTheme == .Parallax{
            //changing the templet by checking the story metadata attributtes for longform or parallax
            story.story_template = .LongForm
            return
        }
        
        //changing the templet by checking the section for explainer
        if (story.story_template == .Default || story.story_template == .Unknown){
            let sectionNames = story.sections.map({$0.name?.lowercased() ?? ""})
            
            if sectionNames.contains("explainers") ||  sectionNames.contains("deqoded"){
                story.story_template = .Explainer
                return
            }
        }
    }
    
    class func parseTableData(story:Story?){
        for card in story?.cards ?? []{
            card.story_elements = card.story_elements.map({ (cardStoryElement) -> CardStoryElement in
                if cardStoryElement.tableData != nil{
                    if let dataArray = (cardStoryElement.tableData!.content as NSString).csvComponents as? Array<Array<String>>{
                        
                        cardStoryElement.tableData!.parsedData = dataArray
//                        let firstItemRemoved = cardStoryElement.tableData!.parsedData.removeFirst()
//
//                        cardStoryElement.tableData!.parsedData = cardStoryElement.tableData!.parsedData.sorted(by: { (first, second) -> Bool in
//                            return first.first!.compare(second.first!, options: [String.CompareOptions.numeric,String.CompareOptions.forcedOrdering]) == .orderedAscending
//
//                        })
//                        cardStoryElement.tableData!.parsedData.insert(firstItemRemoved, at: 0)
                    }
                }
                
                return cardStoryElement
            })
        }
    }
    
    class func loadTwitterElements(storyDetailLayout:[StoryDetailLayout],success:@escaping ()->()){
        
        var twitterElements = storyDetailLayout.filter({($0.storyElement != nil) && ($0.layoutType == .TwitterCell)})
        
        var tweetIdArray:[String] = []
        
        twitterElements.forEach { (layoutElement) in
            if let tweetId = layoutElement.storyElement?.metadata?.tweet_id{
                tweetIdArray.append(tweetId)
            }
        }
        
        let client = TWTRAPIClient()
        
        DispatchQueue.main.async {
            client.loadTweets(withIDs: tweetIdArray) { (tweetArray, error) in
                
                guard let tweetArrayD = tweetArray else {
                    success()
                    return
                }
                
                for tweet in  tweetArrayD{
                    let tweetId = tweet.tweetID
                    
                    if let tweetIndex = twitterElements.index(where: {$0.storyElement?.metadata?.tweet_id == tweetId}){
                        
//                        let viewModel = StoryViewModel()
//                        viewModel.tweet = tweet
                        twitterElements[tweetIndex].tweet = tweet
                    }
                }
                success()
            }
        }
        
    }
}


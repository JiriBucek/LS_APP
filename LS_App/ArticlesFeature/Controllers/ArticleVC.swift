//
//  ArticleVC.swift
//  LS_App
//
//  Created by Boocha on 03.08.18.
//  Copyright © 2018 Boocha. All rights reserved.
//

import UIKit

class ArticleVC: UIViewController {
    
    @IBOutlet weak var velkyObrazekOutlet: UIImageView!
    
    @IBOutlet weak var nadpisOutlet: UILabel!
    
    @IBOutlet weak var textOutlet: UITextView!
    
    let linkNaWebovouVerzi = """
    Některé funkce, jako např. formuláře pro odesílání přihlášek na workshopy, se nemusí v této aplikaci zobrazovat správně. Pokud Vám něco nefunguje jak má, navštivte prosím {
    NSColor = "kCGColorSpaceModelRGB 0 0 0 1 ";
    NSFont = "<UICTFont: 0x7f94d3f1ceb0> font-family: \"Avenir-BookOblique\"; font-weight: normal; font-style: italic; font-size: 20.00pt";
    NSKern = 0;
    NSParagraphStyle = "Alignment 2, LineSpacing 0, ParagraphSpacing 20, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 28/0, LineHeightMultiple 0, LineBreakMode 0, Tabs (\n), DefaultTabInterval 36, Blocks (\n), Lists (\n), BaseWritingDirection 0, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 0";
    NSStrokeColor = "kCGColorSpaceModelRGB 0 0 0 1 ";
    NSStrokeWidth = 0;
}webovou verzi tohoto článku.{
    NSColor = "kCGColorSpaceModelRGB 0 0 0.933333 1 ";
    NSFont = "<UICTFont: 0x7f94d3f1ceb0> font-family: \"Avenir-BookOblique\"; font-weight: normal; font-style: italic; font-size: 20.00pt";
    NSKern = 0;
    NSLink = "https://www.flickr.com/photos/fontplaydotcom/503736220/in/photolist-LvMef-8THPME-7AJnHE-cBSbWY-at9ygr-VBWT5o-qzs48M-DAqLtw-ScaGPp-33ssxr-T9b3Ho-6T5EpR-69cBpm-7xVCyh-ixtcJ-8fkMt4-JgDcju-bmhXF6-2cgMTq-8RfsXt-7HDU4e-bdyqBt-5ZQS9j-q1RBL1-7QBA17-57BMcy-cBSd6u-bkUW2a-4D46xt-bCLBRt-4zoqL6-91M4dr-6Tndb1-8BoL2P-DAqi9w-6NEoXo-dXZ9X5-o1rv12-dmLgLx-c3Gp8m-49it59-fBGEje-bdz8gH-6fSzXf-b9EtP-69U7sW-26N1cuW-5xfH16-7TnV32-SLZFak";
    NSParagraphStyle = "Alignment 2, LineSpacing 0, ParagraphSpacing 20, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 28/0, LineHeightMultiple 0, LineBreakMode 0, Tabs (\n), DefaultTabInterval 36, Blocks (\n), Lists (\n), BaseWritingDirection 0, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 0";
    NSStrokeColor = "kCGColorSpaceModelRGB 0 0 0.933333 1 ";
    NSStrokeWidth = 0;
    NSUnderline = 1;
}
{
    NSColor = "kCGColorSpaceModelRGB 0 0 0 1 ";
    NSFont = "<UICTFont: 0x7f94d3c07590> font-family: \"Avenir-Book\"; font-weight: normal; font-style: normal; font-size: 20.00pt";
    NSKern = 0;
    NSParagraphStyle = "Alignment 2, LineSpacing 0, ParagraphSpacing 20, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 28/0, LineHeightMultiple 0, LineBreakMode 0, Tabs (\n), DefaultTabInterval 36, Blocks (\n), Lists (\n), BaseWritingDirection 0, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 0";
    NSStrokeColor = "kCGColorSpaceModelRGB 0 0 0 1 ";
    NSStrokeWidth = 0;
}
"""
    
    
    var url: String?

    var velkyObrazekUrl: String? = nil
    var obsahClanku: NSAttributedString? = nil
    var nadpisClanku: String? = nil
    
    override func viewDidLoad() {
        velkyObrazekOutlet.layer.cornerRadius = 15
        velkyObrazekOutlet.clipsToBounds = true
        //kulaté okraje obrázku
        
       if obsahClanku != nil{
            textOutlet.attributedText = obsahClanku
        }
        
        if velkyObrazekUrl != nil{
            
            if let encodedUrl = velkyObrazekUrl?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encodedUrl){
                
                velkyObrazekOutlet.kf.setImage(with: url)
            }
        }else{
            velkyObrazekOutlet.image = #imageLiteral(resourceName: "LS_logo_male")
        }
        
        if nadpisClanku != nil{
       nadpisOutlet.text = nadpisClanku
        }
        
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

//
//  NewsItemTableViewCell.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-11.
//

import UIKit
import Kingfisher

class NewsItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var imgSourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let identifier = "NewsItemTableViewCell"
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: identifier, bundle: bundle)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.needsUpdateConstraints()
        // Initialization code
    }
    
    func configure(with newsItem: NewsItem){
        titleLabel.text = newsItem.titel
        titleLabel.numberOfLines = 0
        titleLabel.font = titleLabel.font.bold()
        titleLabel.textColor = ThemeManager.currentTheme().primaryColor
        summaryLabel.text = cleanupSummaryString(summary: newsItem.summary)
        summaryLabel.numberOfLines = 0
        
        if newsItem.hasImage() {
            let processor = DownsamplingImageProcessor(size: newsImageView.bounds.size)
            let url = URL(string: newsItem.getImageUrl()!)
            newsImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_image_web"), options: [
                .processor(processor),
                .transition(.fade(0.2)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
            newsImageView.contentMode = .scaleAspectFill
        }
        imgSourceLabel.text = newsItem.img_fotograf
        dateLabel.text = newsItem.publicerad
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.kf.cancelDownloadTask()
        newsImageView.image = nil
    }
    
    func cleanupSummaryString(summary: String) -> String {
        let tmp = summary.htmlToAttributedString
        var  result = tmp?.string.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        result = result?.replacingOccurrences(of: "&[a-z]+;", with: " ", options: String.CompareOptions.regularExpression, range: nil)
        return result!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

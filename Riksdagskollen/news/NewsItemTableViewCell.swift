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
        titleLabel.numberOfLines = 0
        titleLabel.font = titleLabel.font.bold()
        summaryLabel.numberOfLines = 0
    }
    
    func configure(with newsItem: NewsDocument){
        titleLabel.text = newsItem.titel
        summaryLabel.text = newsItem.summary.htmlToString

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

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
    }
    
}

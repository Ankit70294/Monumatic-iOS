import UIKit

class DestinationCell: UICollectionViewCell {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        locationLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

#Preview{
    DestinationCell()
}

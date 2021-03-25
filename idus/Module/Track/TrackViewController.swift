//
//  ViewController.swift
//  idus
//
//  Created by jc.kim on 3/23/21.
//

import UIKit
import TagListView
import RxSwift
import RxCocoa

final class TrackViewController: UIViewController {
    
    // MARK: Interface Builder

    @IBOutlet weak var fullScrollView: UIScrollView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var toggleStackView: UIStackView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagView: TagListView!
    
    // MARK: Properties
    
    private let indicatorView = UIActivityIndicatorView(style: .large)
    private let viewModel = TrackViewModel()
    private var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEventBinding()
        setupUIBinding()
    }
    
    // MARK: Setup UI
    
    private func setupUI(){
        sliderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        sliderCollectionView.register(UINib(nibName: SliderCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: SliderCollectionViewCell.reuseIdentifier)
        sliderCollectionView.bounces = false
        
        fullScrollView.bounces = false
        
        releaseNotesLabel.isHidden = true
        
        
        tagView.textFont = UIFont.systemFont(ofSize: 15)
        tagView.textColor = .highlightColor
        tagView.tagBackgroundColor = .white
        tagView.borderColor = .lightGray
        tagView.borderWidth = 1
        tagView.cornerRadius = 5
        
        [fileSizeLabel, releaseNotesLabel].forEach {
            $0?.textColor = .highlightColor
        }
        
        toggleButton.setTitleColor(.highlightColor, for: .normal)
        toggleButton.setTitleColor(.highlightColor, for: .selected)
        
        indicatorView.color = .link
        indicatorView.center = view.center
        
        view.addSubview(indicatorView)
    }
    
    // MARK: - Rx Event Binding

    private func setupEventBinding() {
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Rx UI Binding
    
    private func setupUIBinding() {
        viewModel.track
            .map{($0.screenshotUrls ?? [])}
            .drive(sliderCollectionView.rx.items(cellIdentifier: SliderCollectionViewCell.reuseIdentifier, cellType: SliderCollectionViewCell.self)) { index, item, cell in
                cell.setImage(item)
            }
            .disposed(by: disposeBag)
        
        viewModel.track
            .map{$0.trackName}
            .drive(onNext: { [weak self] t in
                self?.title = t
            })
            .disposed(by: disposeBag)
        
        viewModel.track
            .map{$0.description}
            .drive(onNext: { [weak self] d in
                self?.descriptionLabel.text = d
            })
            .disposed(by: disposeBag)
        
        viewModel.track
            .map{$0.fileSizeBytes}
            .drive(onNext: { [weak self] f in
                self?.fileSizeLabel.text = f.toMegaByte()
            })
            .disposed(by: disposeBag)
        
        viewModel.track
            .map{$0.releaseNotes}
            .drive(onNext: { [weak self] r in
                self?.releaseNotesLabel.text = r
            })
            .disposed(by: disposeBag)
        
        viewModel.track
            .map{$0.genres}
            .drive(onNext: { [weak self] g in
                guard let tags = g else {return}
                self?.tagView.addTags(tags.map{" #\($0) "})
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert
            .drive(onNext: { [weak self] (title, message) in
                self?.showAlert(title: title, message: message)
            }).disposed(by: disposeBag)
        
        viewModel.isNetworking
            .drive(onNext: { [weak self] isNetworking in
                self?.showNetworkingAnimation(isNetworking)
            }).disposed(by: disposeBag)
    }
    
    
    // MARK: Action Handler
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    private func showNetworkingAnimation(_ isNetworking: Bool) {
        if !isNetworking {
            indicatorView.stopAnimating()
        } else  {
            indicatorView.startAnimating()
        }
    }
    
    @IBAction func toggle(_ sender: UIButton) {
        toggleButton.isSelected = !toggleButton.isSelected
        
        UIView.animate(withDuration: 0.3) {
            self.releaseNotesLabel.isHidden = !sender.isSelected
            self.toggleStackView.layoutIfNeeded()
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension TrackViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

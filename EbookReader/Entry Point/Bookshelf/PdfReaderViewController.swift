//
//  PdfReaderViewController.swift
//  EbookReader
//
//  Created by 黄文博 on 2020/4/9.
//  Copyright © 2020 CN. All rights reserved.
//

import UIKit
import PDFKit
import SnapKit

class PdfReaderViewController: UIViewController, PdfOutlineViewControllerDelegate, PdfSearchViewControllerDelegate {
    fileprivate var pdfDocument: PDFDocument!
    fileprivate var pdfView: PDFView!
    fileprivate var toolView: UIView!
    fileprivate var headerView: UIView!
    fileprivate var overlayView: UIView!
    fileprivate var fontView: UIView!

    fileprivate var isStatusBarHidden: Bool = true
    fileprivate var isOverlayHidden: Bool = true
    fileprivate var zoomValue: Float = 5
    fileprivate var bookId: String!

    init(url: URL, bookId: String) {
        super.init(nibName: nil, bundle: nil)
        let document = PDFDocument(url: url)
        self.pdfDocument = document
        self.bookId = bookId
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver (self, selector: #selector(onPageChanged), name: NSNotification.Name.PDFViewPageChanged, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.PDFViewPageChanged, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if keepScreenOnWhileReading {
            UIApplication.shared.isIdleTimerDisabled = true
        }

        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        pdfView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPdfViewTapped)))
        pdfView.document = pdfDocument
        pdfView.usePageViewController(true, withViewOptions: nil)
        pdfView.displayDirection = .horizontal
        pdfView.maxScaleFactor = 4
        pdfView.minScaleFactor = 0.5
        self.view.addSubview(pdfView)
        pdfView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        if let cachePageIndex = prefs.value(forKey: bookId) as? Int, let page = pdfDocument.page(at: cachePageIndex) {
            pdfView.go(to: page)
        }

        headerView = UIView()
        headerView.isHidden = isStatusBarHidden
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(70)
        }

        let closeImageView = UIImageView()
        closeImageView.isUserInteractionEnabled = true
        closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseTapped)))
        closeImageView.image = UIImage(named: "navi-close")
        headerView.addSubview(closeImageView)
        closeImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(headerView).offset(5)
        }

        let outlineImageView = UIImageView()
        outlineImageView.isUserInteractionEnabled = true
        outlineImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOutlineTapped)))
        outlineImageView.image = UIImage(named: "navi-index")
        headerView.addSubview(outlineImageView)
        outlineImageView.snp.makeConstraints { (make) in
            make.left.equalTo(closeImageView.snp.right).offset(15)
            make.centerY.equalTo(headerView).offset(5)
        }

        let searchImageView = UIImageView()
        searchImageView.isUserInteractionEnabled = true
        searchImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSearchTapped)))
        searchImageView.image = UIImage(named: "navi-search")
        headerView.addSubview(searchImageView)
        searchImageView.snp.makeConstraints { (make) in
            make.right.equalTo(headerView).offset(-15)
            make.centerY.equalTo(headerView).offset(5)
        }

        let fontImageView = UIImageView()
        fontImageView.isUserInteractionEnabled = true
        fontImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFontTapped)))
        fontImageView.image = UIImage(named: "navi-font")
        headerView.addSubview(fontImageView)
        fontImageView.snp.makeConstraints { (make) in
            make.right.equalTo(searchImageView.snp.left).offset(-15)
            make.centerY.equalTo(headerView).offset(5)
        }

        overlayView = UIView()
        overlayView.isHidden = isOverlayHidden
        overlayView.isUserInteractionEnabled = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOverlayTapped)))
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.view.addSubview(overlayView)
        overlayView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        fontView = UIView()
        fontView.isHidden = isOverlayHidden
        fontView.backgroundColor = UIColor.white
        self.view.addSubview(fontView)
        fontView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(100)
        }
        let fontSlider = UISlider()
        fontSlider.tintColor = UIColor(red: 0, green: 0.62, blue: 0.63, alpha: 1)
        fontSlider.isContinuous = false
        fontSlider.maximumValue = 10
        fontSlider.value = zoomValue
        fontSlider.minimumValue = 1
        fontSlider.addTarget(self, action: #selector(onSliderChanged(slider:)), for: .valueChanged)
        fontView.addSubview(fontSlider)
        fontSlider.snp.makeConstraints { (make) in
            make.center.equalTo(fontView)
            make.width.equalTo(400)
            make.height.equalTo(40)
        }
        let zoomOutImageView = UIImageView()
        zoomOutImageView.image = UIImage(named: "icon-zoom-out")
        fontView.addSubview(zoomOutImageView)
        zoomOutImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(fontSlider)
            make.right.equalTo(fontSlider.snp.left).offset(-33)
        }
        let zoomInImageView = UIImageView()
        zoomInImageView.image = UIImage(named: "icon-zoom-in")
        fontView.addSubview(zoomInImageView)
        zoomInImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(fontSlider)
            make.left.equalTo(fontSlider.snp.right).offset(33)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.pdfView.autoScales = true
    }

    @objc func onPageChanged() {
        if let currentPage = pdfView.currentPage {
            let currentPageIndex = pdfDocument.index(for: currentPage)
            prefs.set(currentPageIndex, forKey: bookId)
            prefs.synchronize()
        }
    }

    @objc func onDeviceRotated() {
//        switch UIDevice.current.orientation {
//            case .portrait:
//                pdfView.displayMode = .singlePage
//                break
//            case .unknown:
//                pdfView.displayMode = .twoUp
//                break
//            case .portraitUpsideDown:
//                pdfView.displayMode = .singlePage
//                break
//            case .landscapeLeft:
//                pdfView.displayMode = .twoUp
//                break
//            case .landscapeRight:
//                pdfView.displayMode = .twoUp
//                break
//            case .faceUp:
//                pdfView.displayMode = .singlePage
//                break
//            case .faceDown:
//                pdfView.displayMode = .singlePage
//                break
//            @unknown default:
//                pdfView.displayMode = .singlePage
//                break
//            }
    }

    @objc func onSliderChanged(slider: UISlider) {
        let scaleFactor = CGFloat(slider.value / 5) * pdfView.scaleFactorForSizeToFit
        pdfView.scaleFactor = scaleFactor
    }

    @objc func onOverlayTapped() {
        isOverlayHidden = !isOverlayHidden
        overlayView.isHidden = isOverlayHidden
        fontView.isHidden = isOverlayHidden
    }

    @objc func onFontTapped() {
        isOverlayHidden = !isOverlayHidden
        overlayView.isHidden = isOverlayHidden
        fontView.isHidden = isOverlayHidden
    }

    @objc func onPdfViewTapped() {
        self.isStatusBarHidden = !self.isStatusBarHidden
        self.setNeedsStatusBarAppearanceUpdate()
        self.headerView.isHidden = self.isStatusBarHidden
    }

    @objc func onOutlineTapped() {
        let outlineViewController = PdfOutlineViewController(document: pdfDocument, delegate: self)
        self.present(outlineViewController, animated: true, completion: nil)
    }

    @objc func onSearchTapped() {
        let searchViewController = PdfSearchViewController(document: pdfDocument, delegate: self)
        self.present(searchViewController, animated: true, completion: nil)
    }

    @objc func onCloseTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didSelectOutline(_ outline: PDFOutline) {
        if let goToAction = outline.action as? PDFActionGoTo {
            self.pdfView.go(to: goToAction.destination)
        }
    }

    func didSelectSearchResult(_ selection: PDFSelection) {
        self.pdfView.currentSelection = selection
        self.pdfView.go(to: selection)
    }

}

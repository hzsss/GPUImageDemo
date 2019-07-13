//
//  ViewController.swift
//  GPUImageDemo
//
//  Created by 黄子汕 on 2019/7/13.
//  Copyright © 2019 黄子汕. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

  var filterView: RenderView?
  let videoCamera: Camera?
  var filter: BasicOperation?

  var pickerView: UIPickerView?
  var filterArray: Array = ["调整亮度", "调整饱和度", "调整曝光", "调整对比度"]

  required init?(coder aDecoder: NSCoder) {
    do {
      videoCamera = try Camera(sessionPreset:.vga640x480, location:.backFacing)
      videoCamera!.runBenchmark = true
    } catch {
      videoCamera = nil
      print("Couldn't initialize camera with error: \(error)")
    }
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    filterView = RenderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width * 4 / 3))
    view.addSubview(filterView!)

    filter = BrightnessAdjustment()
    if let filter = filter as? BrightnessAdjustment, let videoCamera = videoCamera, let filterView = filterView {
      filter.brightness = 0.3
      videoCamera --> filter --> filterView
      videoCamera.startCapture()
    }

    pickerView = UIPickerView(frame: CGRect(x: 0, y: view.bounds.height - 150, width: view.bounds.width, height: 150))
    pickerView!.delegate = self
    pickerView!.dataSource = self
    view.addSubview(pickerView!)
  }

  override func viewWillDisappear(_ animated: Bool) {
    if let videoCamera = videoCamera {
      videoCamera.stopCapture()
      videoCamera.removeAllTargets()
    }
    super.viewWillDisappear(animated)
  }

  // UIPickerViewDataSource
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return filterArray.count
  }

  // UIPickerViewDelegate
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return filterArray[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch filterArray[row] {
    case "调整亮度":
      videoCamera!.removeAllTargets()
      videoCamera!.stopCapture()
      filter!.removeAllTargets()
      filter = BrightnessAdjustment()
      if let filter = filter as? BrightnessAdjustment, let videoCamera = videoCamera, let filterView = filterView {
        filter.brightness = 0.3
        videoCamera --> filter --> filterView
        videoCamera.startCapture()
      }
    case "调整饱和度":
      videoCamera!.removeAllTargets()
      videoCamera!.stopCapture()
      filter!.removeAllTargets()
      filter = SaturationAdjustment()
      if let filter = filter as? SaturationAdjustment, let videoCamera = videoCamera, let filterView = filterView {
        filter.saturation = 1.5
        videoCamera --> filter --> filterView
        videoCamera.startCapture()
      }
    case "调整曝光":
      videoCamera!.removeAllTargets()
      videoCamera!.stopCapture()
      filter!.removeAllTargets()
      filter = ExposureAdjustment()
      if let filter = filter as? ExposureAdjustment, let videoCamera = videoCamera, let filterView = filterView {
        filter.exposure = 1.5
        videoCamera --> filter --> filterView
        videoCamera.startCapture()
      }

    case "调整对比度":
      videoCamera!.removeAllTargets()
      videoCamera!.stopCapture()
      filter!.removeAllTargets()
      filter = ContrastAdjustment()
      if let filter = filter as? ContrastAdjustment, let videoCamera = videoCamera, let filterView = filterView {
        filter.contrast = 2.5
        videoCamera --> filter --> filterView
        videoCamera.startCapture()
      }
    default:
      print("无滤镜")
    }
  }
}


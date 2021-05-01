//
//  TermsAndConditionViewController.swift
//  ColdmanFresh
//
//  Created by Amit R Mane on 4/24/21.
//

import UIKit

class TermsAndConditionViewController: UIViewController , UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self

////        if scrollView.contentOffset.x>0 {
//            scrollView.contentOffset.x = 0
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

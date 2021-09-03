//
//  MatchViewController.swift
//  HQSportSwift
//
//  Created by jmf-mac on 2021/8/17.
//

import UIKit

class MatchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "比赛"
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    override var tabBarItem: UITabBarItem!{
        get{
            return UITabBarItem(title: "比赛", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        }
        set{
        
        }
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

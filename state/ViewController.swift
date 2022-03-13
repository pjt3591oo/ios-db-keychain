//
//  ViewController.swift
//  state
//
//  Created by 박정태 on 2022/03/13.
//

// UserDefaults는 base64 인코딩되어 plist 파일에 저장하기 때문에 보안상 강력하지 않다.
// 앱이 꺼져도 특정한 값이 저장되길 원하는 경우
// 사용자 설정(로컬 알림 설정 여부)
// 앱이 꺼져도 특정한 값이 저장되지만, 앱기 삭제되면면 같이 사라지길 원하는 경우
// 앱이 삭제될 때 데이터가 유지되길 원한다면, CoreData, KeyChain, NSKeyedArchiever등을 이용
// String key-value 형태이므로 저장가능 한 값은 int, double, float, string, bool, data로 이루어진 array, dictionary만 저장가능
// 키로는 string만 사용가능


import UIKit

class Counter: Encodable, Decodable {
    var count: Int = 0
    func increase() {
        count += 1
    }
    func decrease() {
        count -= 1
    }
}

class ViewController: UIViewController {
    private let storageManager: StorageManager = StorageManager.shared
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(String(UserDefaults.standard.integer(forKey: "count")))
//        label.text = String(UserDefaults.standard.integer(forKey: "count"))
        
        if let count: Counter = storageManager.read() {
            label.text = String(count.count)
        } else {
            let counter: Counter = Counter()
            let _: Bool? = storageManager.create(counter)
        }
    }

    @IBAction func increase(_ sender: Any) {
        if let counter: Counter = storageManager.read() {
            counter.increase()
            label.text = String(counter.count)
            let _: Bool? = storageManager.update(counter)
        } else {
            let counter: Counter = Counter()
            let _: Bool? = storageManager.create(counter)
        }
//        let count: Int = UserDefaults.standard.integer(forKey: "count")
//        UserDefaults.standard.set(count + 1, forKey: "count")
//        print(String(count + 1))
//        label.text = String(count + 1)
    }
    
    @IBAction func decrease(_ sender: Any) {
        if let counter: Counter = storageManager.read() {
            counter.decrease()
            label.text = String(counter.count)
            let _: Bool? = storageManager.update(counter)
        } else {
            let counter: Counter = Counter()
            let _: Bool? = storageManager.create(counter)
        }
//        let count: Int = UserDefaults.standard.integer(forKey: "count")
//        UserDefaults.standard.set(count - 1, forKey: "count")
//            print(String(count - 1))
//        label.text = String(count - 1)
    }
}


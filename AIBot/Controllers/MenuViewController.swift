
import UIKit
import GlitchLabel
import LTMorphingLabel
import TransitionButton

class MenuViewController: UIViewController{
    
    @IBOutlet weak var ai2label: GlitchLabel!
    @IBOutlet weak var ai3label: LTMorphingLabel!
    @IBOutlet weak var signUpButton: TransitionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.isHidden = true
        AnimationForLabel.startAnimation(with: ai3label, label2: ai2label, button1: signUpButton)
        view.backgroundColor = UIColor(hexString: "022032")
        signUpButton.spinnerColor = .systemTeal
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.layer.masksToBounds = true
        signUpButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
   @objc func didTapButton() {
       
           DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [self] in
               signUpButton.startAnimation()
               DispatchQueue.main.asyncAfter(deadline: .now()+3){
                   self.signUpButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 1){
                       self.performSegue(withIdentifier: K.chatSegue, sender: self)
                   }
               }
           }
    }
}

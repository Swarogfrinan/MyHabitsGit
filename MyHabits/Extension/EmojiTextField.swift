import UIKit

class EmojiTextField: UITextField {

       override var textInputContextIdentifier: String? { "" }

        override var textInputMode: UITextInputMode? {
            for mode in UITextInputMode.activeInputModes {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }
            return nil
        }

    override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)

        }

        @objc func inputModeDidChange(_ notification: Notification) {
            guard isFirstResponder else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.reloadInputViews()
            }
        }
    }

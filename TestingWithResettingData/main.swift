//
//  Copyright © 2015 Onefootball GmbH. All rights reserved.
//

import UIKit

#if DEBUG
autoreleasepool {
    if Process.arguments.contains("--ResetData") {
        ApplicationResetManager.reset()
    }
}
#endif

autoreleasepool {
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(AppDelegate))
}

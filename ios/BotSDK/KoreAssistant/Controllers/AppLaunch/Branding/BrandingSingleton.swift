//
//  BrandingSingleton.swift
//  KoreBotSDKDemo
//
//  Created by Kartheek.Pagidimarri on 12/11/20.
//  Copyright © 2020 Kore. All rights reserved.
//

import UIKit

class BrandingSingleton: NSObject {
    
    // MARK: Shared Instance
    static let shared = BrandingSingleton()
    
    // MARK: Local Variable
    var widgetBorderColor: String?
    var widgetTextColor: String?
    var buttonInactiveBgColor: String?
    var buttonInactiveTextColor: String?
    var widgetBgColor: String?
    var botchatTextColor: String?
    var buttonActiveBgColor: String?
    var buttonActiveTextColor: String?
    var userchatBgColor: String?
    var theme: String?
    var botName: String?
    var botchatBgColor: String?
    var userchatTextColor: String?
    var widgetDividerColor: String?
    
    var bankLogo: String?
    var widgetBgImage: String?
    var widgetBodyColor: String?
    var widgetFooterColor: String?
    var widgetHeaderColor: String?
    
    var hamburgerOptions: Dictionary<String, Any>?
    var brandingInfoModel: BrandingModel?
    
    let brandingjsonStr = "[{\"hamburgermenu\":{\"tasks\":[{\"postback\":{\"buttonResponse\":\"Get Balance\",\"title\":\"Get Balance\",\"value\":\"Get Balance\"},\"title\":\"Get Balance\",\"icon\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGKADAAQAAAABAAAAGAAAAADiNXWtAAACfklEQVRIDe1UTWgTURCe2aTREgrFFnoV/xE8KKh4VLABL14E0UPaGNC2uVjaRKH+IHiQJE17SaNozM8hYA5CQfCm4MWLB48F8QdSD0IqxRprm90dZ5a858YUqu61D97O7Mz3ffN25rEAW2uTDqDKp+6XToBFjwnogIr9j0XABfDhpfjI0Gvh+5UI2ZQHRxwXASmp4v9kCRPOAW1gLTgoXF0AiPYjQg3JuDo5Fn66kXA+P98j8Wj07MpG+XS2/JnQmuXcPpU3lCOWxacnY53imWq1O5ktVpZ+fl2WLb7E3FzxW9wMEenW//4CF3o6Wzpvg33Sb8C98dHIJ6v+4yYineP+3hYYt+GWWW98ZHdqJlfYadpw3QDj5URs6IlLxnE7CqTK5aC9YpUIYBsTZY0QwWlAfB4fG74rgeRc8ShXGWR3SsQZe4UPNMzcZ/DdEohebS2SaDwcbjDhFX/jmpzKQSIsItDh2YeVAdniA8ckJxjBCke4Dt716CgguUQsMgg9vj79yX66wwK9zeZaTbb4wDHBOhjGOhwJ/LHaCthAxzOPqjsE4z5N4nLkrREIHOLZ3ZAtvsSUlsIKl/PHVFysngEP8BsP74K13mAQnXGDWn6NbVrFJ6IX2w4n8XSuWGETYq1lhdMF+I4+4MFd44GGUnPF9kkp9N9a0WotfV/lPZUrn0Lb26+CDFyIj4ZfdBSYKRR6cdU/oBJeLHWbX8YjEadNukXmKr4hMnd7EVZcXMX37O+Rd12AfBAyyL9LgbxYG60Piq8LdJlGwATarhJebBcYAcXXBZpozfMt2qsSXmwT4R3znT+qLhDsDx5ZX2r0exFW3EBfsK78LbtpB34BXEr2iByjKJYAAAAASUVORK5CYII=\",\"order\":0},{\"postback\":{\"buttonResponse\":\"Get Transactions\",\"title\":\"Get Transactions\",\"value\":\"Get Transactions\"},\"title\":\"Get Transactions\",\"icon\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGKADAAQAAAABAAAAGAAAAADiNXWtAAADW0lEQVRIDdVVX0hTURj/zr3+YSvNSpNKNIkswoJCqJfARS8tpIzYS7Q2ejCvEFFuJVRYIMW2oohdHAjzD74siuGgpzAhekqiB9EECwahkDNKbebczuk728713s3AHj2w+33n9/079zu/+w1goy8iXuBJKGS6YbMtiT2XoVCoKDq3dAYYvcCAHAFgVYQRHjMNhI0ygPAW+VC4paVhRR+n1yWxScXiQ7yI2Hv9/U3RWHycUfoKGLFi1q8AZBAIDGDySY4Bg9B8amzCpwbPibhcqb2Bxx/Es5E3pfL2swvJH3cp0NsEyBSRSUf1NtOQzWZL6IMDgdHCheR4EwPaxYAdkCTiuXn1cgfmoHo/QwFuQIcZxthObERf8Z7KlmtW67I+IFdPtzEWVzHmCi/S3uq4pffJK5A1TpMSuc5lt//WOz/u7rfSFMiuNntEj3Pdq/b2pIsQaG5XnGFh1+5AAFm5iy3SSCAQMevxFE25GaF39JjQa8rNCrb0M5LBx9sncO0NnqoD+wUopFRKZuSiIhqfjT/Ey23ES93LMAuyKUqIrLha7cPCl0ufv/88hdRL9LC5FecLjhXwB1/XlUuTGc349Pp7n+MlKsiatxiITOKLgAxsMaOvPksKDkbmk2M/8QCcVcYCq25GDbl+HBN+dLc5Thkt+Tv+PXjV4Ds8TIOwam+Al6Qiv0OuVueIMHIpSTBMKXNj4CcsJE69gnQbKa6peJTPMvINwywih1ZAALmyqGbHveXobBwYa0Rb9vLYVkZZZyL6nZPAQEsezwjDF88srYBLcSgC1MvsCe8jxn/a8vh7P1AKJzVAU9LjZEZstQICyJW8dXic3QacwSY851EklKrHOT3xkk9gq18L3FCA876ubnPCYrEkhQNSsxYDavkeB101pyl+5VPYB9VcYe7Q/FDJjA5WhmpY4IYCv5JzPaMTMd6/i8LB1eY4LXSPGhzBMiZs5zGBCZkeGbPxLqz+pVSuX7uAXEg6MYGIyZOyJHv4qMgzIICTF1uJQw+gWT++/51trSxrYOsedrmxz7oH9yXoyoNyE3Pi+pNrX++4NtyBPklSShKgjC5UVmqc9vn7FOR4PTKoirMFW1LGe87bgmM6jD99irT+Xy3Cr/k9sucwRq77LzOv4oYD/gKS3mlHL94cyQAAAABJRU5ErkJggg==\",\"order\":1}],\"heading\":\"How may I help you?\"}},{\"brandingwidgetdesktop\":{\"botName\":\"Kore Bot\",\"widgetBgImage\":\"\",\"bankLogo\":\"\",\"theme\":\"Theme1\",\"botchatBgColor\":\"#F4F4F4\",\"botchatTextColor\":\"#26344A\",\"buttonActiveBgColor\":\"#FFFFFF\",\"buttonActiveTextColor\":\"#26344A\",\"buttonInactiveBgColor\":\"#FFFFFF\",\"buttonInactiveTextColor\":\"#26344A\",\"userchatBgColor\":\"#EFF4FF\",\"userchatTextColor\":\"#26344A\",\"widgetHeaderColor\":\"#6dc148\",\"widgetTextColor\":\"#26344A\",\"widgetBorderColor\":\"#EEEEEE\",\"widgetDividerColor\":\"#E5E8EC\",\"widgetBodyColor\":\"#FFFFFF\",\"widgetFooterColor\":\"#FFFFFF\",\"buttonOutlineColor\":\"#65cd36\"}}]"
}

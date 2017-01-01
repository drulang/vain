//
//  Appearance.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

struct Constants {
    struct Identifiers {
        static let Cell = "com.vain.cell" //TODO: Add domanify func
    }
}


struct Appearance {
    
    struct Font {
        static let Name = "Avenir"
        static let HeadlineFont = UIFont(name: Font.Name, size: 25)
        static let TitleFont = UIFont(name: Font.Name, size: 19)
        static let TitleFontMedium = UIFont(name: Font.Name, size: 26)
        static let SubtitleFont = UIFont(name: Font.Name, size: 17)
        static let SubtitleFontMedium = UIFont(name: Font.Name, size: 24)
        static let HeroFont = UIFont(name: Font.Name, size: 140)
        static let HeroFontSmall = UIFont(name: Font.Name, size: 85)
        static let IconSubtitleFont = UIFont(name: Font.Name, size: 15)
    }
    
    struct Border {
        static let width:CGFloat = 0.5
    }
    
    struct Palette {
        static let Primary = UIColor(hex: 0x7597C6)
        static let Secondary = UIColor.white
        static let Ternary = UIColor(r: 100, g: 109, b: 126)
        static let Accent = UIColor(r: 165, g: 101, b: 101)
        
        static let DarkGray = UIColor.darkGray
        static let MediumGray = UIColor.lightGray
        static let LightGray = UIColor.lightGray
        
        static let Success = UIColor.green
        static let Error = UIColor.red
        static let Info = UIColor.yellow
        
        struct Text {
            static let Primary = UIColor.white
        }
        
        struct WeatherCondition {
            struct Thunderstorm {
                static let Day = UIColor(hex: 0x484F6E)
                static let Night = WeatherCondition.Thunderstorm.Day
            }
            struct Rain {
                static let Day = UIColor(hex: 0x55749F)
                static let Night = Rain.Day
            }
            struct ClearSky {
                static let Day = UIColor(hex: 0xFFCD5B)
                static let Night = UIColor(hex: 0x373C54)
            }
            struct Snow {
                static let Day = UIColor(hex: 0xA4B4C4)
                static let Night = Snow.Day
            }
            struct Clouds {
                static let Day = UIColor(hex: 0x7597C6)
                static let Night = Clouds.Day
            }
            struct Drizzle {
                static let Day = UIColor(hex: 0xC8D9C9)
                static let Night = Drizzle.Day
            }
            struct Atmosphere {
                static let Day = UIColor(hex: 0x9D333C)
                static let Night = Atmosphere.Day
            }
        }
    }
    
    struct Layout {
        static let Margin = CGFloat(8);
    }
    
}

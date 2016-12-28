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
        static let SubtitleFont = UIFont(name: Font.Name, size: 17)
        static let HeroFont = UIFont(name: Font.Name, size: 90)
        static let IconSubtitleFont = UIFont(name: Font.Name, size: 12)
    }
    
    struct Border {
        static let width:CGFloat = 0.5
    }
    
    struct Palette {
        static let Primary = UIColor.white
        static let Secondary = UIColor.darkGray
        static let Ternary = UIColor(r: 100, g: 109, b: 126)
        static let Accent = UIColor(r: 165, g: 101, b: 101)
        static let Success = UIColor.green
        static let Error = UIColor.red
        static let Info = UIColor.yellow
        
        struct Text {
            static let Primary = UIColor.darkGray
        }
        
        struct WeatherCondition {
            struct Thunderstorm {
                static let Day = UIColor.green
                static let Night = UIColor.blue
            }
            struct Rain {
                static let Day = UIColor.green
                static let Night = UIColor.blue
            }
            struct ClearSky {
                static let Day = UIColor.green
                static let Night = UIColor.blue
            }
            struct Snow {
                static let Day = UIColor.green
                static let Night = UIColor.blue
            }
            struct Clouds {
                static let Day = UIColor.green
                static let Night = UIColor.blue
            }
            struct Drizzle {
                static let Day = UIColor.green
                static let Night = UIColor.blue
            }
        }
    }
    
    struct Layout {
        static let Margin = CGFloat(8);
    }
    
}

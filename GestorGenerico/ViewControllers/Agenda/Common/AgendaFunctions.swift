//
//  AgendaFunctions.swift
//  GestorHeme
//
//  Created by jon mikel on 06/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AgendaFunctions: NSObject {
    static func getBeginningOfDayFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 8
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
    
    static func getEndOfDayFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 23
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
    
    static func getBeginingOfYearFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.month = 1
        components.day = 1
        components.hour = 1
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
        
    }
    
    static func getEndOfYearFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.month = 12
        components.day = 31
        components.hour = 23
        components.minute = 00
        components.second = 00
        
        return calendar.date(from: components)!
    }
    
    static func getBeginingOfMonthFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.day = 1
        components.hour = 1
        components.minute = 00
        components.second = 00
        
        return calendar.date(from: components)!
    }
    
    static func getEndOfMonthFromDate(date: Date) -> Date {
        var components: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        components.day = numDays
        components.hour = 23
        components.minute = 00
        components.second = 00
        return Calendar.current.date(from: components)!
    }
    
    static func getHoursAndMinutesFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "es_ES")
        let string = dateFormatter.string(from: date)
        return string
    }
    
    static func getColorForTipoServicio(tipoServicioId: Int64) -> UIColor {
        if tipoServicioId == 0 {
            return .black
        }
        let servicio: TipoServicioModel = Constants.databaseManager.tipoServiciosManager.getTipoServicioFromDatabase(servicioId: tipoServicioId)
        
        if #available(iOS 13.0, *) {
            return UIColor(cgColor: CGColor(srgbRed: CGFloat(servicio.redColorValue/255), green: CGFloat(servicio.greenColorValue/255), blue: CGFloat(servicio.blueColorValue/255), alpha: 1.0))
        } else {
            return UIColor(red: CGFloat(servicio.redColorValue/255), green: CGFloat(servicio.greenColorValue/255), blue: CGFloat(servicio.blueColorValue/255), alpha: 1.0)
        }
    }
    
    static func add30MinutesToDate(date: Date) -> Date {
        return Calendar.current.date(byAdding: .minute, value: 30, to: date)!
    }
    
    static func getMonthNameFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "es_ES")
        return dateFormatter.string(from: date)
    }
    
    static func getCurrentWeekDayNameFromWeekDay(weekDay:Int) -> String {
        switch weekDay {
        case 2:
            return "Lun"
        case 3:
            return "Mar"
        case 4:
            return "Mier"
        case 5:
            return "Jue"
        case 6:
            return "Vie"
        case 7:
            return "Sab"
        default:
            return "Dom"
        }
    }
    
    static func getWeekDayFromDate(date: Date) -> Int {
         return Calendar.current.component(.weekday, from: date)
     }
    
    static func getNumberOfDaysBetweenDates(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date1, to: date2).day!
    }
    
    static func getMonthNumberFromDate(date: Date) -> Int {
        return Calendar.current.component(.month, from: date)
    }
    
    static func getYearNumberFromDate(date: Date) -> Int {
        return Calendar.current.component(.year, from: date)
    }
}

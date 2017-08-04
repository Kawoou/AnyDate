import Foundation

final public class LocalDateTime {
    
    // MARK: - Static
    
    /// The minimum supported LocalDateTime, '-999999999-01-01T00:00:00'.
    public static var min: LocalDateTime {
        return LocalDateTime(date: LocalDate.min, time: LocalTime.min)
    }
    
    /// The maximum supported LocalDateTime, '+999999999-12-31T23:59:59.999999999'.
    public static var max: LocalDateTime {
        return LocalDateTime(date: LocalDate.max, time: LocalTime.max)
    }
    
    /// Obtains an instance of LocalDateTime from a text string such as '2007-12-03T10:15:30.217'.
    public static func parse(_ text: String, clock: Clock) -> LocalDateTime? {
        return LocalDateTime.parse(text, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, timeZone: TimeZone = TimeZone.current) -> LocalDateTime? {
        /// ISO8601 format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return LocalDateTime.parse(text, formatter: formatter, timeZone: timeZone)
    }
    
    /// Obtains an instance of LocalDateTime from a text string using a specific formatter.
    public static func parse(_ text: String, formatter: DateFormatter, clock: Clock) -> LocalDateTime? {
        return LocalDateTime.parse(text, formatter: formatter, timeZone: clock.toTimeZone())
    }
    public static func parse(_ text: String, formatter: DateFormatter, timeZone: TimeZone = TimeZone.current) -> LocalDateTime? {
        guard let date = formatter.date(from: text) else { return nil }
        formatter.timeZone = timeZone
        
        return LocalDateTime(date)
    }
    
    
    // MARK: - Property
    
    /// The date part.
    public var date: LocalDate {
        get { self.normalize(); return self.internalDate }
        set { self.normalize(); self.internalDate = newValue }
    }
    
    /// The time part.
    public var time: LocalTime {
        get { self.normalize(); return self.internalTime }
        set { self.normalize(); self.internalTime = newValue }
    }
    
    /// Gets the year field.
    public var year: Int {
        get { self.normalize(); return self.internalDate.year }
        set { self.normalize(); self.internalDate.year = newValue }
    }
    
    /// Gets the month-of-year field from 1 to 12.
    public var month: Int {
        get { self.normalize(); return self.internalDate.month }
        set { self.normalize(); self.internalDate.month = newValue }
    }
    
    /// Gets the day-of-month field.
    public var day: Int {
        get { self.normalize(); return self.internalDate.day }
        set { self.normalize(); self.internalDate.day = newValue }
    }
    
    /// Gets the day-of-week field.
    public var dayOfWeek: Int { self.normalize(); return self.internalDate.dayOfWeek }
    
    /// Gets the hour-of-day field.
    public var hour: Int {
        get { self.normalize(); return self.internalTime.hour }
        set { self.normalize(); self.internalTime.hour = newValue }
    }
    
    /// Gets the minute-of-hour field.
    public var minute: Int {
        get { self.normalize(); return self.internalTime.minute }
        set { self.normalize(); self.internalTime.minute = newValue }
    }
    
    /// Gets the second-of-minute field.
    public var second: Int {
        get { self.normalize(); return self.internalTime.second }
        set { self.normalize(); self.internalTime.second = newValue }
    }
    
    /// Gets the nano-of-second field.
    public var nano: Int {
        get { self.normalize(); return self.internalTime.nano }
        set { self.normalize(); self.internalTime.nano = newValue }
    }
    
    
    // MARK: - Private
    
    fileprivate var internalDate: LocalDate
    fileprivate var internalTime: LocalTime
    
    fileprivate func normalize() {
        if self.internalTime.hour >= LocalTime.Constant.hoursPerDay {
            self.internalDate.day += (self.internalTime.hour / LocalTime.Constant.hoursPerDay)
            self.internalTime.hour %= LocalTime.Constant.hoursPerDay
        }
    }
    
    
    // MARK: - Public
    
    /// Returns the length of the month represented by this date.
    public func lengthOfMonth() -> Int {
        self.normalize()
        return self.internalDate.lengthOfMonth()
    }
    
    /// Returns the length of the year represented by this date.
    public func lengthOfYear() -> Int {
        self.normalize()
        return self.internalDate.lengthOfYear()
    }
    
    /// Checks if the year is a leap year, according to the ISO proleptic
    /// calendar system rules.
    public func isLeapYear() -> Bool {
        self.normalize()
        return self.internalDate.isLeapYear()
    }
    
    /// Returns an instance of Date.
    public func toDate(clock: Clock) -> Date {
        return self.toDate(timeZone: clock.toTimeZone())
    }
    public func toDate(timeZone: TimeZone = TimeZone.current) -> Date {
        self.normalize()
        
        /// Specify date components
        var dateComponents = DateComponents()
        dateComponents.timeZone = timeZone
        dateComponents.year = self.internalDate.year
        dateComponents.month = self.internalDate.month
        dateComponents.day = self.internalDate.day
        dateComponents.hour = self.internalTime.hour
        dateComponents.minute = self.internalTime.minute
        dateComponents.second = self.internalTime.second
        dateComponents.nanosecond = self.internalTime.nano
        
        /// Create date from components
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let date = calendar.date(from: dateComponents)
        assert(date != nil, "Failed to convert Date from LocalDateTime.")
        
        return date!
    }
    
    /// Returns a copy of this date-time with the specified field set to a new value.
    public func with(component: Calendar.Component, newValue: Int) -> LocalDateTime {
        self.normalize()
        
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return LocalDateTime(
                date: self.internalDate,
                time: self.internalTime.with(component: component, newValue: newValue)
            )
            
        default:
            return LocalDateTime(
                date: self.internalDate.with(component: component, newValue: newValue),
                time: self.internalTime
            )
        }
    }
    
    /// Returns a copy of this LocalDateTime with the year altered.
    public func with(year: Int) -> LocalDateTime {
        return self.with(component: .year, newValue: year)
    }
    
    /// Returns a copy of this LocalDateTime with the month-of-year altered.
    public func with(month: Int) -> LocalDateTime {
        return self.with(component: .month, newValue: month)
    }
    
    /// Returns a copy of this LocalDateTime with the day-of-month altered.
    public func with(day: Int) -> LocalDateTime {
        return self.with(component: .day, newValue: day)
    }
    
    /// Returns a copy of this LocalDateTime with the hour-of-day value altered.
    public func with(hour: Int) -> LocalDateTime {
        return self.with(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this LocalDateTime with the minute-of-hour value altered.
    public func with(minute: Int) -> LocalDateTime {
        return self.with(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this LocalDateTime with the second-of-minute value altered.
    public func with(second: Int) -> LocalDateTime {
        return self.with(component: .second, newValue: second)
    }
    
    /// Returns a copy of this LocalDateTime with the nano-of-second value altered.
    public func with(nano: Int) -> LocalDateTime {
        return self.with(component: .nanosecond, newValue: nano)
    }
    
    /// Returns a copy of this date-time with the specified amount added.
    public func plus(component: Calendar.Component, newValue: Int) -> LocalDateTime {
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return LocalDateTime(
                date: self.internalDate,
                time: self.internalTime.plus(component: component, newValue: newValue)
            )
            
        default:
            return LocalDateTime(
                date: self.internalDate.plus(component: component, newValue: newValue),
                time: self.internalTime
            )
        }
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in years added.
    public func plus(year: Int) -> LocalDateTime {
        return self.plus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in months added.
    public func plus(month: Int) -> LocalDateTime {
        return self.plus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in weeks added.
    public func plus(week: Int) -> LocalDateTime {
        return self.plus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in days added.
    public func plus(day: Int) -> LocalDateTime {
        return self.plus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in hours added.
    public func plus(hour: Int) -> LocalDateTime {
        return self.plus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in minutes added.
    public func plus(minute: Int) -> LocalDateTime {
        return self.plus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in seconds added.
    public func plus(second: Int) -> LocalDateTime {
        return self.plus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in nanoseconds added.
    public func plus(nano: Int) -> LocalDateTime {
        return self.plus(component: .nanosecond, newValue: nano)
    }
    
    /// Returns a copy of this date-time with the specified amount subtracted.
    public func minus(component: Calendar.Component, newValue: Int) -> LocalDateTime {
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return LocalDateTime(
                date: self.internalDate,
                time: self.internalTime.minus(component: component, newValue: newValue)
            )
            
        default:
            return LocalDateTime(
                date: self.internalDate.minus(component: component, newValue: newValue),
                time: self.internalTime
            )
        }
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in years subtracted.
    public func minus(year: Int) -> LocalDateTime {
        return self.minus(component: .year, newValue: year)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in months subtracted.
    public func minus(month: Int) -> LocalDateTime {
        return self.minus(component: .month, newValue: month)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in weeks subtracted.
    public func minus(week: Int) -> LocalDateTime {
        return self.minus(component: .weekday, newValue: week)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in days subtracted.
    public func minus(day: Int) -> LocalDateTime {
        return self.minus(component: .day, newValue: day)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in hours subtracted.
    public func minus(hour: Int) -> LocalDateTime {
        return self.minus(component: .hour, newValue: hour)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in minutes subtracted.
    public func minus(minute: Int) -> LocalDateTime {
        return self.minus(component: .minute, newValue: minute)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in seconds subtracted.
    public func minus(second: Int) -> LocalDateTime {
        return self.minus(component: .second, newValue: second)
    }
    
    /// Returns a copy of this LocalDateTime with the specified period in nanoseconds subtracted.
    public func minus(nano: Int) -> LocalDateTime {
        return self.minus(component: .nanosecond, newValue: nano)
    }
    
    /// Gets the range of valid values for the specified field.
    public func range(_ component: Calendar.Component) -> (Int, Int) {
        self.normalize()
        
        switch component {
        case .hour, .minute, .second, .nanosecond:
            return self.internalTime.range(component)
            
        default:
            return self.internalDate.range(component)
        }
    }
    
    /// Calculates the amount of time until another date-time in terms of the specified unit.
    public func until(endDateTime: LocalDateTime, component: Calendar.Component) -> Int64 {
        self.normalize()
        endDateTime.normalize()
        
        switch component {
        case .nanosecond, .second, .minute, .hour:
            let timePart = self.internalTime.until(endTime: endDateTime.internalTime, component: component)
            
            var amount = self.internalDate.until(endDate: endDateTime.internalDate, component: .day)
            guard amount != 0 else { return timePart }

            switch component {
            case .nanosecond:
                amount = amount * LocalTime.Constant.nanosPerDay
                
            case .second:
                amount = amount * Int64(LocalTime.Constant.secondsPerDay)
                
            case .minute:
                amount = amount * Int64(LocalTime.Constant.minutesPerDay)
                
            case .hour:
                amount = amount * Int64(LocalTime.Constant.hoursPerDay)
                
            default: break
            }
            return amount + timePart
            
        default:
            var endDate = endDateTime.internalDate
            if endDate < self.internalDate && endDateTime.internalTime < internalTime {
                endDate = endDate.minus(day: 1)
            } else if endDate > self.internalDate && endDateTime.internalTime > internalTime {
                endDate = endDate.plus(day: 1)
            }
            return self.internalDate.until(endDate: endDate, component: component)
        }
    }
    
    /// Formats this date-time using the specified formatter.
    public func format(_ formatter: DateFormatter) -> String {
        let date = self.toDate()
        return formatter.string(from: date)
    }
    
    
    // MARK: - Lifecycle
    
    /// Creates the current date-time from the system clock in the default time-zone.
    public init() {
        let now = Date()
        
        self.internalDate = LocalDate(now)
        self.internalTime = LocalTime(now)
    }
    
    /// Creates a local date-time from an instance of Date.
    public convenience init(_ date: Date, clock: Clock) {
        self.init(date, timeZone: clock.toTimeZone())
    }
    public init(_ date: Date, timeZone: TimeZone = TimeZone.current) {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        self.internalDate = LocalDate(
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date),
            day: calendar.component(.day, from: date)
        )
        self.internalTime = LocalTime(
            hour: calendar.component(.hour, from: date),
            minute: calendar.component(.minute, from: date),
            second: calendar.component(.second, from: date),
            nanoOfSecond: calendar.component(.nanosecond, from: date)
        )
    }
    
    /// Copies an instance of LocalDateTime.
    public init(_ date: LocalDateTime) {
        self.internalDate = LocalDate(date.date)
        self.internalTime = LocalTime(date.time)
    }
    
    /// Returns a copy of this date-time with the new date and time, checking
    /// to see if a new object is in fact required.
    public init(date: LocalDate, time: LocalTime) {
        self.internalDate = LocalDate(date)
        self.internalTime = LocalTime(time)
    }
    
    /// Creates an instance of LocalDateTime from year, month,
    /// day, hour, minute, second and nanosecond.
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0, nanoOfSecond: Int = 0) {
        self.internalDate = LocalDate(year: year, month: month, day: day)
        self.internalTime = LocalTime(hour: hour, minute: minute, second: second, nanoOfSecond: nanoOfSecond)
    }
    
    /// Creates an instance of LocalDateTime using seconds from the
    /// epoch of 1970-01-01T00:00:00Z.
    public init(epochDay: Int64, nanoOfDay: Int) {
        self.internalDate = LocalDate(epochDay: epochDay)
        self.internalTime = LocalTime(nanoOfDay: nanoOfDay)
    }
    
}

extension LocalDateTime: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    public static func <(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        lhs.normalize()
        rhs.normalize()
        
        if lhs.internalDate < rhs.internalDate { return true }
        if lhs.internalTime < rhs.internalTime { return true }
        return false
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    public static func >(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        lhs.normalize()
        rhs.normalize()
        
        if lhs.internalDate > rhs.internalDate { return true }
        if lhs.internalTime > rhs.internalTime { return true }
        return false
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    public static func <=(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        return !(lhs > rhs)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    public static func >=(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        return !(lhs < rhs)
    }
    
}
extension LocalDateTime: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func ==(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        lhs.normalize()
        rhs.normalize()
        
        return lhs.internalDate == rhs.internalDate && lhs.internalTime == rhs.internalTime
    }
    
}
extension LocalDateTime: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        self.normalize()
        return self.internalDate.description + "T" + self.internalTime.description
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return self.internalDate.debugDescription + "T" + self.internalTime.debugDescription
    }
    
}

// MARK: - Operator

/// LocalDateTime
public func + (lhs: LocalDateTime, rhs: LocalDateTime) -> LocalDateTime {
    return LocalDateTime(
        date: lhs.internalDate + rhs.internalDate,
        time: lhs.internalTime + rhs.internalTime
    )
}
public func += (lhs: inout LocalDateTime, rhs: LocalDateTime) {
    lhs.internalDate += rhs.internalDate
    lhs.internalTime += rhs.internalTime
}
public func - (lhs: LocalDateTime, rhs: LocalDateTime) -> LocalDateTime {
    return LocalDateTime(
        date: lhs.internalDate - rhs.internalDate,
        time: lhs.internalTime - rhs.internalTime
    )
}
public func -= (lhs: inout LocalDateTime, rhs: LocalDateTime) {
    lhs.internalDate -= rhs.internalDate
    lhs.internalTime -= rhs.internalTime
}

/// LocalDate
public func + (lhs: LocalDateTime, rhs: LocalDate) -> LocalDateTime {
    return LocalDateTime(
        date: lhs.internalDate + rhs,
        time: lhs.internalTime
    )
}
public func += (lhs: inout LocalDateTime, rhs: LocalDate) {
    lhs.internalDate += rhs
}
public func - (lhs: LocalDateTime, rhs: LocalDate) -> LocalDateTime {
    return LocalDateTime(
        date: lhs.internalDate - rhs,
        time: lhs.internalTime
    )
}
public func -= (lhs: inout LocalDateTime, rhs: LocalDate) {
    lhs.internalDate -= rhs
}

/// LocalTime
public func + (lhs: LocalDateTime, rhs: LocalTime) -> LocalDateTime {
    return LocalDateTime(
        date: lhs.internalDate,
        time: lhs.internalTime + rhs
    )
}
public func += (lhs: inout LocalDateTime, rhs: LocalTime) {
    lhs.internalTime += rhs
}
public func - (lhs: LocalDateTime, rhs: LocalTime) -> LocalDateTime {
    return LocalDateTime(
        date: lhs.internalDate,
        time: lhs.internalTime - rhs
    )
}
public func -= (lhs: inout LocalDateTime, rhs: LocalTime) {
    lhs.internalTime -= rhs
}

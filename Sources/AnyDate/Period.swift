public struct Period {

    // MARK: - Property

    public var year: Int {
        get { return self.internalYear }
        set { self.internalYear = newValue; self.normalize() }
    }
    public var month: Int {
        get { return self.internalMonth }
        set { self.internalMonth = newValue; self.normalize() }
    }
    public var day: Int {
        get { return self.internalDay }
        set { self.internalDay = newValue; self.normalize() }
    }
    public var hour: Int {
        get { return self.internalHour }
        set { self.internalHour = newValue; self.normalize() }
    }
    public var minute: Int {
        get { return self.internalMinute }
        set { self.internalMinute = newValue; self.normalize() }
    }
    public var second: Int {
        get { return self.internalSecond }
        set { self.internalSecond = newValue; self.normalize() }
    }
    public var nano: Int {
        get { return self.internalNano }
        set { self.internalNano = newValue; self.normalize() }
    }

    // MARK: - Private

    private var internalYear: Int
    private var internalMonth: Int
    private var internalDay: Int
    private var internalHour: Int
    private var internalMinute: Int
    private var internalSecond: Int
    private var internalNano: Int

    private mutating func normalize() {
        let year = self.internalYear
        let month = self.internalMonth
        let day = self.internalDay
        let hour = self.internalHour
        let minute = self.internalMinute
        let second = self.internalSecond
        let nano = self.internalNano

        self.internalNano = Int(nano)

        self.internalSecond = self.internalNano / Int(LocalTime.Constant.nanosPerSecond) + second
        self.internalNano %= Int(LocalTime.Constant.nanosPerSecond)

        self.internalMinute = self.internalSecond / LocalTime.Constant.secondsPerMinute + minute
        self.internalSecond %= LocalTime.Constant.secondsPerMinute

        self.internalHour = self.internalMinute / LocalTime.Constant.minutesPerHour + hour
        self.internalMinute %= LocalTime.Constant.minutesPerHour

        let days = self.internalHour / LocalTime.Constant.hoursPerDay + day
        self.internalHour %= LocalTime.Constant.hoursPerDay

        var newDate = LocalDate(year: year, month: month + 1, day: days + 1)
        self.internalYear = newDate.year
        self.internalMonth = newDate.month - 1
        self.internalDay = newDate.day - 1
    }

    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nano: Int) {
        self.internalYear = year
        self.internalMonth = month
        self.internalDay = day
        self.internalHour = hour
        self.internalMinute = minute
        self.internalSecond = second
        self.internalNano = nano
        self.normalize()
    }
}

/// Period
public func + (lhs: Period, rhs: Period) -> Period {
    return Period(
        year: lhs.year + rhs.year,
        month: lhs.month + rhs.month,
        day: lhs.day + rhs.day,
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second,
        nano: lhs.nano + rhs.nano
    )
}
public func += (lhs: inout Period, rhs: Period) {
    lhs.year += rhs.year
    lhs.month += rhs.month
    lhs.day += rhs.day
    lhs.hour += rhs.hour
    lhs.minute += rhs.minute
    lhs.second += rhs.second
    lhs.nano += rhs.nano
}
public func - (lhs: Period, rhs: Period) -> Period {
    return Period(
        year: lhs.year - rhs.year,
        month: lhs.month - rhs.month,
        day: lhs.day - rhs.day,
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second,
        nano: lhs.nano - rhs.nano
    )
}
public func -= (lhs: inout Period, rhs: Period) {
    lhs.year -= rhs.year
    lhs.month -= rhs.month
    lhs.day -= rhs.day
    lhs.hour -= rhs.hour
    lhs.minute -= rhs.minute
    lhs.second -= rhs.second
    lhs.nano -= rhs.nano
}

/// LocalDateTime
public func + (lhs: LocalDateTime, rhs: Period) -> LocalDateTime {
    return LocalDateTime(
        year: lhs.year + rhs.year,
        month: lhs.month + rhs.month,
        day: lhs.day + rhs.day,
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second,
        nanoOfSecond: lhs.nano + rhs.nano
    )
}
public func += (lhs: inout LocalDateTime, rhs: Period) {
    lhs.year += rhs.year
    lhs.month += rhs.month
    lhs.day += rhs.day
    lhs.hour += rhs.hour
    lhs.minute += rhs.minute
    lhs.second += rhs.second
    lhs.nano += rhs.nano
}
public func - (lhs: LocalDateTime, rhs: Period) -> LocalDateTime {
    return LocalDateTime(
        year: lhs.year - rhs.year,
        month: lhs.month - rhs.month,
        day: lhs.day - rhs.day,
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second,
        nanoOfSecond: lhs.nano - rhs.nano
    )
}
public func -= (lhs: inout LocalDateTime, rhs: Period) {
    lhs.year -= rhs.year
    lhs.month -= rhs.month
    lhs.day -= rhs.day
    lhs.hour -= rhs.hour
    lhs.minute -= rhs.minute
    lhs.second -= rhs.second
    lhs.nano -= rhs.nano
}

/// ZonedDateTime
public func + (lhs: ZonedDateTime, rhs: Period) -> ZonedDateTime {
    return ZonedDateTime(
        year: lhs.year + rhs.year,
        month: lhs.month + rhs.month,
        day: lhs.day + rhs.day,
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second,
        nanoOfSecond: lhs.nano + rhs.nano,
        clock: lhs.clock
    )
}
public func += (lhs: inout ZonedDateTime, rhs: Period) {
    lhs.year += rhs.year
    lhs.month += rhs.month
    lhs.day += rhs.day
    lhs.hour += rhs.hour
    lhs.minute += rhs.minute
    lhs.second += rhs.second
    lhs.nano += rhs.nano
}
public func - (lhs: ZonedDateTime, rhs: Period) -> ZonedDateTime {
    return ZonedDateTime(
        year: lhs.year - rhs.year,
        month: lhs.month - rhs.month,
        day: lhs.day - rhs.day,
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second,
        nanoOfSecond: lhs.nano - rhs.nano,
        clock: lhs.clock
    )
}
public func -= (lhs: inout ZonedDateTime, rhs: Period) {
    lhs.year -= rhs.year
    lhs.month -= rhs.month
    lhs.day -= rhs.day
    lhs.hour -= rhs.hour
    lhs.minute -= rhs.minute
    lhs.second -= rhs.second
    lhs.nano -= rhs.nano
}
% Define the working days as a list of days of the week
working_days([monday, tuesday, wednesday, thursday, friday]).

% Define the number of days in each month
days_in_month(1, 31).    % January
days_in_month(2, 28).    % February
days_in_month(3, 31).    % March
days_in_month(4, 30).    % April
days_in_month(5, 31).    % May
days_in_month(6, 30).    % June
days_in_month(7, 31).    % July
days_in_month(8, 31).    % August
days_in_month(9, 30).    % September
days_in_month(10, 31).   % October
days_in_month(11, 30).   % November
days_in_month(12, 31).   % December

% Define the day following the current day
next_day(monday, tuesday).
next_day(tuesday, wednesday).
next_day(wednesday, thursday).
next_day(thursday, friday).
next_day(friday, saturday).
next_day(saturday, sunday).
next_day(sunday, monday).

% Define first day of the year 2023
first_day(monday).

% Predicate to parse the input day and month
parse_date(DDMM, Date, Month) :-
    atom_chars(DDMM, [D1, D2, M1, M2]),
    atom_number(D1, Date1),
    atom_number(D2, Date2),
    atom_number(M1, Month1),
    atom_number(M2, Month2),
    Date is Date1 * 10 + Date2,
    Month is Month1 * 10 + Month2.
% Predicate to calculate the day and date after N working days
n_work_days(DDMM, N, NextDay, NextDate) :-
    parse_date(DDMM, Date, Month),     % Parse the input date and month
    days_in_month(Month, Days),        % Get the number of days in the given month
    first_day(FirstDay),               % Get the first day of the year
    add_days(Date, Month, Days, FirstDay, N, NextDate, NextMonth),  % Add N days to the start date
    next_day_of_week(FirstDay, NextDay, NextDate, NextMonth).

% Predicate to add N days to the start date and calculate the resulting date
add_days(Date, Month, Days, CurrentDay, N, NextDate, NextMonth) :-
    N > 0,
    NextDate is Date + 1,          % Increment the date by one
    NextDate =< Days,              % Make sure the resulting date is within the month
    add_days(NextDate, Month, Days, CurrentDay, N - 1, NextDate, NextMonth).

add_days(Date, Month, Days, CurrentDay, N, NextDate, NextMonth) :-
    N > 0,
    NextDate is 1,                 % Move to the next month
    NextMonth is Month + 1,
    NextMonth =< 12,               % Make sure the resulting month is within the year
    days_in_month(NextMonth, NextDays),  % Get the number of days in the next month
    add_days(NextDate, NextMonth, NextDays, CurrentDay, N - 1, NextDate, NextMonth).

add_days(Date, Month, Days, CurrentDay, N, NextDate, NextMonth) :-
    N > 0,
    NextDate is 1,                 % Move to the next month
    NextMonth is 1,                % Move to the next year
    days_in_month(NextMonth, NextDays),  % Get the number of days in the next month
    add_days(NextDate, NextMonth, NextDays, CurrentDay, N - 1, NextDate, NextMonth).

% Predicate to calculate the day of the week after N days
next_day_of_week(CurrentDay, NextDay, NextDate, NextMonth) :-
    working_days(WeekDays),             % Get the list of working days
    next_day(CurrentDay, NextDay),      % Get the next day of the week
    add_days(NextDate, NextMonth, _, NextDay, 0, _, _),  % Check if the resulting date falls on a working day
    member(NextDay, WeekDays).           % Check if the next day is a working day

% Predicate to convert the day and date to the desired output format
format_output(Day, Date, Output) :-
    atom_number(DayAtom, Day),
    atom_number(DateAtom, Date),
    atom_concat(DayAtom, ', ', Temp),
    atom_concat(Temp, DateAtom, Output).

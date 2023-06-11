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

% Predicate to calculate the day and date after N working days
n_work_days(StartDay, N, NextDay, NextDate) :-
    parse_date(StartDay, Day, Month),  % Parse the input day and month
    working_days(WeekDays),            % Get the list of working days
    days_in_month(Month, Days),        % Get the number of days in the given month
    NextDate is N + 1,                 % Add N days to the start date
    NextDate =< Days,                  % Make sure the resulting date is within the month
    add_working_days(Day, NextDate, WeekDays, N, NextDay).

% Predicate to parse the input day and month
parse_date(Date, Day, Month) :-
    atom_chars(Date, [D1, D2, M1, M2]),
    atom_number(D1, Day1),
    atom_number(D2, Day2),
    atom_number(M1, Month1),
    atom_number(M2, Month2),
    Day is Day1 * 10 + Day2,
    Month is Month1 * 10 + Month2.

% Predicate to add N working days to the start day and calculate the resulting day
add_working_days(Day, Date, _, 0, Day) :-
    Date mod 7 =:= 0.  % Reached the desired number of working days

add_working_days(Day, Date, WeekDays, N, NextDay) :-
    N > 0,
    NewDate is Date + 1,  % Increment the date by one
    member(NextDay, WeekDays),   % Check if the next day is a working day
    add_working_days(NextDay, NewDate, WeekDays, N - 1, NextDay).

% Predicate to convert the day and date to the desired output format
format_output(Day, Date, Output) :-
    atom_number(DayAtom, Day),
    atom_number(DateAtom, Date),
    atom_concat(DayAtom, ', ', Temp),
    atom_concat(Temp, DateAtom, Output).

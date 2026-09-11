valid_period(262, '2026-2').
valid_period(271, '2027-1').
valid_period(272, '2027-2').
valid_period(281, '2028-1').
valid_period(282, '2028-2').
valid_period(291, '2029-1').
valid_period(292, '2029-2').
code_format(Code) :-
    integer(Code),
    Code >= 10000000,
    Code =< 99999999.
decompose_code(Code, PeriodDigits, CategoryDigits, ConsecutiveDigits) :-
    code_format(Code),
    PeriodDigits is Code // 100000,
    Rest is Code mod 100000,
    CategoryDigits is Rest // 1000,
    ConsecutiveDigits is Rest mod 1000.
divisor(N, D) :-
    N1 is N - 1,
    between(1, N1, D),
    N mod D =:= 0.
proper_divisors(N, Divisors) :-
    findall(D, divisor(N, D), Divisors).
aliquot_sum(N, Sum) :-
    proper_divisors(N, Divisors),
    sum_list(Divisors, Sum).
abundant(N)  :- aliquot_sum(N, Sum), Sum > N.
perfect(N)   :- aliquot_sum(N, Sum), Sum =:= N.
deficient(N) :- aliquot_sum(N, Sum), Sum < N.
category_type(N, 'Administrative') :- abundant(N).
category_type(N, 'Engineering')    :- perfect(N).
category_type(N, 'Humanities')     :- deficient(N).
parity(Code, even) :- 0 is Code mod 2.
parity(Code, odd)  :- 1 is Code mod 2.
card_code(Code, Description) :-
    decompose_code(Code, PeriodDigits, CategoryDigits, ConsecutiveDigits),
    valid_period(PeriodDigits, PeriodStr),
    category_type(CategoryDigits, CategoryStr),
    parity(Code, ParityAtom),
    format(atom(NumStr), 'num~w', [ConsecutiveDigits]),
    format(atom(Description), '~w ~w ~w ~w',
           [PeriodStr, CategoryStr, NumStr, ParityAtom]).
generate_code(PeriodDigits, CategoryName, Code) :-
    valid_period(PeriodDigits, _),
    between(1, 99, CategoryDigits),
    category_type(CategoryDigits, CategoryName),
    between(1, 999, ConsecutiveDigits),
    Code is PeriodDigits * 100000 + CategoryDigits * 1000 + ConsecutiveDigits.
all_generated_codes(PeriodDigits, CategoryName, Codes) :-
    findall(Code, generate_code(PeriodDigits, CategoryName, Code), Codes).
demo :-
    nl, writeln('--- Query mode: obtain the description of a code ---'),
    forall(
        member(Code, [26276002, 27128112, 27206025, 28124236, 28299115]),
        ( card_code(Code, Description)
        -> format('~w -> ~w~n', [Code, Description])
        ;  format('~w -> REJECTED (invalid code)~n', [Code])
        )
    ),
    nl, writeln('--- Verify mode: does this description match the code? ---'),
    ( card_code(26276002, '2026-2 Humanities num2 even')
    -> writeln('26276002 / "2026-2 Humanities num2 even" -> MATCH')
    ;  writeln('26276002 / "2026-2 Humanities num2 even" -> NO MATCH')
    ),
    ( card_code(26276002, '2026-2 Engineering num2 even')
    -> writeln('26276002 / "2026-2 Engineering num2 even" -> MATCH')
    ;  writeln('26276002 / "2026-2 Engineering num2 even" -> NO MATCH')
    ),
    nl, writeln('--- Rejecting invalid codes ---'),
    ( card_code(2627600, _)
    -> writeln('2627600 -> accepted (unexpected)')
    ;  writeln('2627600 (7 digits) -> REJECTED, as expected')
    ),
    ( card_code(25276002, _)
    -> writeln('25276002 -> accepted (unexpected)')
    ;  writeln('25276002 (period 2025-2, out of range) -> REJECTED, as expected')
    ),
    nl, writeln('--- Generate mode: all 2029-2 Engineering codes ---'),
    all_generated_codes(292, 'Engineering', Codes),
    length(Codes, N),
    format('Total codes found: ~w~n', [N]),
    length(Sample, 5),
    append(Sample, _, Codes),
    format('First 5: ~w~n', [Sample]),
    nl.
:- initialization(main).
main :- demo, halt.

check_size(N, T) :- 
    length(T, N),
    check_row_length(N,T).

check_row_length(_, []).
check_row_length(N, [H|T]) :-
    length(H,N),
    check_row_length(N, T).

listofNums(Low, High, []) :-
    Low > High.
listofNums(Low, High, [Low|Rest]) :-
    Low =< High,
    Next is Low + 1,
    listofNums(Next, High, Rest).
    
check_row_values(N, Row) :- 
    listofNums(1,N, List),
    sort(Row, Sorted), 
    Sorted == List.

check_all_row_values(_N,[]).
check_all_row_values(N,[H|T]) :-
    check_row_values(N,H),
    check_all_row_values(N,T).

check_all_col_values(_N, []).
check_all_col_values(N, [H|T]) :-
    check_row_values(N,H),
    check_all_col_values(N,T).

get_head([H|_], H). 
get_tail([_|T], T). 

transpose([], []). 
transpose([[]|_], []).
transpose(Matrix, [H|T]) :-
    maplist(get_head, Matrix, H),
    maplist(get_tail, Matrix, End),
    transpose(End, T).

check_counts(T,C) :-
    check_counts(T, 0, 0, C). 

check_counts([], _Max, Acc, Acc). 
check_counts([H|T], Max, Acc, Count) :-
    ( H > Max ->
         NewAcc is Acc + 1,
         NewMax is H
    ;    NewAcc = Acc,
         NewMax = Max
    ),
    check_counts(T, NewMax, NewAcc, Count).
 

check_all_counts(T, counts(Top, Bottom, Left, Right)) :- 
    maplist(check_counts, T, Left), 
    maplist(reverse, T, TReversed),
    maplist(check_counts, TReversed, Right),
    transpose(T, Columns),
    maplist(check_counts, Columns, Top),
    maplist(reverse, Columns, RevColumns),
    maplist(check_counts, RevColumns, Bottom).

length_(N, Row) :- length(Row, N).

permutation_of(Domain, Row) :-
    permutation(Domain, Row).

append_rows([], []).
append_rows([Row|Rows], All) :-
    append(Row, Rest, All),
    append_rows(Rows, Rest).

ntower(N, T, C) :-
    C = counts(Top, Bottom, Left, Right),
    integer(N), N>=0,
    length(T, N),
    maplist(length_(N), T),
    append_rows(T, Vars),
    fd_domain(Vars, 1, N),
    maplist(fd_all_different, T),
    transpose(T, Columns),
    maplist(fd_all_different, Columns),
    fd_labeling(Vars),
    check_all_counts(T, counts(Top, Bottom, Left, Right)).

plain_ntower(N, T, C) :-
    C = counts(Top, Bottom, Left, Right),
    integer(N), N >= 0,
    length(T, N),
    maplist(length_(N), T),
    listofNums(1, N, Domain),
    maplist(permutation_of(Domain), T),
    transpose(T, Cols),
    check_all_row_values(N, T),
    check_all_col_values(N, Cols),
    check_all_counts(T, counts(Top, Bottom, Left, Right)).

ambiguous(N, C, T1, T2) :-
    ntower(N, T1, C),
    ntower(N, T2, C),
    T1 \= T2.

run_tower(X, 0) :- X is 0.
run_tower(Result,N) :-
    statistics(cpu_time, [Start| _]),
    ntower(4, _T, counts([4, 3, 2, 1], [1, 2, 2, 2], [4, 3, 2, 1], [1, 2, 2, 2])), 
    statistics(cpu_time, [End| _]),
    Result1 is End - Start,
    N1 is N - 1,
    run_tower(Result2, N1),
    Result is Result1 + Result2.

run_plain_tower(X, 0) :- X is 0.
run_plain_tower(Result,N) :-    
    statistics(cpu_time, [Start| _]),
    plain_ntower(4, _T, counts([4, 3, 2, 1], [1, 2, 2, 2], [4, 3, 2, 1], [1, 2, 2, 2])),  
    statistics(cpu_time, [End| _]),
    Result1 is End - Start,
    N1 is N - 1,
    run_plain_tower(Result2, N1),
    Result is Result1 + Result2.

speedup(Ratio) :-
    run_tower(NResult, 100),
    run_plain_tower(PResult, 100),
    Ratio is PResult / NResult. 

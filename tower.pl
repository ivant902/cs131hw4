
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

check_all_row_values(N,[]).
check_all_row_values(N,[H|T]) :-
    check_row_values(N,H),
    check_all_row_values(N,T).

check_all_col_values(N, []).
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

ntower(N, T, counts(Top, Bottom, Left, Right)) :-
    integer(N), N >= 0, 
    maplist(length_(N), T), 
    listofNums(1, N, Domain),
    maplist(permutation_of(Domain), T),
    transpose(T, Cols),
    check_all_row_values(N, T),
    check_all_col_values(N, Cols),
    check_all_counts(T, counts(Top, Bottom, Left, Right)).




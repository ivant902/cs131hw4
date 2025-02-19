
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




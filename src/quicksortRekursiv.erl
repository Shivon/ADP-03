%%%-------------------------------------------------------------------
%%% @author Louisa
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dez 2014 18:08
%%%-------------------------------------------------------------------
-module(quicksortRekursiv).
-author("Louisa").

%% API
-export([quicksortRekursiv/4, quicksortRekursiv/3, quicksortRekursiv/0, quicksortRekursiv/1, getArrayIndex/2, increment_R/4, increment_L/4, swapPivot/3]).
%% -include_lib("eunit/include/eunit.hrl").

%% "Konstante"
logFile() -> "\messung.log".



%% Uses as input array as default the arrays of integers in zahlen.dat
%% Sorts automatically all integers in each line
quicksortRekursiv() ->
  quicksortRekursivOverFileLines("\zahlen.dat").

%% Name of file can be manually entered if you wish to use another file
quicksortRekursiv(FileName) ->
  quicksortRekursivOverFileLines(FileName).

%% Opens file and iterates over all tuples
quicksortRekursivOverFileLines(FileName) ->
  %% Returns {ok, List of all tuples}
  Tuples = tuple_to_list(file:consult(FileName)),
  % Initializes output file
  file:write_file("sortiert.dat", []),
  %% We need to pick last element of list because of "ok" return in Tuples
  quicksortRekursivOverTuples(lists:last(Tuples)).

%% Exit condition: List of Tuples only has one element (left)
quicksortRekursivOverTuples([Tuple]) ->
  FileName = "sortiert.dat",
  IndexLinks = 0,
  IndexRechts = arrayS:lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRekursiv(Tuple, IndexLinks, IndexRechts)]), [append]);
%% Picks head of list, recursive call
quicksortRekursivOverTuples([Tuple|Rest]) ->
  FileName = "sortiert.dat",
  IndexLinks = 0,
  IndexRechts = arrayS:lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRekursiv(Tuple, IndexLinks, IndexRechts)]), [append]),
  quicksortRekursivOverTuples(Rest).





quicksortRekursiv(Array, IndexLinks, IndexRechts, time) ->
  %% Zeit vor dem Algorithmus
  {_, Seconds, MicroSecs} = now(),
  %% Algorithmus ausführen
  quicksortRekursiv(Array, IndexLinks, IndexRechts),
  %% Zeit nach dem Algorithmus
  {_, Seconds1, MicroSecs1} = now(),
  DiffTime = ((Seconds1-Seconds)+(MicroSecs1-MicroSecs)/1000000),
  writeToFile(DiffTime, newline).


%% quicksortRekursiv: array x linkerIndex x rechterIndex -> array
%% linkerIndex: Index, von dem an sortiert werden soll
%% rechterIndex: Index, bis der sortiert werden soll
quicksortRekursiv(Array, IndexLinks, IndexRechts) when IndexLinks < IndexRechts ->
  Laenge = arrayS:lengthA(Array),
  if(Laenge < 13) ->
    selectionSort:selectionS(Array, IndexLinks, IndexRechts);
  true ->
    {Array1, IndexPivot} = swapPivot(Array, IndexLinks, IndexRechts),
    Array2 = quicksortRekursiv(Array1, IndexLinks, IndexPivot-1),
    erlang:display("Array2  "),
    erlang:display(Array2),
    erlang:display("IndexPivot+1  "),
    erlang:display(IndexPivot+1),
    erlang:display("IndexRechts+1  "),
    erlang:display(IndexRechts),
    quicksortRekursiv(Array2, IndexPivot+1, IndexRechts)
  end;

quicksortRekursiv(Array, _IndexLinks, _IndexRechts) ->
  Array.



%% swapPivot: array x IndexLinks x IndexRechts -> IndexPivot
%%
swapPivot(Array, IndexLinks, IndexRechts) ->
  L = IndexLinks + 1,
  R = IndexRechts,
  Pivot = arrayS:getA(Array, IndexLinks),
  swapPivot(Array, L, R, IndexLinks, IndexRechts, Pivot).


%% swapPivot: array x lpos x rpos x IndexLinks x IndexRechts x Pivot -> IndexPivot
swapPivot(Array, L, R, IndexLinks, IndexRechts, Pivot) when  L < R ->
  erlang:display(Array),
  swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot);


%% wenn der linke zeiger (L) den Rechten übersprungen hat bzw. umgekehrt
swapPivot(Array, L, _R, IndexLinks, _IndexRechts, Pivot) ->
  Elem = arrayS:getA(Array, L),
  erlang:display("Elem"),
  erlang:display(Elem),
  erlang:display("Pivot"),
  erlang:display(Pivot),
  if(Elem >= Pivot) ->
      erlang:display("elem >= pivot   "),
      Array1 = quicksortRandom:swap(Array, L-1, IndexLinks);
  true ->
      erlang:display("elem < pivot   "),
      Array1 = quicksortRandom:swap(Array, L, IndexLinks)
  end,
  erlang:display("Array1   "),
  erlang:display(Array1),
  erlang:display("  "),
  IndexPivot = getArrayIndex(Array1, Pivot),
  if(IndexPivot < IndexLinks) ->
    IndexPivot1 = getArrayIndex_(Array1, Pivot, IndexLinks),
    erlang:display("IndexPivot1   "),
    erlang:display(IndexPivot1),
    {Array1, IndexPivot1};
  true ->
    erlang:display("IndexPivot   "),
    erlang:display(IndexPivot),
    {Array1, IndexPivot}
  end.

swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot) ->
  NewL = increment_L(Array, L, IndexRechts, Pivot),
  NewR = increment_R(Array, R, IndexLinks, Pivot),
  erlang:display("NewL   "),
  erlang:display(NewL),
  erlang:display("NewR   "),
  erlang:display(NewR),
  if(NewL < NewR) ->
    Array1 = quicksortRandom:swap(Array, NewL, NewR),
    swapPivot(Array1, NewL, NewR, IndexLinks, IndexRechts, Pivot);
  true ->
    swapPivot(Array, NewL, NewR, IndexLinks, IndexRechts, Pivot)
  end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      HILFSFUNKTIONEN
%%      - increment_L/4
%%      - increment_R/4
%%      - getArrayIndex/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% increment_L: array x lpos x indexRechts x Pivot -> newLPos
%% Pivot muss größer sein, all der Wert von Index lPos.
%% lpos: ist der Index auf den der Zeiger für den Größenvergleich
%% zu dem Zeitpunkt zeigt.
%% newLPos: ist der Index bis zu dem das Pivot größer war.
increment_L(Array, L, IndexRechts, Pivot) ->
  LinkesElement = arrayS:getA(Array, L),
  if((LinkesElement =< Pivot) and (L < IndexRechts)) ->
    increment_L(Array, L+1, IndexRechts, Pivot);
  true ->
    L
  end.


%% increment_R: array x rpos x indexLinks x Pivot -> newRPos
%% Pivot muss kleiner sein, all der Wert von Index rpos.
%% rpos: ist der Index auf den der Zeiger für den Größenvergleich
%% zu dem Zeitpunkt zeigt.
%% newRPos: ist der Index bis zu dem das Pivot kleiner war.
increment_R(Array, R, IndexLinks, Pivot) ->
  RechtesElement = arrayS:getA(Array, R),
  if((IndexLinks =< R) and (RechtesElement > Pivot)) ->
    increment_R(Array, R-1, IndexLinks, Pivot);
  true ->
    R
 end.



%% Hilfsfunktion wenn es ein Element zweimal im Array gibt
getArrayIndex_(Array, Elem, Von) ->
  getArrayIndex(Array, Elem, Von, 0).

getArrayIndex(Array, Elem, Von, Accu) when Von == Accu ->
  getArrayIndex(Array, Elem, Accu);

getArrayIndex({_F,R}, Elem, Von, Accu) ->
  getArrayIndex(R, Elem, Von, Accu+1).


%% getArrayIndex: array x pivot -> pos
%% Hilfsfunktion um den Index eines bestimmten Elements zu bekommen
getArrayIndex(Array, Elem) ->
  getArrayIndex(Array, Elem, 0).

getArrayIndex({First, _Second}, Elem, Accu) when First == Elem ->
  Accu;

getArrayIndex({First, Second}, Elem, Accu) when First /= Elem ->
  getArrayIndex(Second, Elem, Accu +1).



writeToFile(Data, newline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Millisekunden.\n",   [Data]), [append]);

writeToFile(Data, sameline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Tausche bei\t",   [Data]), [append]).

%% quicksortRekursiv_test_() ->
%%   [?_assert(quicksortRekursiv({8,{2,{4,{1,{7,{9,{11,{6,{12,{14,{3,{10,{5,{}}}}}}}}}}}}}}, 0, 12) =:= {1,{2,{3,{4,{5,{6,{7,{8,{9,{10,{11,{12,{14,{}}}}}}}}}}}}}}),
%%    ?_assert(quicksortRekursiv({8,{2,{4,{1,{7,{9,{11,{6,{12,{14,{3,{15,{5,{}}}}}}}}}}}}}}, 0, 12) =:= {1,{2,{3,{4,{5,{6,{7,{8,{9,{11,{12,{14,{15,{}}}}}}}}}}}}}}),
%%    ?_assert(quicksortRekursiv({8,{2,{4,{1,{7,{9,{11,{6,{12,{14,{3,{4,{5,{}}}}}}}}}}}}}}, 0, 12) =:= {1,{2,{3,{4,{4,{5,{6,{7,{8,{9,{11,{12,{14,{}}}}}}}}}}}}}})
%%   ].


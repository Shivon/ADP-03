%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Nov 2014 18:49
%%%-------------------------------------------------------------------
-module(selectionSort).
-author("KamikazeOnRoad").

%% API
-export([selectionS/0, selectionS/1, selectionS/3]).
-import(arrayS, [initA/0, setA/3, getA/2, lengthA/1]).
-import(sortNum, [sortNum/0, sortNum/1]).
-import(generateOutputfile, [writeToFile/2]).
-import(myUtil, [getIndex/2, deleteA/2, getMinimum/1, getSectorArray/3]).


%% Uses as input array as default the arrays of integers in zahlen.dat
%% Sorts automatically all integers in each line
selectionS() ->
  selectionSortOverFileLines("\zahlen.dat").

%% Name of file can be manually entered if you wish to use another file
selectionS(FileName) ->
  selectionSortOverFileLines(FileName).

%% Opens file and iterates over all tuples
selectionSortOverFileLines(FileName) ->
  %% Returns {ok, List of all tuples}
  Tuples = tuple_to_list(file:consult(FileName)),
  % Initializes output file
  file:write_file("sortiert.dat", []),
  %% We need to pick last element of list because of "ok" return in Tuples
  selectionSortOverTuples(lists:last(Tuples)).

%% Exit condition: List of Tuples only has one element (left)
selectionSortOverTuples([Tuple]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [selectionS(Tuple, Von, Bis)]), [append]);
%% Picks head of list, recursive call
selectionSortOverTuples([Tuple|Rest]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [selectionS(Tuple, Von, Bis)]), [append]),
  selectionSortOverTuples(Rest).



%% Von = Index from which you want to start sorting
%% Bis = Index which shall be the last sorted
selectionS(Array, Von, Bis) ->
  UnsortedFront = insertionSort:unsortedFront(Array, Von),

  %% Time before algorithm
  {_, SecondsStart, MicroSecsStart} = now(),

  %% Calls algorithm and sorts
  SortedArray = selectionS(getSectorArray(Array, Von, Bis), initA(), 0, 0),

  %% Time after algorithm
  {_, SecondsEnd, MicroSecsEnd} = now(),
  DiffTime = ((SecondsEnd - SecondsStart)+(MicroSecsEnd - MicroSecsStart)/1000000),
  writeToFile(DiffTime, newline),

  UnsortedEnd = insertionSort:unsortedEnd(Array, Bis+1),
  insertionSort:concatTwoArray(insertionSort:concatTwoArray(UnsortedFront, SortedArray), UnsortedEnd).


selectionS(Array, SortedArray, CountSortedElem, _) ->
  Length = lengthA(Array),
  if
    Length =:= 0 -> SortedArray;
    Length > 0 ->
      Minimum = getMinimum(Array),
      selectionS(deleteA(Array, getIndex(Array, Minimum)),
        setA(SortedArray, CountSortedElem, Minimum),
        CountSortedElem+1, 0)
  end.
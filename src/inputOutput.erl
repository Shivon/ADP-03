%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dez 2014 01:41
%%%-------------------------------------------------------------------
-module(inputOutput).
-author("KamikazeOnRoad").

%% API
-export([readOverFileLines/2]).
%%-export([executeSorting/1, executeSorting/2]).
-import(arrayS, [lengthA/1]).
-import(quicksortRandom, [quicksortRandom/3]).
-import(quicksortRekursiv, [quicksortRekursiv/3]).
-import(selectionSort, [selectionS/3]).
-import(insertionSort, [insertionS/3]).


%% TODO: look for better way than hard-coding each algorithm call

%% Opens file and iterates over all tuples
readOverFileLines(FileName, Algorithm) ->
  %% Returns {ok, List of all tuples}
  Tuples = tuple_to_list(file:consult(FileName)),
  % Initializes output file
  file:write_file("sortiert.dat", []),
  %% We need to pick last element of list because of "ok" return in Tuples
  readOverTuples(lists:last(Tuples), Algorithm).

%% Exit condition: List of Tuples only has one element (left)
readOverTuples([Tuple], Algorithm) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  if
    Algorithm =:= quicksortRandom ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRandom(Tuple, Von, Bis)]), [append]);
    Algorithm =:= quicksortRekursiv ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRekursiv(Tuple, Von, Bis)]), [append]);
    Algorithm =:= selectionS ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [selectionS(Tuple, Von, Bis)]), [append]);
    Algorithm =:= insertionS ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [insertionS(Tuple, Von, Bis)]), [append])
  end;
%% Picks head of list, recursive call
readOverTuples([Tuple|Rest], Algorithm) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  if
    Algorithm =:= quicksortRandom ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRandom(Tuple, Von, Bis)]), [append]);
    Algorithm =:= quicksortRekursiv ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRekursiv(Tuple, Von, Bis)]), [append]);
    Algorithm =:= selectionS ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [selectionS(Tuple, Von, Bis)]), [append]);
    Algorithm =:= insertionS ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [insertionS(Tuple, Von, Bis)]), [append])
  end,
  readOverTuples(Rest, Algorithm).


%% %% Uses as input the arrays of integer from the file "zahlen.dat"
%% %% Sorts all integers in each line and writes into "sortiert.dat"
%% %% Attention: Pls enter for "Algorithm" the name of the function
%% executeSorting(Algorithm) -> readOverFileLines("\zahlen.dat", Algorithm).
%%
%% %% Filename can be manually entered here
%% %% Attention: Pls enter for "Algorithm" the name of the function
%% executeSorting(Filename, Algorithm) -> readOverFileLines(Filename, Algorithm).
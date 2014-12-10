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
-export([readAndWrite/0, readAndWrite/1]).
-import(arrayS, [lengthA/1]).
-import(quicksortRandom, [quicksortRandom/3]).
-import(quicksortRekursiv, [quicksortRekursiv/3]).


%% TODO: nice-to-have: set algorithm with parameter
%% executeSorting(Filename, Algorithm) ->
%%   readOverFileLines(Filename, Algorithm).


%% Uses as input array as default the arrays of integers in zahlen.dat
%% Sorts automatically all integers in each line
readAndWrite() -> readOverFileLines("\zahlen.dat").


%% Name of file can be manually entered if you wish to use another file
readAndWrite(FileName) -> readOverFileLines(FileName).


%% Opens file and iterates over all tuples
readOverFileLines(FileName) ->
  %% Returns {ok, List of all tuples}
  Tuples = tuple_to_list(file:consult(FileName)),
  % Initializes output file
  file:write_file("sortiert.dat", []),
  %% We need to pick last element of list because of "ok" return in Tuples
  readOverTuples(lists:last(Tuples)).

%% Exit condition: List of Tuples only has one element (left)
readOverTuples([Tuple]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRandom(Tuple, Von, Bis)]), [append]);
%% Picks head of list, recursive call
readOverTuples([Tuple|Rest]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [quicksortRandom(Tuple, Von, Bis)]), [append]),
  readOverTuples(Rest).
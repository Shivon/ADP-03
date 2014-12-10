%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dez 2014 01:41
%%%-------------------------------------------------------------------
-module(readInputfile).
-author("KamikazeOnRoad").

%% API
-export([readOverFileLines/1]).
-import(arrayS, [lengthA/1]).


-import(selectionSort, [selectionS/3]).  %% TODO remove

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
  file:write_file(FileName, io_lib:fwrite("~p.\n", [selectionS(Tuple, Von, Bis)]), [append]);
%% Picks head of list, recursive call
readOverTuples([Tuple|Rest]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [selectionS(Tuple, Von, Bis)]), [append]),
  readOverTuples(Rest).



%%
%%
%% %% Uses as input array as default the arrays of integers in zahlen.dat
%% %% Sorts automatically all integers in each line
%% selectionS() ->
%%   selectionSortOverFileLines("\zahlen.dat").
%%
%% %% Name of file can be manually entered if you wish to use another file
%% selectionS(FileName) ->
%%   selectionSortOverFileLines(FileName).

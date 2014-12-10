%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dez 2014 03:30
%%%-------------------------------------------------------------------
-module(executeAlgorithms).
-author("KamikazeOnRoad").

%% API
-compile(export_all).
-import(inputOutput, [readOverFileLines/2]).

%% Calls function in inputOutput file for executing read and write
selectionS() -> readOverFileLines("\zahlen.dat", selectionS).

%% Calls function in inputOutput file for executing read and write
selectionS(Filename) -> readOverFileLines(Filename, selectionS).

%% Calls function in inputOutput file for executing read and write
quicksortRandom() -> readOverFileLines("\zahlen.dat", quicksortRandom).

%% Calls function in inputOutput file for executing read and write
quicksortRandom(Filename) -> readOverFileLines(Filename, quicksortRandom).

%% Calls function in inputOutput file for executing read and write
quicksortRekursiv() -> readOverFileLines("\zahlen.dat", quicksortRekursiv).

%% Calls function in inputOutput file for executing read and write
quicksortRekursiv(Filename) -> readOverFileLines(Filename, quicksortRekursiv).

%% Calls function in inputOutput file for executing read and write
insertionS() -> readOverFileLines("\zahlen.dat", insertionS).

%% Calls function in inputOutput file for executing read and write
insertionS(Filename) -> readOverFileLines(Filename, insertionS).
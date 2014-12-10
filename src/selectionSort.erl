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
-export([selectionS/3]).
-import(arrayS, [initA/0, setA/3, getA/2, lengthA/1]).
-import(sortNum, [sortNum/0, sortNum/1]).
-import(generateOutputfile, [writeToFile/2]).
-import(myUtil, [getIndex/2, deleteA/2, getMinimum/1, getSectorArray/3]).
%%-import(inputOutput, [executeSorting/1, executeSorting/2]).


%% %% Calls function in inputOutput file for executing read and write
%% selectionS() -> executeSorting(selectionS).
%%
%% %% Calls function in inputOutput file for executing read and write
%% selectionS(Filename) -> executeSorting(Filename, selectionS).

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
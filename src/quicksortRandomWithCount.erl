%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dez 2014 11:19
%%%-------------------------------------------------------------------
-module(quicksortRandomWithCount).
-author("KamikazeOnRoad").

%% API
-export([quicksortRandomWithCount/3]).
-import(selectionSort, [selectionS/3]).
-import(myUtil, [pickRandomElem/1, getSectorArray/3]).
-import(liste, [concat/2]).
-import(arrayS, [initA/0, setA/3, lengthA/1]).
-import(generateOutputfile, [writeToFile/2]).
-import(insertionSort, [unsortedFront/2, unsortedEnd/2]).


quicksortRandomWithCount({}, _, _) -> {};
quicksortRandomWithCount(Array, Same, Same) -> Array;
quicksortRandomWithCount(Array, Left, Right) when (Right - Left) < 11 ->
  selectionS(Array, Left, Right);
quicksortRandomWithCount(Array, Left, Right) when (Right - Left) >= 11 ->
  UnsortedFront = unsortedFront(Array, Left),

  %% Time before algorithm
  {_, SecondsStart, MicroSecsStart} = now(),

  SortedArray = quicksortRandomWithCount(getSectorArray(Array, Left, Right), counter),

  %% Time after algorithm and CompareCount
  {_, SecondsEnd, MicroSecsEnd} = now(),
  DiffTime = ((SecondsEnd - SecondsStart)+(MicroSecsEnd - MicroSecsStart)/1000000),
  %% Counter
  CompareCount = util:countread(swap),
  writeToFile(CompareCount, sameline),
  writeToFile(DiffTime, newline),
  util:countreset(swap),

  UnsortedEnd = unsortedEnd(Array, Right+1),

  concat(concat(UnsortedFront, SortedArray), UnsortedEnd).


quicksortRandomWithCount({}, _) -> {};
quicksortRandomWithCount(Array, counter) ->
  %% Searches random pivot element (value, not index)
  %% This won't be saved separately since it will appear in the array "Equal"
  Pivot = pickRandomElem(Array),

  Smaller = quicksortRandomWithCount(searchSmaller(Array, Pivot, initA()), counter),
  Equal = searchEqual(Array, Pivot, {}),
  Bigger = quicksortRandomWithCount(searchBigger(Array, Pivot, initA()), counter),

  concat(concat(Smaller, Equal), Bigger).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Auxiliary functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Searches all values that are smaller than pivot and returns array of them
searchSmaller({}, _, Return) -> Return;
searchSmaller({First, Rest}, Pivot, Return) when First >= Pivot ->
  util:counting1(swap),
  searchSmaller(Rest, Pivot, Return);
searchSmaller({First, Rest}, Pivot, Return) when First < Pivot ->
  util:counting1(swap),
  searchSmaller(Rest, Pivot, setA(Return, lengthA(Return), First)).

%% Searches all values that are equal to pivot and returns array of them
searchEqual({}, _, Return) -> Return;
searchEqual({First, Rest}, Pivot, Return) when (First > Pivot) or (First < Pivot) ->
  util:counting1(swap),
  searchEqual(Rest, Pivot, Return);
searchEqual({Pivot, Rest}, Pivot, Return) ->
  util:counting1(swap),
  searchEqual(Rest, Pivot, setA(Return, lengthA(Return), Pivot)).

%% Searches all values that are greater than pivot and returns array of them
searchBigger({}, _, Return) -> Return;
searchBigger({First, Rest}, Pivot, Return) when First =< Pivot ->
  util:counting1(swap),
  searchBigger(Rest, Pivot, Return);
searchBigger({First, Rest}, Pivot, Return) when First > Pivot ->
  util:counting1(swap),
  searchBigger(Rest, Pivot, setA(Return, lengthA(Return), First)).

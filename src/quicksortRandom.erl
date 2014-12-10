%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Dez 2014 22:01
%%%-------------------------------------------------------------------
-module(quicksortRandom).
-author("KamikazeOnRoad").

%% API
-export([quicksortRandom/3]).
-import(selectionSort, [selectionS/3]).
-import(myUtil, [pickRandomElem/1, getSectorArray/3]).
-import(liste, [concat/2]).
-import(arrayS, [initA/0, setA/3, lengthA/1]).
-import(generateOutputfile, [writeToFile/2]).
-import(insertionSort, [unsortedFront/2, unsortedEnd/2]).


quicksortRandom({}, _, _) -> {};
quicksortRandom(Array, Same, Same) -> Array;
quicksortRandom(Array, Left, Right) when (Right - Left) < 11 ->
  selectionS(Array, Left, Right);
quicksortRandom(Array, Left, Right) when (Right - Left) >= 11 ->
  UnsortedFront = unsortedFront(Array, Left),

  %% Time before algorithm
  {_, SecondsStart, MicroSecsStart} = now(),

  SortedArray = quicksortRandom(getSectorArray(Array, Left, Right)),

  %% Time after algorithm
  {_, SecondsEnd, MicroSecsEnd} = now(),
  DiffTime = ((SecondsEnd - SecondsStart)+(MicroSecsEnd - MicroSecsStart)/1000000),
  writeToFile(DiffTime, newline),

  UnsortedEnd = unsortedEnd(Array, Right+1),

  concat(concat(UnsortedFront, SortedArray), UnsortedEnd).


quicksortRandom({}) -> {};
quicksortRandom(Array) ->
  %% Searches random pivot element (value, not index)
  %% This won't be saved separately since it will appear in the array "Equal"
  Pivot = pickRandomElem(Array),

  Smaller = quicksortRandom(searchSmaller(Array, Pivot, initA())),
  Equal = searchEqual(Array, Pivot, {}),
  Bigger = quicksortRandom(searchBigger(Array, Pivot, initA())),

  concat(concat(Smaller, Equal), Bigger).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Auxiliary functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Searches all values that are smaller than pivot and returns array of them
searchSmaller({}, _, Return) -> Return;
searchSmaller({First, Rest}, Pivot, Return) when First >= Pivot ->
  searchSmaller(Rest, Pivot, Return);
searchSmaller({First, Rest}, Pivot, Return) when First < Pivot ->
  searchSmaller(Rest, Pivot, setA(Return, lengthA(Return), First)).

%% Searches all values that are equal to pivot and returns array of them
searchEqual({}, _, Return) -> Return;
searchEqual({First, Rest}, Pivot, Return) when (First > Pivot) or (First < Pivot) ->
  searchEqual(Rest, Pivot, Return);
searchEqual({Pivot, Rest}, Pivot, Return) ->
  searchEqual(Rest, Pivot, setA(Return, lengthA(Return), Pivot)).

%% Searches all values that are greater than pivot and returns array of them
searchBigger({}, _, Return) -> Return;
searchBigger({First, Rest}, Pivot, Return) when First =< Pivot ->
  searchBigger(Rest, Pivot, Return);
searchBigger({First, Rest}, Pivot, Return) when First > Pivot ->
  searchBigger(Rest, Pivot, setA(Return, lengthA(Return), First)).
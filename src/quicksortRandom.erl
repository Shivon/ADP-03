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
-export([quicksortRandom/1]).
-import(selectionSort, [selectionS/3]).
-import(myUtil, [pickRandomElem/1]).
-import(liste, [concat/2]).
-import(arrayS, [setA/3, lengthA/1]).


quicksortRandom({}) -> {};
quicksortRandom(Array) ->
  %% Searches random pivot element (value, not index)
  %% This won't be saved separately since it will appear in the array Equal
  Pivot = pickRandomElem(Array),
  Smaller = quicksortRandom(searchSmaller(Array, Pivot, {})),
  Equal = searchEqual(Array, Pivot, {}),
  Bigger = quicksortRandom(searchBigger(Array, Pivot, {})),
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


%% quicksortRandomNew(Array) ->
%%   Length = lengthA(Array),
%%   if
%%     Length < 12 -> selectionS(Array, 0, Length-1);
%%     Length >= 12 -> quicksortRandom(Array, 0, Length-1)
%%   end.
%%
%% quicksortRandomNew({}, _, _) -> {};
%% quicksortRandomNew({First, Rest}, Left, R)
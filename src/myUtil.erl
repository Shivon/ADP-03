%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dez 2014 20:21
%%%-------------------------------------------------------------------
-module(myUtil).
-author("KamikazeOnRoad").

%% API
-export([pickRandomIndex/1, pickRandomIndex/3, getIndex/2]).
-import(arrayS, [lengthA/1, getA/2]).

%% Returns random elem in array
%% Returns nil if array is empty
pickRandomIndex({}) -> nil;
pickRandomIndex(Array) ->
  % random:uniform(N) generates random Integer between 1 and N
  % To get index 0, too, need to subtract 1 at the end, therefore length array as N
  random:uniform(lengthA(Array)) - 1.

%% Returns random element from specified range in array
%% Returns nil if array is empty or Left is bigger than Right
pickRandomIndex({}, _, _) -> nil;
pickRandomIndex(_, Left, Right) when Left > Right -> nil;
pickRandomIndex(Array, Left, Right) when Left < Right ->
  Length = lengthA(Array),
  if
    Right < Length -> random:uniform(Right-Left+1) + (Left-1);
    Right >= Length -> random:uniform(Length-Left) + (Left-1)
  end.

%% Returns index of elem in array,
%% returns false if elem is not in array
getIndex(Array, Elem) ->
  getIndex(Array, Elem, 0).

getIndex(Array, Elem, AccuIndex) ->
  ElemAccuIndex = getA(Array, AccuIndex),
  Length = lengthA(Array),
  if
    (AccuIndex < Length) andalso (ElemAccuIndex =:= Elem) -> AccuIndex;
    (AccuIndex < Length) andalso (ElemAccuIndex =/= Elem) -> getIndex(Array, Elem, AccuIndex+1);
    true -> false
  end.

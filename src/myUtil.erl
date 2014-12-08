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
-export([pickRandom/1, pickRandom/3, getIndex/2]).
-import(arrayS, [lengthA/1, getA/2]).

%% Returns random elem in array
%% Returns nil if array is empty
pickRandom({}) -> nil;
pickRandom(Array) ->
  % random:uniform(N) generates random Integer between 1 and N
  % To get index 0, too, need to subtract 1 at the end, therefore length array as N
  RandomIndex = random:uniform(lengthA(Array)) - 1,
  RandomElem = getA(Array, RandomIndex),
  RandomElem.

%% Returns random element from specified range in array
%% Returns nil if array is empty or Left is bigger than Right
pickRandom({}, _, _) -> nil;
pickRandom(_, Left, Right) when Left > Right -> nil;
pickRandom(Array, Left, Right) when Left < Right ->
  RandomIndex = random:uniform(Right-Left+1) + (Left-1),
  RandomElem = getA(Array, RandomIndex),
  RandomElem.

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

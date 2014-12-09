%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dez 2014 20:20
%%%-------------------------------------------------------------------
-module(quicksortRandom).
-author("KamikazeOnRoad").

%% API
%-export([quicksortRandom/1, quicksortRandom/3, swap/3, searchBigger/4, searchSmaller/4]).
-compile(export_all).
-import(arrayS, [lengthA/1, getA/2, setA/3]).
-import(selectionSort, [selectionS/3]).
-import(myUtil, [pickRandomIndex/3, getIndex/2]).
-import(liste, [concat/2]).

% sorts all elements of array
quicksortRandom({}) -> {};
quicksortRandom(Array) ->
  Length = lengthA(Array),
  if
    Length < 12 -> selectionS(Array, 0, Length-1);
    Length >= 12 -> quicksortRandom(Array, 0, Length-1)
  end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TODO: no return value for quicksort by now....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sorts elements of array between Left and Right
quicksortRandom({}, _, _) -> {};
quicksortRandom(Array, Same, Same) -> Array;
quicksortRandom(Array, Left, Right) when Left > Right -> Array;
quicksortRandom(Array, Left, Right) when Left < Right ->
  %% TODO: for opimization:
  %% Length = Right-Left+1,
  erlang:display("Test"),
  Divider = divide(Array, Left, Right),
  erlang:display("yay"),
%%   quicksortRandom(Array, Left, Divider-1),
%%   quicksortRandom(Array, Divider+1, Right),
  concat(concat(quicksortRandom(Array, Left, Divider-1), Divider), quicksortRandom(Array, Divider+1, Right)).


divide(Array, Left, Right) ->
  %% get random pivot element
  %% we use the index since our swap works with indices and
  %% with the index the pivot is distinct from other possibly occuring elements with the same value
  PivotIndex = pickRandomIndex(Array, Left, Right),
  erlang:display("Test2"),
  divide(Array, PivotIndex, Left, Right),
  erlang:display("Yay2"), %% TODO: beheben: kommt schon hier nicht raus
  getIndex(Array, PivotIndex).

divide(Array, PivotIndex, Left, Right) when Left =:= Right ->
  erlang:display("Left =:= Right"),
  swap(Array, Left, getIndex(Array, PivotIndex));

divide(Array, PivotIndex, Left, Right) when Left < Right ->
  erlang:display("PivotIndex Left < Right"),
  erlang:display(PivotIndex),
  Bigger = searchBigger(Array, PivotIndex, Left, Right),
  erlang:display("Bigger Left < Right"),
  erlang:display(Bigger),
  Smaller = searchSmaller(Array, PivotIndex, Left, Right),
  erlang:display("Smaller Left < Right"),
  erlang:display(Smaller), % dies hier noch gedruckt
  ArrayNew = swap(Array, Bigger, Smaller),  %% TODO <= hier hängt es ?!!!??
  %%swap(Array, searchBigger(Array, Pivot, Left, Right), searchSmaller(Array, Pivot, Left, Right)),
  erlang:display("Swap Left < Right"),
  divide(ArrayNew, PivotIndex, Left +1, Right -1);
  %%divide(Array, Pivot, Left +1, Right -1);

divide(Array, PivotIndex, Left, Right) when Left > Right ->
  erlang:display("Left > Right"),
  swap(Array, Left, PivotIndex).


searchBigger(Array, PivotIndex, Left, Left) ->
  ElemLeft = getA(Array, Left),
  PivotElem = getA(Array, PivotIndex),
  if
    %% if last elem in array is bigger than pivot elem
    ElemLeft > PivotElem -> Left;
    %% if pivot is biggest elem in array    TODO: maybe change return value? not sure if works
    ElemLeft =< PivotElem -> PivotIndex
  end;
searchBigger(Array, PivotIndex, Left, Right) when Left < Right ->
  ElemLeft = getA(Array, Left),
  PivotElem = getA(Array, PivotIndex),
  if
    ElemLeft > PivotElem -> Left;
    ElemLeft =< PivotElem -> searchBigger(Array, PivotIndex, Left+1, Right)
  end.

searchSmaller(_, _, Right, Right) -> ok;
searchSmaller(Array, PivotIndex, Left, Right) when Left < Right ->
  ElemRight = getA(Array, Right),
  PivotElem = getA(Array, PivotIndex),
  if
    ElemRight < PivotElem -> Right;
    ElemRight >= PivotElem -> searchSmaller(Array, PivotIndex, Left, Right-1)
  end.

% Swaps 2 elements at specified indices in array and returns array
%%%%%%%%%%%%%%%%% NOTIZ: Läuft
swap({}, _, _) -> {};
swap(Array, Index, Index) -> Array;
swap(Array, Index1, Index2) ->
  Elem1 = getA(Array, Index1),
  Elem2 = getA(Array, Index2),
  setA(setA(Array, Index1, Elem2), Index2, Elem1).


%% ex (*)
%%   ElemPointerBig = getA(Array, PointerBig),
%%   ElemPointerSmall = getA(Array, PointerSmall),
%%   if
%%     (PointerBig < PointerSmall) andalso (ElemPointerBig > Pivot) ->
%%       if
%%         (ElemPointerSmall < Pivot) -> swap(Array, ElemPointerBig, ElemPointerSmall),
%%                                       divide(Array, PointerBig+1, PointerSmall-1);
%%         (ElemPointerSmall =< Pivot) -> divide(Array, PointerBig, PointerSmall-1)
%%       end;
%%     (PointerBig < PointerSmall) andalso (ElemPointerBig =< Pivot) ->
%%       divide(Array, PointerBig+1, PointerSmall);
%%     (PointerBig > PointerSmall) ->
%%   end,
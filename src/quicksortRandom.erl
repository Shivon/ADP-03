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
-export([quicksortRandom/1, quicksortRandom/3, swap/3]).
-import(arrayS, [lengthA/1, getA/2, setA/3]).
-import(selectionSort, [selectionS/3]).
-import(myUtil, [pickRandom/3, getIndex/2]).

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
  Divider = divide(Array, Left, Right),
  quicksortRandom(Array, Left, Divider-1),
  quicksortRandom(Array, Divider+1, Right).


divide(Array, Left, Right) ->
  % get random pivot element
  Pivot = pickRandom(Array, Left, Right),
  divide(Array, Pivot, Left, Right),
  getIndex(Array, Pivot).

divide(Array, Pivot, Left, Right) when Left =:= Right ->
  swap(Array, Left, getIndex(Array, Pivot));

divide(Array, Pivot, Left, Right) when Left < Right ->
  swap(Array, searchBigger(Array, Pivot, Left, Right), searchSmaller(Array, Pivot, Left, Right)),
  divide(Array, Pivot, Left +1, Right -1);

divide(Array, Pivot, Left, Right) when Left > Right ->
  swap(Array, Left, getIndex(Array, Pivot)).



searchBigger(Array, Pivot, Left, Right) when Left < Right ->
  ElemLeft = getA(Array, Left),
  if
    ElemLeft > Pivot -> ElemLeft;
    ElemLeft =< Pivot -> searchBigger(Array, Pivot, Left+1, Right)
  end.

searchSmaller(Array, Pivot, Left, Right) when Left < Right ->
  ElemRight = getA(Array, Right),
  if
    ElemRight < Pivot -> ElemRight;
    ElemRight >= Pivot -> searchSmaller(Array, Pivot, Left, Right-1)
  end.

% Swaps 2 elements in array and returns array
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
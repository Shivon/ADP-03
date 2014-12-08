%%%-------------------------------------------------------------------
%%% @author Louisa
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dez 2014 18:08
%%%-------------------------------------------------------------------
-module(quicksortRekursiv).
-author("Louisa").

%% API
-export([quicksortRekursiv/3, getArrayIndex/2]).


quicksortRekursiv(Array, IndexLinks, IndexRechts) when IndexLinks < IndexRechts ->
  Laenge = arrayS:lengthA(Array),
  if(Laenge < 13) ->
    insertionSort:insertionS(Array, IndexLinks, IndexRechts);
  true ->
    IndexPivot = swapPivot(Array, IndexLinks, IndexRechts),
    quicksortRekursiv(Array, IndexLinks, IndexPivot-1),
    quicksortRekursiv(Array, IndexPivot+1, IndexRechts)
  end;

quicksortRekursiv(Array, _IndexLinks, _IndexRechts) ->
  Array.




swapPivot(Array, IndexLinks, IndexRechts) ->
  L = IndexLinks + 1,
  R = IndexRechts,
  Pivot = arrayS:getA(Array, IndexLinks),
  swapPivot(Array, L, R, IndexLinks, IndexRechts, Pivot).



swapPivot(Array, L, R, IndexLinks, IndexRechts, Pivot) when  L =< R ->
  swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot);

swapPivot(Array, L, _R, IndexLinks, _IndexRechts, Pivot) ->
  Array1 = quicksortRandom:swap(Array, L, IndexLinks),
  IndexPivot = getArrayIndex(Array1, Pivot),
  IndexPivot.

swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot) ->
  NewL = increment_L(Array, L, IndexRechts, Pivot),
  NewR = increment_R(Array, R, IndexLinks, Pivot),
  if(NewL < NewR) ->
    Array1 = quicksortRandom:swap(Array, NewL, NewR)
  end,
    swapPivot(Array1, NewL, NewR, IndexLinks, IndexRechts, Pivot).






%% increment_L: array x lpos x indexRechts x Pivot -> newLPos
%% Pivot muss größer sein, all der Wert von Index lPos.
%% lpos: ist der Index auf den der Zeiger für den Größenvergleich
%% zu dem Zeitpunkt zeigt.
%% newLPos: ist der Index bis zu dem das Pivot größer war.
increment_L(Array, L, IndexRechts, Pivot) ->
  LinkesElement = arrayS:getA(Array, L),
  if((LinkesElement < Pivot) and (L < IndexRechts)) ->
    increment_L(Array, L+1, IndexRechts, Pivot);
  true ->
    L
  end.


%% increment_R: array x rpos x indexLinks x Pivot -> newRPos
%% Pivot muss kleiner sein, all der Wert von Index rpos.
%% rpos: ist der Index auf den der Zeiger für den Größenvergleich
%% zu dem Zeitpunkt zeigt.
%% newRPos: ist der Index bis zu dem das Pivot kleiner war.
increment_R(Array, R, IndexLinks, Pivot) ->
  RechtesElement = arrayS:getA(Array, R),
  if((IndexLinks =< R) and (RechtesElement > Pivot)) ->
    increment_R(Array, R-1, IndexLinks, Pivot);
  true ->
    R
 end.



%% getArrayIndex: array x pivot -> pos
%% Hilfsfunktion um den Index eines bestimmten Elements zu bekommen
getArrayIndex(Array, Elem) ->
  getArrayIndex(Array, Elem, 0).

getArrayIndex({First, _Second}, Elem, Accu) when First == Elem ->
  Accu;

getArrayIndex({First, Second}, Elem, Accu) when First /= Elem ->
  getArrayIndex(Second, Elem, Accu +1).


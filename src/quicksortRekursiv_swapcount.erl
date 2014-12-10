%%%-------------------------------------------------------------------
%%% @author Louisa
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dez 2014 09:29
%%%-------------------------------------------------------------------
-module(quicksortRekursiv_swapcount).
-author("Louisa").

%% API
-export([quicksortRekursiv/4]).




%% quicksortRekursiv: array x linkerIndex x rechterIndex -> array
%% linkerIndex: Index, von dem an sortiert werden soll
%% rechterIndex: Index, bis der sortiert werden soll
quicksortRekursiv(Array, IndexLinks, IndexRechts, counter) when IndexLinks < IndexRechts ->
  Laenge = arrayS:lengthA(Array),
  if(Laenge < 12) ->
    selectionSort:selectionS(Array, IndexLinks, IndexRechts);
  true ->
      {Array1, IndexPivot} = swapPivot(Array, IndexLinks, IndexRechts),
      Array2 = quicksortRekursiv(Array1, IndexLinks, IndexPivot-1, counter),
      quicksortRekursiv(Array2, IndexPivot+1, IndexRechts, counter)
  end;

quicksortRekursiv(Array, _IndexLinks, _IndexRechts, counter) ->
  Array.



%% swapPivot: array x IndexLinks x IndexRechts -> {Array, IndexPivot}
%% berechnet Pivot, linken und Rechten Zeiger und gibt es an
%% swapPivot/6 weiter.
swapPivot(Array, IndexLinks, IndexRechts) ->
  L = IndexLinks + 1,
  R = IndexRechts,
  Pivot = arrayS:getA(Array, IndexLinks),
  swapPivot(Array, L, R, IndexLinks, IndexRechts, Pivot).


%% swapPivot: array x lpos x rpos x IndexLinks x IndexRechts x Pivot -> {Array, IndexPivot}
%% Solange der linke Zeiger kleiner als der Rechte ist (links vom rechten Zeiger steht),
%% soll der Platz für das Pivot gesucht werden mit Hilfe der Hilfsfunktion/Unterfunktion:
%% swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot).
swapPivot(Array, L, R, IndexLinks, IndexRechts, Pivot) when  L < R ->
  swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot);


%% wenn der linke zeiger (L) den Rechten übersprungen hat bzw. umgekehrt,
%% dann wurde der Platz für das Pivot gefunden und das Pivot wird mit dem
%% dort stehenden Element getauscht.
swapPivot(Array, L, _R, IndexLinks, _IndexRechts, Pivot) ->
  Elem = arrayS:getA(Array, L),
  if(Elem > Pivot) ->
    Array1 = myUtil:swap(Array, L-1, IndexLinks),
    util:counting1(swap),
    IndexPivot = L-1;
  true ->
      Array1 = myUtil:swap(Array, L, IndexLinks),
      util:counting1(swap),
      IndexPivot = L
  end,
  {Array1, IndexPivot}.


%% linke und rechter Zeiger werden hochgezählt bzw. verringert,
%% bis der Wert auf den sie zeigen kleiner bzw größer als Pivot sind.
%% (Wert von L darf nicht größer als Pivot sein, wenn größer, dann
%%  wird nicht mehr erhöht,
%%  Wert von R darf nicht kleiner als Pivot sein, wenn kleiner, dann
%%  wird nicht mehr verringert
%% Wenn der linke Zeiger kleiner als der Rechte ist (also links vom Rechten steht),
%% dann werden die beiden Werte der Zeiger vertauscht, sonst wird einfach weitergegangen.
swapPivot_(Array, L, R, IndexLinks, IndexRechts, Pivot) ->
  NewL = increment_L(Array, L, IndexRechts, Pivot),
  NewR = increment_R(Array, R, IndexLinks, Pivot),
  if(NewL < NewR) ->
    Array1 = myUtil:swap(Array, NewL, NewR),
    util:counting1(swap),
    swapPivot(Array1, NewL, NewR, IndexLinks, IndexRechts, Pivot);
  true ->
      swapPivot(Array, NewL, NewR, IndexLinks, IndexRechts, Pivot)
  end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      HILFSFUNKTIONEN
%%      - increment_L/4
%%      - increment_R/4
%%      - writeToFile/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% increment_L: array x lpos x indexRechts x Pivot -> newLPos
%% Pivot muss größer sein, all der Wert von Index lPos.
%% lpos: ist der Index auf den der Zeiger für den Größenvergleich
%% zu dem Zeitpunkt zeigt.
%% newLPos: ist der Index bis zu dem das Pivot größer war.
increment_L(Array, L, IndexRechts, Pivot) ->
  LinkesElement = arrayS:getA(Array, L),
  if((LinkesElement =< Pivot) and (L < IndexRechts)) ->
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



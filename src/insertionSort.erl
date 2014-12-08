%%%-------------------------------------------------------------------
%%% @author Marjan und Louisa
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Nov 2014 18:48
%%%-------------------------------------------------------------------
-module(insertionSort).

%% API
-export([insertionS/0, insertionS/1, insertionS/3, unsortedFront/2, sortedPart/3, unsortedEnd/2, concatTwoArray/2]).

%% "Konstante"
logFile() -> "\messung.log".


%%  Wahrheitstafel:
%% __A___B____A_v_B__
%% | 0   0 |    0   |
%% | 0   1 |    1   |
%% | 1   0 |    1   |
%% |_1___1_|____1___|
%%

%% Uses as input array as default the arrays of integers in zahlen.dat
%% Sorts automatically all integers in each line
insertionS() ->
  insertionSortOverFileLines("\zahlen.dat").

%% Name of file can be manually entered if you wish to use another file
insertionS(FileName) ->
  insertionSortOverFileLines(FileName).

%% Opens file and iterates over all tuples
insertionSortOverFileLines(FileName) ->
  %% Returns {ok, List of all tuples}
  Tuples = tuple_to_list(file:consult(FileName)),
  % Initializes output file
  file:write_file("sortiert.dat", []),
  %% We need to pick last element of list because of "ok" return in Tuples
  insertionSortOverTuples(lists:last(Tuples)).

%% Exit condition: List of Tuples only has one element (left)
insertionSortOverTuples([Tuple]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = arrayS:lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [insertionS(Tuple, Von, Bis)]), [append]);
%% Picks head of list, recursive call
insertionSortOverTuples([Tuple|Rest]) ->
  FileName = "sortiert.dat",
  Von = 0,
  Bis = arrayS:lengthA(Tuple),
  file:write_file(FileName, io_lib:fwrite("~p.\n", [insertionS(Tuple, Von, Bis)]), [append]),
  insertionSortOverTuples(Rest).


insertionS(Array, Von, Bis) ->
      List = arrayS:initA(),
      ArrayNotToSort1 = unsortedFront(Array, Von),  %% unsortedFront: gibt den ersten Teil zurück, der nicht mit sortiert werden soll zurück.
      ArrayToSort = sortedPart(Array, Von, Bis), %% sortedPart: gibt den zu sortierenden Teil zurück.
      ArrayNotToSort2 = unsortedEnd(Array, Bis+1),  %% unsortedEnd: gibt den hinteren Teil, der nicht mit sortiert werden soll zurück.

      %% Zeit vor dem Algorithmus
      {_, Seconds, MicroSecs} = now(),
      %% Algorithmus ausführen
      NewSortedArray = insertionS(ArrayToSort, List, 0, false),
      %% Zeit nach dem Algorithmus
      {_, Seconds1, MicroSecs1} = now(),
      DiffTime = ((Seconds1-Seconds)+(MicroSecs1-MicroSecs)/1000000),
      writeToFile(DiffTime, newline),

      %% Konkatinieren zur Rückgabeliste
      ArrayConcat = concatTwoArray(ArrayNotToSort1, NewSortedArray),
      concatTwoArray(ArrayConcat, ArrayNotToSort2).





%% Algorithmus ist mit dem gesamten tauschen fertig,
%% im letzten Durchgang wurde nicht mehr getauscht.
insertionS({First,{}}, ReturnList, Swapcount, false) ->
  Pos = arrayS:lengthA(ReturnList),
  ReturnList2 = arrayS:setA(ReturnList, Pos, First),
  writeToFile(Swapcount, sameline),
  ReturnList2;


%% Algorithmus ist noch nicht fertig mit tauschen,
%% beim Durchgehen der Liste im letzten Durchgang wurde immernoch getauscht.
insertionS({First,{}}, ReturnList, _Swapcount, true) ->
  ReturnListNew = arrayS:initA(),
  Pos = arrayS:lengthA(ReturnList),
  ReturnList2 = arrayS:setA(ReturnList, Pos, First),
  insertionS(ReturnList2, ReturnListNew, _Swapcount, false);


%% Das erste angeschaute Elemente ist kleiner als das Zweite.
%% Es muss nicht getauscht werden.
insertionS({First, {Second, Rest}}, ReturnList, _Swapcount, Switched) when First < Second ->
  PosForFirst = arrayS:lengthA(ReturnList),
  NewArray1 = arrayS:setA(ReturnList, PosForFirst, First),
  NewSwitched = (Switched or false),
  insertionS({Second, Rest}, NewArray1, _Swapcount, NewSwitched);


%% Das erste angeschaute Elemente ist großer als das Zweite.
%% Es muss getauscht werden.
insertionS({First, {Second, Rest}}, ReturnList, Swapcount, Switched) when First > Second ->
  PosForSecond = arrayS:lengthA(ReturnList),
  NewArray1 = arrayS:setA(ReturnList, PosForSecond, Second),
  NewSwitched = (Switched or true),
  insertionS({First, Rest}, NewArray1, Swapcount+1, NewSwitched).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   HILFSFUNKTIONEN  %%
%%     - unsortedFront/2
%%     - sortedPart/3
%%     - unsortedEnd/2
%%     - concatTwoArray/2
%%     - writeToFile/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Array x NewArray x  BisIndex -> NewArray
%% Gibt den nicht zu sortierenden Teil aus der vor dem zu sortierenden Teil steht
unsortedFront(Array, BisIndex) ->
  NewArray = arrayS:initA(),
  unsortedFront(Array, NewArray, 0,  BisIndex).

unsortedFront(_Array, NewArray, _PosAt,  BisIndex) when BisIndex == 0 ->
  NewArray;

unsortedFront(Array, NewArray, PosAt,  BisIndex) ->
  Elem = arrayS:getA(Array, PosAt),
  Pos = arrayS:lengthA(NewArray),
  NewArray1 = arrayS:setA(NewArray, Pos, Elem),
  NewPosAt = PosAt + 1,
  NewBisIndex = BisIndex - 1,
  unsortedFront(Array, NewArray1, NewPosAt, NewBisIndex).



sortedPart(Array, VonIndex, BisIndex) ->
  NewArray = arrayS:initA(),
  LastIndex = arrayS:lengthA(Array)-1,
  if
    (LastIndex < BisIndex) -> sortedPart(Array, NewArray, 0, VonIndex, LastIndex);
    true -> sortedPart(Array, NewArray, 0, VonIndex, BisIndex)
  end.

%% Array x NewArray x PosAt x VonIndex x BisIndex -> NewArray
%% Gibt den zu sortierenden Teil aus
 sortedPart(_Array, NewArray, PosAt, _VonIndex, BisIndex) when PosAt > BisIndex ->
  NewArray;

%% Die Liste wird durchgegangen ohne etwas zu machen,
%% bis der Index gleich dem übergebenen Index VonIndex ist
 sortedPart(Array, NewArray, PosAt, VonIndex, BisIndex) when PosAt < VonIndex ->
   NewPosAt = PosAt + 1,
   sortedPart(Array, NewArray, NewPosAt, VonIndex, BisIndex);

 sortedPart(Array, NewArray, PosAt, VonIndex, BisIndex) when PosAt >= VonIndex ->
   Elem = arrayS:getA(Array, PosAt),
   Pos = arrayS:lengthA(NewArray),
   NewArray1 = arrayS:setA(NewArray, Pos, Elem),
   NewPosAt = PosAt + 1,
   sortedPart(Array, NewArray1, NewPosAt, VonIndex, BisIndex).





%% unsortedEnd: Array x Array x Startindex -> Array
%% Gibt den Endteil des Arrays aus was nicht sortiert werden soll
unsortedEnd(Array, VonIndex) ->
   NewArray = arrayS:initA(),
  unsortedEnd(Array, NewArray, 0, VonIndex).

unsortedEnd(Array, NewArray, PosAt, VonIndex) when PosAt < VonIndex ->
    NewPosAt = PosAt + 1,
    unsortedEnd(Array, NewArray, NewPosAt, VonIndex);

unsortedEnd(Array, NewArray, PosAt, VonIndex)  ->
  Length = arrayS:lengthA(Array),
  if
    (PosAt < Length) ->
       Elem = arrayS:getA(Array, PosAt),
       Pos = arrayS:lengthA(NewArray),
       NewArray1 = arrayS:setA(NewArray, Pos, Elem),
       NewPosAt = PosAt + 1,
       unsortedEnd(Array, NewArray1, NewPosAt, VonIndex);
    true ->
       NewArray
  end.





%% concatTwoArray: Array x Array -> Array
%% Konkatiniert zwei Arrays
 concatTwoArray(Array1, Array2) ->
    concatTwoArray(Array1, Array2, 0).

 concatTwoArray(Array1, Array2, PosAccu) ->
    Pos1 = arrayS:lengthA(Array2),
    if
      (Pos1 > PosAccu) ->
          Pos2 = arrayS:lengthA(Array1),
          Elem = arrayS:getA(Array2, PosAccu),
          NewArray = arrayS:setA(Array1, Pos2, Elem ),
          concatTwoArray(NewArray, Array2, PosAccu+1);
      (Pos1 =< PosAccu) ->
          Array1
    end.


writeToFile(Data, newline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Millisekunden.\n",   [Data]), [append]);

writeToFile(Data, sameline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Tausche bei\t",   [Data]), [append]).
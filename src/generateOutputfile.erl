%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Dez 2014 00:10
%%%-------------------------------------------------------------------
-module(generateOutputfile).
-author("KamikazeOnRoad").

%% API
-export([writeToFile/2]).
%%-import().

logFile() -> "\messung.log".

%% Writes time needed for algorithm in milliseconds into "messung.log"
writeToFile(Data, newline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Millisekunden.\n",   [Data]), [append]);

%% Writes numbers of comparisons into "messung.log"
writeToFile(Data, sameline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Tausche bei\t",   [Data]), [append]).
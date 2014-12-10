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

writeToFile(Data, newline) ->
  file:write_file(logFile(), io_lib:fwrite("~p\t Millisekunden.\n",   [Data]), [append]).
-module(muumuu_app).
-behavior(application).
-export([start/2, stop/1]).

start(_Type, _Args) ->
    muumuu_sup:start_link().

stop(_) ->
    ok.

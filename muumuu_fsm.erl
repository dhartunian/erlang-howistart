-module(muumuu_fsm).
-export([start/0]).

-define(MAX_NO_VENT, 5).

start() ->
    %% Seed PRNG
    <<A:32, B:32, C:32>> = crypto::rand_bytes(12),
    random:seed(A,B,C),
    wait_any_key().

wait_any_key() ->
    io:get_line("To start, Press Any Key.\n> "),
    first_core_check().

first_core_check() ->
    case option("Check core temperature?") of
        yes ->
            core_temperature();
        no -> noop()
    end,
    first_gas_vent().

first_gas_vent() ->
    case option("Vent radioactive gas?") of
        yes ->
            blow_crops_away();
        no -> venting_prevents_explosions()
    end,
    wait_for_command().

wait_for_command() ->
    case wait_cmd(10000) of
        timeout ->
            {Opt, Yes, No} = random_option(),
            case option(Opt) of
                yes ->
                    Yes();
                no ->
                    No()
            end;
        Cmd ->
            case match_option(Cmd) of
                {_, Yes, _ } ->
                    Yes();
                _ -> noop
            end
    end,
    wait_for_command().

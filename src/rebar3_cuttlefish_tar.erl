-module(rebar3_cuttlefish_tar).
-behaviour(provider).

-export([ init/1
        , do/1
        , format_error/1
        ]).

-define(PROVIDER, tar).
-define(NAMESPACE, default).
-define(DEPS, [{?NAMESPACE, release}]).

%% ===================================================================
%% Public API
%% ===================================================================
-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    Provider = providers:create([
            {name, ?PROVIDER},            % The 'user friendly' name of the task
            {module, ?MODULE},            % The module implementation of the task
            {namespace, ?NAMESPACE},
            {bare, true},                 % The task can be run by the user, always true
            {deps, ?DEPS},                % The list of dependencies
            {example, "rebar3 cuttlefish tar"}, % How to use the plugin
            {opts, supported_options()},        % list of options understood by the plugin
            {short_desc, "Rebar3 cuttlefish release tarball plugin"},
            {desc, ""}
    ]),
    {ok, rebar_state:add_provider(State, Provider)}.


-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    try
        rebar_relx:do(?PROVIDER, State)
    catch _:undef ->
            rebar_relx:do(rlx_prv_release, atom_to_list(?PROVIDER), ?PROVIDER, State)
    end.


-spec format_error(any()) ->  iolist().
format_error(Error) ->
    io_lib:format("~p", [Error]).

supported_options() ->
    try
        relx:opt_spec_list()
    catch _:undef ->
            rebar_relx:opt_spec_list()
    end.

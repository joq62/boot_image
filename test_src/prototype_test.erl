%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(prototype_test).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
  %  io:format("~p~n",[{"Start setup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=setup(),
    io:format("~p~n",[{"Stop setup",?MODULE,?FUNCTION_NAME,?LINE}]),

%    io:format("~p~n",[{"Start init()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=init(),
    io:format("~p~n",[{"Stop init()",?MODULE,?FUNCTION_NAME,?LINE}]),

  %  io:format("~p~n",[{"Start stop_restart()",?MODULE,?FUNCTION_NAME,?LINE}]),
  %  ok= stop_restart(),
  %  io:format("~p~n",[{"Stop  stop_restart()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   
      %% End application tests
  %  io:format("~p~n",[{"Start cleanup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cleanup(),
  %  io:format("~p~n",[{"Stop cleaup",?MODULE,?FUNCTION_NAME,?LINE}]),
   
    io:format("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.
 %  io:format("application:which ~p~n",[{application:which_applications(),?FUNCTION_NAME,?MODULE,?LINE}]),

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
init()->
    os:cmd("rm -rf *.tmp_configs"),
    timer:sleep(500),
    {ok,TmpDirName,DeploymentConfigs,HostsConfigs}=boot_image:load_configs(),
       
    DeploymentConfigs=filename:join([TmpDirName,"configs","deployments"]),
    true=filelib:is_dir(DeploymentConfigs),
    HostsConfigs=filename:join([TmpDirName,"configs","host"]),
    true=filelib:is_dir(HostsConfigs),
    [
     {"c100.host",C100HostFile},
     {"c200.host",C200HostFile},
     {"c201.host",C201HostFile},
     {"c202.host",C202HostFile},
     {"c203.host",C203HostFile}]=lists:keysort(1,boot_image:get_host_files(HostsConfigs)),
    
    {ok,C200List}=file:consult(C200HostFile),
    "host_c200.vm"=proplists:get_value(root_dir,C200List),
    {ok,C201List}=file:consult(C201HostFile),
    "host_c201.vm"=proplists:get_value(root_dir,C201List),
    {ok,C202List}=file:consult(C202HostFile),
    "host_c202.vm"=proplists:get_value(root_dir,C202List),
    {ok,C203List}=file:consult(C203HostFile),
    "host_c203.vm"=proplists:get_value(root_dir,C203List),

    {ok,"host.service",HostServiceFullName}=boot_image:get_host_service_file(HostsConfigs),
    {ok,[{kublet,"1.0.0","https://github.com/joq62/kublet.git"}]}=file:consult(HostServiceFullName),
    {ok,"host.nodes",HostNodesFullName}=boot_image:get_host_nodes_file(HostsConfigs),
    {ok,HostNodes}=file:consult(HostNodesFullName),
    [host@c200,host@c201,host@c202]=lists:sort(HostNodes),


    
    

    [[{name,"add"},
      {vsn,"1.0.0"},
      {template,
       [{myadd,"1.0.0","https://github.com/joq62/myadd.git"}]},
      {affinity,[]}],
     [{name,"divi"},
      {vsn,"1.0.0"},
      {template,
       [{mydivi,"1.0.0",
	 "https://github.com/joq62/mydivi.git"}]},
      {affinity,[]}]]=lists:sort(boot_image:get_deployment_files(DeploymentConfigs)),
    
   
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------



  
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
a()->
    						

    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
   
        
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
   
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

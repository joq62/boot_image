%%% -------------------------------------------------------------------
%%% Author  : joqerlang
%%% Description :  
%%% This module is called from the systemd deamon thats starts
%%% after reset.
%%% Loads the host application from git 
%%% Starts the host applications 
%%% 
%%% Created : 2022-01-05
%%% -------------------------------------------------------------------
-module(boot_image).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("boot_image.hrl").

%% --------------------------------------------------------------------
-compile(export_all).

%% ====================================================================
%% External functions
%% ====================================================================

start()-> 
   
    % 
    %Create a tmp dir load configs
    %
    % 
    % Check if log dir is needs to be created 
    % Load configs files into Root dir
    % Read host.nodes and connect
    % Read host.service an clone app 
    % Scratch computer: Delete and create Root dir

    {ok,TmpDir,DeploymentConfigs,HostsConfigs}=load_configs(),
 
    HostFileList=get_host_files(HostsConfigs),
    {ok,HostServiceFile,HostServiceFileFullPath}=get_host_service_file(HostsConfigs),
    {ok,HostNodesFile,HostNodesFileFullPath}=get_host_nodes_file(HostsConfigs),
    
    DeploymentLists=get_deployment_files(DeploymentConfigs),
    
    

   
    
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

get_host_service_file(HostsConfigs)->
    true=code:add_patha(HostsConfigs),
    {ok,Hostfiles}=file:list_dir(HostsConfigs),
    FullfileNames=[{File,code:where_is_file(File)}||File<-Hostfiles,
							    ".service"=:=filename:extension(File)],
    case FullfileNames of
	[]->
	    {error,[eexists_host_service_file]};
	[{File,FullPath}] ->
	    {ok,File,FullPath}
    end.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

get_host_nodes_file(HostsConfigs)->
    true=code:add_patha(HostsConfigs),
    {ok,Hostfiles}=file:list_dir(HostsConfigs),
    FullfileNames=[{File,code:where_is_file(File)}||File<-Hostfiles,
							    ".nodes"=:=filename:extension(File)],
     case FullfileNames of
	[]->
	    {error,[eexists_host_nodes_file]};
	[{File,FullPath}] ->
	    {ok,File,FullPath}
    end.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

get_host_files(HostsConfigs)->
     true=code:add_patha(HostsConfigs),
    {ok,Hostfiles}=file:list_dir(HostsConfigs),
    FullfileNames=[{File,code:where_is_file(File)}||File<-Hostfiles,
							    ".host"=:=filename:extension(File)],
    FullfileNames.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

get_deployment_files(DeploymentConfigs)->
    true=code:add_patha(DeploymentConfigs),
    {ok,DeploymentFiles}=file:list_dir(DeploymentConfigs),
    DeploymentListsOrg=[file:consult(code:where_is_file(File))||File<-DeploymentFiles,
							    ".deployment"=:=filename:extension(File)],
    DeploymentLists=[I||{ok,I}<-DeploymentListsOrg].
	
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
load_configs()->
    TmpDirName=integer_to_list(erlang:system_time(millisecond))++".tmp_configs",
    Destination=filename:join(TmpDirName,?Configs),
    ok=file:make_dir(TmpDirName),
    ok=file:make_dir(Destination),
    
    os:cmd("git clone "++?ConfigsGitPath++" "++Destination),
    DeploymentConfigs=filename:join([TmpDirName,?Configs,?Deployments]),
    HostsConfigs=filename:join([TmpDirName,?Configs,?Host]),
    {ok,TmpDirName,DeploymentConfigs,HostsConfigs}.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
scratch_host(RootDir)->
    []=os:cmd("rm -rf "++RootDir),
    ok.


						      
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
git_clone(GitPath,Application,ParentDir)->
    ApplicationPath=filename:join(ParentDir,atom_to_list(Application)),
    os:cmd("git clone "++GitPath++" "++ApplicationPath),
    AppEbin=filename:join(ApplicationPath,"ebin"),
    Result=case filelib:is_dir(AppEbin) of
	       true->
		   {ok,AppEbin};
	       false->
		   {error,[{code,eexists},
			   {info,AppEbin,GitPath,Application,ParentDir},
			   {file,?MODULE,?FUNCTION_NAME,?LINE}]}
	   end,
    Result.
    
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

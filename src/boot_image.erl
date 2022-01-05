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
    ok=scratch_host(?RootDir),
    ok=file:make_dir(?RootDir),
    {ok,HostAppEbin}=git_clone(?HostAppGitPath,?HostApp,?RootDir),
    true=code:add_patha(HostAppEbin),
    ok=application:start(?HostApp),
    
    ok.

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

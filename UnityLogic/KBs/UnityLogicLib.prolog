:- set_prolog_flag(unknown,fail). % closed world assumption

:- op(497,fx,belief). % prefix for belief definition

:- op(498,xfy,&&). % operator used to logically separate events from conditions
:- op(499,xfy,=>). % operator used to logically separate conditions from actions

:- op(500,fx,act).  % prefix used to call an internal method
:- op(500,fx,cr).  % prefix used to start a coroutine

:- op(500,fx,@). % prefix used to specify a reference
    
%==================REFERENCE================%
set_ref(R) :- 
    retract(ref(_)),
    assert(ref(R))
    ;
    assert(ref(R)).

get_ref(Ref) :-
    ref(Ref) 
    ; 
    set_ref($this),
    ref(Ref).
    
init :- 
    set_ref($this).
    
%==================COROUTINES===============%
get_coroutine_task(A) :-
    (A = (@Ref,Name,Task), !,
        call_method(Ref,Name,Task))
    ;
    (A = (Name,Task), !,
        get_ref(Ref),
        call_method(Ref,Name,Task)).    

%==================ACT======================%
act A :-
    (A = (@Ref,M,Ret), !, 
        call_method(Ref,M,Ret))
    ;
    (A = (@Ref,M), !,
        call_method(Ref,M,Ret),
        Ret \= false)
    ;
    (A = (M,Ret), !,
        get_ref(Ref),
        call_method(Ref,M,Ret))
    ;
    (A = M, !,
        get_ref(Ref),
        call_method(Ref,M,Ret),
        Ret \= false).
    
%==================TASK=====================%   
extract_task(A) :-
    (A = [use_artifact(Ref,Action)|N], !,
        use_artifact(Ref,Action,Ret),
        append(Ret,N,Res),
        set_active_task(Res))
    ;
    (A = [cr (@Ref,M)|N], !,
        set_active_task((@Ref,M,N)))
    ;
    (A = [cr M|N], !,
        set_active_task((M,N)))
    ;
    (A = [M|N], !, 
        M, 
        set_active_task((N)))
    ;
    del_active_task.

set_active_task(A) :-  
    (A = (@Ref,Name,Cont), !, 
        del_active_task,
        get_coroutine_task((@Ref,Name,Task)),
        assert(/active_task/task:Task),
        assert(/active_task/cont:Cont))
    ;
    (A = (Name,Cont), !,
        del_active_task,
        get_coroutine_task((Name,Task)),
        assert(/active_task/task:Task),
        assert(/active_task/cont:Cont))
    ;
    (A = (Cont), !,
        del_active_task,
        assert(/active_task/task:null),
        assert(/active_task/cont:Cont)).
    
del_active_task :-
    assert(/active_task/task:null),
    assert(/active_task/cont:null).
    
task_completed :- 
    /active_task/cont:Cont,
    del_active_task,
    extract_task(Cont).
:- consult("UnityLogic/KBs/UnityLogicArtifact.prolog").
:- consult("UnityLogic/KBs/CommunicationLayer.prolog").

%==================ENTRY_POINT==============%  
go_on :-
    /active_task/task:Task,
    Task \= null,
    call_method(Task,'MoveNext'(),Ret), 
    (Ret = false, assert(/active_task/task:null) ; true).

go_on :-
    /active_task/cont:Cont,
    Cont \= null,
    task_completed.
    
go_on :-
    /active_task/plans:Plans,
    Plans = [H|T],
    assert(/active_task/plans:T),
    set_active_task(H).
    
stop :-
    assert(/active_task/plans:null).
    
%=============BELIEF==============================%
add_belief(B) :- 
    belief B 
    ; 
    assert(belief B).
    
del_belief(B) :-
    retract(belief B).
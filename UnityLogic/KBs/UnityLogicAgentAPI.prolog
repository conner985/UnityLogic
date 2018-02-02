:- consult("UnityLogic/KBs/UnityLogicAgent.prolog").
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
    
go_on :-
    desire D,
    add D && _ => _,
    findall(
        X,
        (add D && C => A, append([C],A,Temp), append(Temp,[del_desire(D)],X)),
        Plans
    ),
    assert(/active_task/plans:Plans).

stop :-
    assert(/active_task/plans:null).

%==================BELIEF==================%
check_belief(B) :-
    belief B.

add_belief(B) :-
    assert(belief B).
 
del_belief(B) :-
    retract(belief B).
    
%==================DESIRE=================%
check_desire(D) :-
    desire D.

add_desire(D) :-
    desire D 
    ; 
    assert(desire D).
    
del_desire(D) :-
    retract(desire D),
    (
        del D && C => A, !,
        C, 
        set_active_task(A) 
        ; 
        true
    ).
    
%==================PLAN==================%
check_plan(Head,Full) :-
    Head && C => A,
    Full = Head && C => A.
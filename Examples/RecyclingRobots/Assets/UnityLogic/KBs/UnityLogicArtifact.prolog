:- consult("UnityLogic/KBs/UnityLogicLib.prolog").

:- op(497,fx,plan). % operator used to define plans - i.e. what an user can use
    
%=============LEARN===============================%
learn_belief(B) :-
    belief B.
    
learnall_beliefs(B) :-
    findall(
        X,
        belief X, 
        B
        ).
        
%=============USE=================================%
activate(Name,Conditions) :-
    plan Name && C => A,
    (set_active_task(A), Conditions = C ; Conditions = false).
    
use(Name,Plan) :- 
    plan Name && C => A,
    append([C],A,Plan).
:- consult("UnityLogic/KBs/UnityLogicLib.prolog").

:- op(497,fx,desire). % prefix for desire definition

:- op(497,fx,add). % prefix for addition event of a desire
:- op(497,fx,del). % prefix for deletion event of a desire
    
%=================CONVERT==================%
convert_intention(Ref,Raw,Converted) :-
    maplist3(
        convert_action,
        Ref,
        Raw,
        Converted
    ).
    
convert_action(Action,Converted,Ref) :-
    Action = act (@R,M,Ret), !, Converted = Action
    ;
    Action = act (M,Ret), !, Converted = act (@Ref,M,Ret)
    ;
    Action = act M, !, Converted = act (@Ref,M)
    ;
    Action = cr (@R,M,Ret), !, Converted = Action
    ;
    Action = cr (M,Ret), !, Converted = cr (@Ref,M,Ret)
    ;
    Action = cr M, !, Converted = cr (@Ref,M)
    ;
    Converted = Action.
    
maplist3(_, _, [], []).
maplist3(Pred_3, Ref, [A|As], [B|Bs]) :-
    call(Pred_3, A, B, Ref),
    maplist3(Pred_3, Ref, As, Bs).
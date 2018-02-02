%===========CONVERSION===========%
ref_to_agent(Ref,Ag) :-
    Ref \= null,
    (
        is_class(Ref,$'UnityLogic.Agent'),      
        Ag is Ref 
        ;
        Ag is Ref.getcomponent($'UnityLogic.Agent')
    ),
    Ag \= null.
    
ref_to_artifact(Ref,Art) :-
    Ref \= null,
    (
        is_class(Ref,$'UnityLogic.Artifact'),        
        Art is Ref 
        ;
        Art is Ref.getcomponent($'UnityLogic.Artifact')
    ),
    Art \= null.
    
%============ARTIFACT=============%
learn_artifact_belief(Ref,B) :-
    ref_to_artifact(Ref,Art),
    call_method(Art,'CheckBelief'(B),Ret),
    Ret \= false,
    add_belief(B).
    
check_artifact_belief(Ref,B) :-
    ref_to_artifact(Ref,Art),
    call_method(Art,'CheckBelief'(B),Ret),
    Ret \= false.
    
add_artifact_belief(Ref,B) :-
    ref_to_artifact(Ref,Art),
    call_method(Art,'AddBelief'(B),Ret),
    Ret \= false.

del_artifact_belief(Ref,B) :-
    ref_to_artifact(Ref,Art),
    call_method(Art,'DelBelief'(B),Ret),
    Ret \= false.
    
activate_artifact(Ref,PlanName) :-
    ref_to_artifact(Ref,Art),
    call_method(Art,'Activate'(PlanName),Ret),
    Ret.
    
use_artifact(Ref,PlanName,Ret) :-
    ref_to_artifact(Ref,Art),
    call_method(Art,'Use'(PlanName),Ret),
    Ret \= false.
    
%============AGENT================%
learn_agent_belief(Ref,B) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'CheckBelief'(B),Ret),
    Ret \= false,
    add_belief(B).
    
check_agent_belief(Ref,B) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'CheckBelief'(B),Ret),
    Ret \= false.
    
add_agent_belief(Ref,B) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'AddBelief'(B),Ret),
    Ret \= false.
    
del_agent_belief(Ref,B) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'DelBelief'(B),Ret),
    Ret \= false.

learn_agent_desire(Ref,D) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'CheckDesire'(D),Ret),
    Ret \= false,
    add_desire(D).
    
check_agent_desire(Ref,D) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'CheckDesire'(D),Ret),
    Ret \= false.
    
add_agent_desire(Ref,D) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'AddDesire'(D),Ret),
    Ret \= false.
    
del_agent_desire(Ref,D) :-
    ref_to_agent(Ref,Ag),
    call_method(Ag,'DelDesire'(D),Ret),
    Ret \= false.
    
learn_agent_plan(Ref,Head,Raw) :-
    ref_to_agent(Ref,Ag),
    (Head = add _ ; Head = del _),
    call_method(Ag,'CheckPlan'(Head),Ret),
    Ret = Head && C => A,
    (Raw, !, assert(Ret) ; convert_plan(Ag,A,Converted), assert(Head && C => Converted)).
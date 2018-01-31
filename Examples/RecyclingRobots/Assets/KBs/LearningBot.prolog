:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

desire work.

add work && true =>[
    add_desire(recycle)
].

add recycle && (\+ belief hand(_)) => [
    act (searchGarbage,G),
    G \= false,
    (
        not(check_artifact_belief(G,busy)),
        add_artifact_belief(G,busy)
    ),
    cr goto(G),
    act pickup(G),
    add_belief(hand(G)),
    check_artifact_belief(G,type(Type)),
    check_plan(add recycle(Type),_),
    add_desire(recycle(Type)),
    stop
].

add recycle && (belief hand(G)) => [
    use_artifact(G,recycle),
    add_desire(work),
    stop
].

add recycle && (belief hand(G)) => [
    check_artifact_belief(G,type(Type)),
    act (findPlasticBot,Bot),
    act stopbot(Bot),
    cr goto(Bot),
    act resumebot(Bot),
    learn_agent_plan(Bot,add recycle(Type),true),
    add_desire(recycle(Type)),
    stop
].

add recycle && (belief hand(G)) => [
    act (findPaperBot,Bot),
    add_agent_desire(Bot,recycle(G))
].

add recycle && (belief hand(G)) => [
    act dropdown,
    del_belief(hand(_)),
    del_artifact_belief(G,busy),
    add_desire(work),
    stop
].
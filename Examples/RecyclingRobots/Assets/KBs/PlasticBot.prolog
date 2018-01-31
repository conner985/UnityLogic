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
    Type = plastic,
    add_desire(recycle(plastic)),
    stop
].

add recycle(plastic) && (belief hand(_)) => [
    act (searchBin("Plastic"),Bin),
    Bin \= false,
    cr goto(Bin),
    act recycle,
    del_belief(hand(_)),
    add_desire(work),
    stop
].

add recycle && (belief hand(G)) => [
    act dropdown,
    del_belief(hand(_)),
    del_artifact_belief(G,busy),
    add_desire(work),
    stop
].
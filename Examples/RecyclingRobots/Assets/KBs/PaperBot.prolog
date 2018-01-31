:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

add recycle(G) && (\+ belief hand(_)) => [
    (
        not(check_artifact_belief(G,busy)),
        add_artifact_belief(G,busy)
    ),
    check_artifact_belief(G,type(Type)),
    Type = paper,
    cr goto(G),
    act pickup(G),
    add_belief(hand(G)),
    act (searchBin("Paper"),Bin),
    Bin \= false,
    cr goto(Bin),
    act recycle,
    del_belief(hand(_))
].
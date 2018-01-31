:- consult("UnityLogic/KBs/UnityLogicArtifactAPI.prolog").

belief type(glass).

plan recycle && true => [
    act (searchBin("Glass"),Bin),
    Bin \= false,
    cr goto(Bin),
    act recycle,
    del_belief(hand(_))
].
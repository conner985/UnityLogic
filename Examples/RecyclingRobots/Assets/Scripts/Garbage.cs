using UnityLogic;

public class Garbage : Artifact
{
    public string type = "N.D.";

    public string kbPath = "KBs/prologfile";
    public string kbName = "kbName";

    void Start()
    {
        Init(kbPath, kbName);
    }
}

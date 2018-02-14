using UnityLogic;
using System.Collections;
using UnityEngine;
using UnityEngine.AI;
using TMPro;

public class Bot : Agent
{
    private NavMeshAgent nav;

    public string kbPath = "KBs/PrologFile";
    public string kbName = "KbName";

    public TextMeshProUGUI balloonText;
    public RectTransform canvas;

    void Start()
    {
        Init(kbPath, kbPath);
        nav = GetComponent<NavMeshAgent>();

    }

    bool CheckPlan(string type)
    {
        return true;
    }

    public object SearchGarbage()
    {
        Garbage[] g = FindObjectsOfType<Garbage>();
        if (g != null && g.Length > 0)
        {
            return g[Random.Range(0, g.Length)].gameObject;
        }
        return false;
    }

    public IEnumerator Goto(GameObject go)
    {
        nav.enabled = true;
        nav.isStopped = false;

        nav.SetDestination(go.transform.position);

        while (!nav.enabled || nav.pathPending)
        {
            yield return null;
        }

        while (!nav.enabled || nav.remainingDistance > 1.2f)
        {
            yield return null;
        }

        nav.isStopped = true;
        nav.enabled = false;
    }

    public void PickUp(GameObject go)
    {
        go.transform.SetParent(transform);
        go.gameObject.transform.localPosition = new Vector3(0, 0, 1);
    }

    public void DropDown()
    {
        Artifact go = GetComponentInChildren<Artifact>();
        if (go == null)
        {
            return;
        }
        go.gameObject.transform.parent = null;
        go.gameObject.transform.Translate(0, -0.5f, 0);
    }

    public void Recycle()
    {
        Artifact go = GetComponentInChildren<Artifact>();
        Destroy(go.gameObject);
    }

    public object SearchBin(string type)
    {
        switch (type.ToLower())
        {
            case "glass":
                return GameObject.Find("GlassBin");
            case "paper":
                return GameObject.Find("PaperBin");
            case "plastic":
                return GameObject.Find("PlasticBin");
            default:
                return false;
        }
    }

    public object FindPlasticBot()
    {
        Agent ag = GameObject.Find("PlasticBot").GetComponent<Agent>();
        if (ag != null || ag != this)
        {
            return ag.gameObject;
        }
        return false;
    }

    public object FindPaperBot()
    {
        Agent ag = GameObject.Find("PaperBot").GetComponent<Agent>();
        if (ag != null || ag != this)
        {
            return ag.gameObject;
        }
        return false;
    }

    public void StopBot(GameObject bot)
    {
        Bot b = bot.GetComponent<Bot>();
        if (b == null)
        {
            return;
        }

        b.nav.enabled = false;
    }

    public void ResumeBot(GameObject bot)
    {
        Bot b = bot.GetComponent<Bot>();
        if (b == null)
        {
            return;
        }

        b.nav.enabled = true;
        b.nav.isStopped = false;
    }

    public IEnumerator WriteOnBalloon(string text)
    {
        canvas.gameObject.SetActive(true);
        //float yRot = 42f - transform.rotation.y;
        //canvas.localRotation = new Quaternion(0, yRot, 0, 0);
        canvas.LookAt(transform.position - Camera.main.transform.position);
        balloonText.text = text;

        float start = Time.timeSinceLevelLoad;

        while (Time.timeSinceLevelLoad - start < 2f)
        {
            yield return null;
        }

        balloonText.text = "";
        canvas.gameObject.SetActive(false);
    }
}

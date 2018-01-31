using UnityEngine;
using Prolog;

namespace UnityLogic
{
    public abstract class Artifact : MonoBehaviour
    {
        protected KnowledgeBase myKB;

        protected void Init(string kbPath, string kbName)
        {
            myKB = new KnowledgeBase(kbName, gameObject);
            myKB.Consult(kbPath);
            myKB.IsTrue(new ISOPrologReader("init.").ReadTerm(), this);
        }

        public void LateUpdate()
        {
            myKB.IsTrue(new ISOPrologReader("go_on.").ReadTerm(), this);
        }

        public object Use(object action)
        {
            LogicVariable conditions = new LogicVariable("Conditions");

            try
            {
                myKB.SolveFor(conditions, new Structure("use", action, conditions), this);
            }
            catch (System.Exception ex)
            {
                return false;
            }

            return conditions;
        }

        public bool LearnBelief(ref object belief)
        {
            return myKB.IsTrue(new Structure("learn_belief", belief), this);            
        }

        public bool AddBelief(object belief)
        {
            return myKB.IsTrue(new Structure("add_belief", belief), this);
        }

        public bool DelBelief(object belief)
        {
            return myKB.IsTrue(new Structure("del_belief", belief), this);
        }
    }
}
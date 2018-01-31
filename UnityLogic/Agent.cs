using UnityEngine;
using Prolog;

namespace UnityLogic
{
    public abstract class Agent : MonoBehaviour
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

        public object CheckPlan(object head)
        {
            var full = new LogicVariable("Full");
            try
            {
                myKB.SolveFor(full, new Structure("check_plan", head, full), this);
            }
            catch (System.Exception ex)
            {
                return false;
            }

            return full;
        }

        #region BELIEFS

        public bool AddBelief(object belief)
        {
            return myKB.IsTrue(new ISOPrologReader("add_belief(" + belief + ").").ReadTerm(), this);
        }

        public bool DelBelief(object belief)
        {
            return myKB.IsTrue(new ISOPrologReader("del_belief(" + belief + ").").ReadTerm(), this);
        }

        #endregion

        #region DESIRES

        public bool AddDesire(object desire)
        {
            return myKB.IsTrue(new ISOPrologReader("add_desire(" + desire + ").").ReadTerm(), this);
        }

        public bool DelDesire(object desire)
        {
            return myKB.IsTrue(new ISOPrologReader("del_desire(" + desire + ").").ReadTerm(), this);
        }

        #endregion
    }
}
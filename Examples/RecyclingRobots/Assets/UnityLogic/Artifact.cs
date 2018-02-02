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

        public object Use(object name)
        {
            LogicVariable plan = new LogicVariable("Plan");

            try
            {
                myKB.SolveFor(plan, new Structure("use", name, plan), this);
            }
            catch (System.Exception ex)
            {
                return false;
            }

            return plan;
        }

        public object Activate(object name)
        {
            LogicVariable conditions = new LogicVariable("Conditions");

            try
            {
                myKB.SolveFor(conditions, new Structure("activate", name, conditions), this);
            }
            catch (System.Exception ex)
            {
                return false;
            }

            return conditions;
        }

        public bool CheckBelief(ref object belief)
        {
            return myKB.IsTrue(new Structure("check_belief", belief), this);            
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
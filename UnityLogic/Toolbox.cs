using System.Collections;
using UnityEngine;

namespace UnityLogic
{
    public static class Toolbox
    {
        public static IEnumerator WaitForSeconds(float sec)
        {
            float start = Time.time;

            while (Time.time - start < sec)
            {
                yield return null;
            }
        }
    }
}
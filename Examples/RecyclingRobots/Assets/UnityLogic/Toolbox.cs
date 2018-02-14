using System.Collections;
using UnityEngine;

namespace UnityLogic
{
    public static class Toolbox
    {
        public static IEnumerator WaitForSeconds(float sec)
        {
            float start = Time.timeSinceLevelLoad;

            while (Time.timeSinceLevelLoad - start < sec)
            {
                yield return null;
            }
        }
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Win : MonoBehaviour
{
    private Text gameWonText;
    public float delay = 2;
    private bool triggerSceneLoad = false;

    // Start is called before the first frame update
    void Start()
    {
        gameWonText = GameObject.Find("GameWonText").GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerEnter(Collider other)
    {
        Color color = gameWonText.color;
        color.a = 1.0f;
        gameWonText.color = color;
        Invoke("LoadLevelAfterDelay", delay);
    }

    void LoadLevelAfterDelay()
     {
         SceneManager.LoadScene("MyLevel");
     }
}

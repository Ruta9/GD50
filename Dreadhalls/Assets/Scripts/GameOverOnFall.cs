using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOverOnFall : MonoBehaviour
{
    private AudioSource whisperingSound;
    private GameController gameController;

    // Start is called before the first frame update
    void Start()
    {
        whisperingSound = DontDestroy.instance.GetComponents<AudioSource>()[0];
        gameController = GameObject.Find("GameController").GetComponent<GameController>().GetInstance();
    }

    // Update is called once per frame
    void Update()
    {
        if (gameObject.transform.position.y < -2) {
            whisperingSound.Pause();
            gameController.currentLevel = 1;
            SceneManager.LoadScene("Gameover");
        }
    }
}

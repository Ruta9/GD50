using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    private static GameController instance = null;

    public int currentLevel = 1;
    public Text levelText;

    public GameController GetInstance() {
        return instance;
    }

    public void incrementLevel() {
        if (levelText == null) LoadLevelText();

        currentLevel += 1;
        levelText.text = "level " + currentLevel;
    }

    void Awake()
    {
        if (instance == null){
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else if (instance != this){
            Destroy(this.gameObject);
        }
        instance.LoadLevelText();
    }

    void LoadLevelText() {
        levelText = GameObject.Find("LevelText").GetComponent<Text>();
        levelText.text = "level " + currentLevel;
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

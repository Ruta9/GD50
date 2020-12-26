﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadOtherScene : MonoBehaviour
{
    public string sceneName = "Title";

    // Start is called before the first frame update
    void Start()
    {
        
    }

	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			SceneManager.LoadScene(sceneName);
		}
	}
}

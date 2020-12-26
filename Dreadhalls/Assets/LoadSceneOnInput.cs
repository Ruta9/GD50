using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

	private AudioSource whisperingSound;
	// Use this for initialization
	void Start () {
		whisperingSound = DontDestroy.instance != null ? DontDestroy.instance.GetComponents<AudioSource>()[0] : null;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			if (whisperingSound != null) whisperingSound.Play();
			SceneManager.LoadScene("Play");
		}
	}
}

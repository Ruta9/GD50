using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	public GameController gameController;

	private AudioSource pickupSoundSource;

	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
		gameController = GameObject.Find("GameController").GetComponent<GameController>();
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Pickup") {
			pickupSoundSource.Play();
			gameController.GetInstance().incrementLevel();
			SceneManager.LoadScene("Play");
		}
	}
}

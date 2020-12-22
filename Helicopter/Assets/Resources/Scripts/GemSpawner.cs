using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour
{
    public GameObject[] prefabs;

    public float spawnChance = 0.3f;
    public float spawnRateInSeconds = 5;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SpawnGems());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    	IEnumerator SpawnGems() {
		while (true) {

			float prob = Random.Range(0.0f, 1.0f); 
            if (prob <= spawnChance){
			    Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
            }

			yield return new WaitForSeconds(spawnRateInSeconds);
		}
	}
}

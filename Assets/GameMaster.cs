using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameMaster : MonoBehaviour {

	public int maxSource;
	public Material environmentMaterial;

	void Awake(){
		environmentMaterial.SetFloat ("_ArrayLength", maxSource);
		environmentMaterial.SetFloatArray ("_RadiusArray", new float[maxSource]);
		environmentMaterial.SetVectorArray ("_CenterArray", new Vector4[maxSource]);
	}

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyUp (KeyCode.L)) {
			for (int i = 0; i < maxSource; i++) {
				Debug.Log(environmentMaterial.GetFloatArray("_RadiusArray")[i]);
			}
			Debug.Log ("------------------");
		}

	}
}

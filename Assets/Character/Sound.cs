using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sound : MonoBehaviour {

	private const string RADIUSARRAY = "_RadiusArray";
	private const string CENTERARRAY = "_CenterArray";
	private const string STRENGTHARRAY = "_RadiusStrength";

	public Material soundMaterial;

	public float amplitude;
	public float strength;

	private int soundNumber = 0;

	void Start () {
		float[] _RadiusArray = soundMaterial.GetFloatArray (RADIUSARRAY);
		Vector4[] _CenterArray = soundMaterial.GetVectorArray (CENTERARRAY);

		for (int i = _RadiusArray.Length-1; i>=0; i--) {
			if (_RadiusArray [i] == 0) {
				soundNumber = i;
			}
		}
		_CenterArray [soundNumber] = this.transform.position;
		_RadiusArray [soundNumber] = 0.01f;
		soundMaterial.SetFloatArray (RADIUSARRAY, _RadiusArray);
		soundMaterial.SetVectorArray (CENTERARRAY, _CenterArray);
	}

	void Update() {
		float[] _RadiusArray = soundMaterial.GetFloatArray (RADIUSARRAY);
		float x = this.transform.localScale.x + ((amplitude / 1000)*strength);
		if (x > strength) {
			x = 0;
		}
		this.transform.localScale = new Vector3(x,1,1);

		_RadiusArray [soundNumber] = x;
		soundMaterial.SetFloatArray (RADIUSARRAY, _RadiusArray);

		if (x == 0) {
			Destroy (this.gameObject);
		}
	}
}
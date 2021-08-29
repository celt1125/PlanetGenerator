using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class NoiseSetting
{
	[Header("General multiplier")]
	public float multiplier = 0.1f;
	
	[Header("Land settings")]
	public int layers = 4;
	public float frequency = 1.84f;
	public float amplitude = 1f;
	public float lacunarity = 2.46f;
	public float persistence = 0.31f;
	public float land_multiplier = 1.14f;
	
	[Header("Ocean settings")]
	public float ocean_depth = 0.59f;
	public float ocean_multiplier = 0.35f;
	public float ocean_smoothness = 0.44f;
	
	[Header("Ridged noise")]
	public int ridged_layers = 4;
	public float ridged_frequency = 0.46f;
	public float ridged_amplitude = 0.78f;
	public float ridged_lacunarity = 2.62f;
	public float ridged_persistence = 1.27f;
	public float ridged_power = 4.02f;
	public float ridged_gain = 1.01f;
	public float ridged_smoothness = 1.28f;
}	
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshNoise3D : MonoBehaviour
{
	private const int thread_group_size = 512;
	
	public ComputeShader noise_compute;
	
	public NoiseSetting settings;
	
	public (Vector3[], Vector2) AddNoise3D(Vector3[] vertices){
		int vertices_num = vertices.Length;
		
		ComputeBuffer vertices_buffer = new ComputeBuffer(vertices_num, sizeof(float) * 3);
		ComputeBuffer noise_buffer = new ComputeBuffer(vertices_num, sizeof(float));
		float[] noise = new float[vertices_num];
		vertices_buffer.SetData(vertices);
		noise_buffer.SetData(noise);
		
		noise_compute.SetBuffer(0, "vertices", vertices_buffer);
		noise_compute.SetBuffer(0, "noise", noise_buffer);
		noise_compute.SetInt("vertices_num", vertices_num);
		noise_compute.SetFloat("multiplier", settings.multiplier);
		
		noise_compute.SetInt("layers", settings.layers);
		noise_compute.SetVector("parameters", new Vector4(settings.frequency, settings.amplitude, settings.lacunarity, settings.persistence));
		noise_compute.SetFloat("land_multiplier", settings.land_multiplier);
		
		noise_compute.SetFloat("ocean_depth", settings.ocean_depth);
		noise_compute.SetFloat("ocean_multiplier", settings.ocean_multiplier);
		noise_compute.SetFloat("ocean_smoothness", settings.ocean_smoothness);
		
		noise_compute.SetInt("ridged_layers", settings.ridged_layers);
		noise_compute.SetVector("ridged_parameters", new Vector4(settings.ridged_frequency, settings.ridged_amplitude,
																settings.ridged_lacunarity, settings.ridged_persistence));
		noise_compute.SetVector("ridged_parameters2", new Vector4(settings.ridged_power, settings.ridged_gain, settings.ridged_smoothness, 0f));
		
		int thread_group_num = Mathf.CeilToInt((float)vertices_num / thread_group_size);
		noise_compute.Dispatch (0, thread_group_num, 1, 1);
		noise_buffer.GetData(noise);
		
		Vector3[] res = new Vector3[vertices_num];
		Vector2 min_max = new Vector2(10000, -10000);
		float radius = vertices[0].magnitude;
		for (int i = 0; i < vertices_num; i++){
			//if (vertices[i].y < -0.9f)
			//	Debug.Log($"{vertices[i]}, {noise[i]}");
			res[i] = vertices[i] * noise[i];
			min_max.x = min_max.x > noise[i] ? noise[i] : min_max.x;
			min_max.y = min_max.y > noise[i] ? min_max.y : noise[i];
		}
		min_max.x *= radius;
		min_max.y *= radius;
		
		vertices_buffer.Release();
		noise_buffer.Release();
		return (res, min_max);
	}
}
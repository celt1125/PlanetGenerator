using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

[ExecuteInEditMode]
public class MeshChanger : MonoBehaviour
{
    public enum ShapeType{Sphere, Pyramid}
	public ShapeType shape_type;
	public float size;
	public float radius;
	public int divisions;
	public Material material;
	public Gradient gradient;
	
	private Mesh mesh;
	private MeshData initial_mesh;
	private MeshNoise3D mesh_noise_3D;
	private Vector2 min_max;
	private Texture2D texture;
	private int texture_resolution = 50;
	
    // Use this for initialization
    void Start()
    {
		mesh_noise_3D = FindObjectOfType<MeshNoise3D>();
		
		if (GetComponent<MeshFilter>() == null){
			gameObject.AddComponent<MeshFilter>();
			gameObject.AddComponent<MeshRenderer>();
		}
		mesh = GetComponent<MeshFilter>().sharedMesh;
		GetComponent<MeshRenderer>().material = material;
		mesh.Clear();

		if (shape_type == ShapeType.Sphere){
			initial_mesh = MeshManager.GenerateSphereMesh(divisions, radius);
			min_max = new Vector2(radius, radius);
			texture = new Texture2D(texture_resolution, 1);
			SetMesh();
			Vector3[] v;
			(v, min_max) = mesh_noise_3D.AddNoise3D(initial_mesh.vertices.items);
			mesh.SetVertices(v);
			mesh.RecalculateNormals();
			SetMaterial();
		}
		else if (shape_type == ShapeType.Pyramid){
			initial_mesh = MeshManager.GeneratePyramidMesh(size);
			SetMesh();
		}
		
		//mesh.RecalculateBounds();
    }
	
	void Update(){
		if (initial_mesh == null){
			initial_mesh = MeshManager.GenerateSphereMesh(divisions, radius);
			SetMesh();
		}
		Vector3[] v;
		(v, min_max) = mesh_noise_3D.AddNoise3D(initial_mesh.vertices.items);
		mesh.SetVertices(v);
		mesh.RecalculateNormals();
		SetMaterial();
	}
	
	private void SetMesh(){
		const int vertex_limit_16 = 1 << 16 - 1; // 65535
		mesh.indexFormat = (initial_mesh.vertices.items.Length < vertex_limit_16) ?
					UnityEngine.Rendering.IndexFormat.UInt16 : UnityEngine.Rendering.IndexFormat.UInt32;
		mesh.SetVertices(initial_mesh.vertices.items);
		mesh.SetTriangles(initial_mesh.triangles.items, 0, true);
	}
	
	private void SetMaterial(){
		material.SetVector("MinMax", new Vector4(min_max.x, min_max.y));
		Color[] colors = new Color[texture_resolution];
		for (int i = 0; i < texture_resolution; i++){
			colors[i] = gradient.Evaluate(i / (texture_resolution - 1f));
		}
		texture.SetPixels(colors);
		texture.Apply();
		material.SetTexture("HeightTexture", texture);
	}
}

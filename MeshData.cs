using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MeshData
{
    public List<Vector3> vertices; // The vertices of the mesh 
    public List<int> triangles; // Indices of vertices that make up the mesh faces
    public Vector3[] normals; // The normals of the mesh, one per vertex

    // Class initializer
    public MeshData()
    {
        vertices = new List<Vector3>();
        triangles = new List<int>();
    }

    // Returns a Unity Mesh of this MeshData that can be rendered
    public Mesh ToUnityMesh()
    {
        Mesh mesh = new Mesh
        {
            vertices = vertices.ToArray(),
            triangles = triangles.ToArray(),
            normals = normals
        };

        return mesh;
    }

    public void CalculateNormals()
    {
        // Your implementation
        List<Vector3> normalsList = new List<Vector3>();
        List<Vector3>[] verticeNormals = new List<Vector3>[vertices.Count];
        for (int i = 0; i < triangles.Count; i+=3)
        {
            int a_i = triangles[i];
            int b_i = triangles[i + 1];
            int c_i = triangles[i + 2];
            Vector3 a = vertices[a_i];
            Vector3 b = vertices[b_i];
            Vector3 c = vertices[c_i];
            var a_c = a - c;
            var a_b = a - b;
            var norm = Vector3.Cross(a_c, a_b).normalized;

            int[] indices = new int[3]{ a_i, b_i, c_i };

            foreach (int ind in indices)
            {
                if (verticeNormals[ind] == null)
                {
                    verticeNormals[ind] = new List<Vector3>() { norm };
                }
                else
                {
                    verticeNormals[ind].Add(norm);
                }
            }
        }

        foreach(var normList in verticeNormals)
        {
            Vector3 sum = Vector3.zero;
            foreach (var vec in normList)
            {
                sum += vec;
            }
            Vector3 avg = normList.Count > 0 ? sum / normList.Count : sum;

            normalsList.Add(avg);
        }
        normals = normalsList.ToArray();
    }

    // Calculates surface normals for each vertex, according to face orientation


    // Edits mesh such that each face has a unique set of 3 vertices
    public void MakeFlatShaded()
    {
        // Your implementation
    }
}
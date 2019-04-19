using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

public class LUTCustomEditor : EditorWindow
{
    static Texture2D lutTex = new Texture2D(0, 0, TextureFormat.ARGB32, false);
    static string texName = "LUT";
    static string texDestination = "Textures/LUT";
    static List<Gradient> gradients = new List<Gradient>();
    static Vector2Int dimensions = new Vector2Int(256, 1);

    [MenuItem("Window/LUT Generator")]
    static void MenuItem()
    {
        GetWindow<LUTCustomEditor>(true, "LUT Generator", true);
    }

    void OnGUI()
    {
        DrawPanel();
    }

    void DrawPanel()
    {
        if (GUILayout.Button("Export LUT"))
        {
            ExportGradientsToPNG();
        }

        texName = EditorGUILayout.TextField("Texture name:", texName);
        texDestination = EditorGUILayout.TextField("Texture Destination:", texDestination);
        dimensions = EditorGUILayout.Vector2IntField("LUT Width/Height", dimensions);

        EditorGUILayout.Separator();

        if (dimensions.y < 0)
            dimensions.y = 0;

        int diff = dimensions.y - gradients.Count;

        // Add new Gradients on resize up
        if (diff > 0)
        {
            for (int i = 0; i < diff; ++i)
            {
                gradients.Add(new Gradient());
            }
        }
        // Remove old Gradients on resize down
        // else if (diff < 0)
        // {
        //     gradients.RemoveRange((gradients.Count)-Mathf.Abs(diff), Mathf.Abs(diff));
        // }

        for (int i = 0; i < dimensions.y; ++i)
        {
            gradients[i] = EditorGUILayout.GradientField(gradients[i]);
        }
    }

    void ExportGradientsToPNG()
    {
        Texture2D tex2D = new Texture2D(dimensions.x, dimensions.y, TextureFormat.ARGB32, false);

        for (int y = 0; y < dimensions.y; ++y)
        {
            for (int x = 0; x < dimensions.x; ++x)
            {
                tex2D.SetPixel(x, (dimensions.y - 1) - y, gradients[y].Evaluate(x / (float)dimensions.x));
            }
        }

        string path = Path.Combine("Assets", texDestination, texName + ".png");

        // Create directories if needed
        new FileInfo(path).Directory.Create();

        File.WriteAllBytes(path, tex2D.EncodeToPNG());

        AssetDatabase.Refresh();
    }
}
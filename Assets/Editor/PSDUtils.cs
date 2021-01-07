using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using System.Security.Cryptography;
using System.Text;
using System;

class PSDUtils
{
    static Dictionary<String, String> md5Dictionary = null;
    public static string GetMd5FromFileArray(string fileArrayPath, string key)
    {
        if (md5Dictionary == null)
        {
            if (fileArrayPath != null)
            {
                try
                {
                    StreamReader jsonReader = File.OpenText(fileArrayPath);
                    if (jsonReader != null)
                    {
                        string jsonStr = jsonReader.ReadToEnd();
                        md5Dictionary = JsonUtility.FromJson<Serialization<string, string>>(jsonStr).ToDictionary();
                    }
                    else
                    {
                        md5Dictionary = new Dictionary<string, string>();
                    }
                    jsonReader.Close();
                }
                catch (Exception ex)
                {
                    Debug.Log(ex.Message);
                    md5Dictionary = new Dictionary<string, string>();
                }

            }
        }
        if (md5Dictionary.ContainsKey(key))
        {
            return md5Dictionary[key];
        }
        return "";
    }

    public static void SaveMd5FromFileArray(string fileArrayPath, string key, string value)
    {
        if (md5Dictionary == null)
        {
            if (fileArrayPath != null)
            {
                StreamReader jsonReader = File.OpenText(fileArrayPath);
                if (jsonReader != null)
                {
                    string jsonStr = jsonReader.ReadToEnd();
                    md5Dictionary = JsonUtility.FromJson<Dictionary<String, String>>(jsonStr);
                }
                else
                {
                    md5Dictionary = new Dictionary<String, String>();
                }
            }
        }
        md5Dictionary.Add(key, value);
        string json = JsonUtility.ToJson(new Serialization<string, string>(md5Dictionary), true);
        // string json = JsonUtility.ToJson(md5Dictionary, true);
        File.WriteAllText(fileArrayPath, json, Encoding.UTF8);
    }

    //获取字符串的MD5码
    public static string CreateMD5Hash(string input)
    {
        // Use input string to calculate MD5 hash
        MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
        byte[] hashBytes = md5.ComputeHash(inputBytes);

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < hashBytes.Length; i++)
        {
            sb.Append(hashBytes[i].ToString("X2"));
        }
        return sb.ToString();
    }

    // 获取文件的md5
    public static string GetMD5HashFromFile(string fileName)
    {
        try
        {
            FileStream file = new FileStream(fileName, System.IO.FileMode.Open);
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(file);
            file.Close();
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("GetMD5HashFromFile() fail,error:" + ex.Message);
        }
    }

    [Serializable]
    public class Serialization<TKey, TValue> : ISerializationCallbackReceiver
    {
        [SerializeField]
        List<TKey> keys;
        [SerializeField]
        List<TValue> values;

        Dictionary<TKey, TValue> target;
        public Dictionary<TKey, TValue> ToDictionary() { return target; }

        public Serialization(Dictionary<TKey, TValue> target)
        {
            this.target = target;
        }

        public void OnBeforeSerialize()
        {
            keys = new List<TKey>(target.Keys);
            values = new List<TValue>(target.Values);
        }

        public void OnAfterDeserialize()
        {
            var count = Math.Min(keys.Count, values.Count);
            target = new Dictionary<TKey, TValue>(count);
            for (var i = 0; i < count; ++i)
            {
                target.Add(keys[i], values[i]);
            }
        }
    }

}
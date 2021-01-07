using System;
using UnityEngine;
using UnityEngine.UI;

[Serializable]//序列化
public class Person
{
    public string name;
    public int age;
}

[Serializable]//序列化
public class Persons
{
    public Person[] persons;
}

public class JsonUtilityDemo : MonoBehaviour {

    void Start () {
       // 创建Json
        Person p1 = new Person();
        p1.name = "李逍遥";
        p1.age = 25;
        string jsonStr = JsonUtility.ToJson(p1);
        Debug.Log(jsonStr);

        Person p2 = new Person();
        p2.name = "王小虎";
        p2.age = 7;
        
        Person[] ps = new Person[] { p1, p2 };

        Persons persons = new Persons();
        persons.persons = ps;
        jsonStr = JsonUtility.ToJson(persons);
        //jsonStr = "{ 'persons':[{'name':'李逍遥','age':25},{'name':'王小虎','age':7}]}";
        Debug.Log(jsonStr);

        //解析Json
        Persons newPersons = JsonUtility.FromJson<Persons>(jsonStr);
        Debug.Log(newPersons.persons[0].name);

    }
    
}
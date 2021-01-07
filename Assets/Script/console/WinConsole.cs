using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WinConsole : MonoBehaviour
{
    private ConsoleSwitch _consoleSwitch;

    void Awake()
    {
        _consoleSwitch = new ConsoleSwitch();
        _consoleSwitch.Awake();
    }

    void Start()
    {
        
    }

    void Update()
    {
        if (_consoleSwitch != null)
        {
            _consoleSwitch.Update();
        }
    }

    void OnDestroy()
    {
        if (_consoleSwitch != null)
        {
            _consoleSwitch.CloseConsoleWindow();
        }
    }
}

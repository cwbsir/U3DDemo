#define USING_CONSOLE
using UnityEngine;
using System.Collections;

public class ConsoleSwitch
{
    #if USING_CONSOLE

    private ConsoleWindow console = null;
    private ConsoleInput input = null;

    private static bool isShowWindow = false;
    private bool oldWindowState = false;

    //create console window,register callbacks
    public void Awake()
    {
        SetDefaultOpen();
        Debug.Log("Console Started");
    }

    void SetDefaultOpen()
    {
        isShowWindow = true;
        if(isShowWindow)
        {
            initConsoleWindow();
        }
    }

    void initConsoleWindow()
    {
        console = new ConsoleWindow();
        input = new ConsoleInput();
        console.Initialize();
        console.SetTitle("Test command");
        input.OnInputText += OnInputText;
        Application.logMessageReceived += HandleLog;
    }

    //Text has been entered into the console
    //Run it as a console command
    void OnInputText(string obj)
    {
        int subLen = obj.IndexOf(' ');
        if(subLen < 0)return;
    }

    //Debug.Log* callback
    void HandleLog(string message, string stackTrace,LogType type)
    {
        if (type == LogType.Warning)
            System.Console.ForegroundColor = System.ConsoleColor.Yellow;
        else if (type == LogType.Error)
            System.Console.ForegroundColor = System.ConsoleColor.Red;
        else
            System.Console.ForegroundColor = System.ConsoleColor.White;

        if (System.Console.CursorLeft != 0)
            input.ClearLine();

        System.Console.WriteLine(message);

        input.RedrawInputLine();
    }

    public void Update()
    {
        if(Input.GetKeyDown(KeyCode.Tab) || Input.GetKeyDown(KeyCode.BackQuote))
        {
            isShowWindow = !isShowWindow;
            if(isShowWindow)
            {
                initConsoleWindow();
            }
            else
            {
                CloseConsoleWindow();
            }
            oldWindowState = isShowWindow;
        }

        //input update
        if (isShowWindow && input != null)
        {
            input.Update();
        }

        if (isShowWindow != oldWindowState && !isShowWindow)
        {
            CloseConsoleWindow();
        }
        oldWindowState = isShowWindow;
    }

    void OnDestroy()
    {
        CloseConsoleWindow();
    }

    public void CloseConsoleWindow()
    {
        if(console != null)
        {
            Application.logMessageReceived -= HandleLog;
            console.Shutdown();
            console = null;
            input = null;
        }
    }

    public static void SetIshowWindow(bool flag)
    {
        isShowWindow = flag;
    }

    #endif
}

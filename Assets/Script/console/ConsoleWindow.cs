using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices;
using System.IO;

// Creates a console window that actually works in Unity
// You should add a script that redirects output using Console.Write to write to it.
public class ConsoleWindow
{
	TextWriter oldOutput;

	public void Initialize()
	{
        // Attach to any existing consoles we have
        // failing that, create a new one.
        if (!AttachConsole(0x0ffffffff))
        {
            AllocConsole();
        }

        oldOutput = Console.Out;

        try
        {
            IntPtr stdHandle = GetStdHandle(STD_OUTPUT_HANDLE);
            Microsoft.Win32.SafeHandles.SafeFileHandle safeFileHandle = new Microsoft.Win32.SafeHandles.SafeFileHandle(stdHandle, true);
            FileStream fileStream = new FileStream(safeFileHandle, FileAccess.Write);
            System.Text.Encoding encoding = System.Text.Encoding.GetEncoding("GB2312");//System.Text.Encoding.ASCII;
            StreamWriter standardOutput = new StreamWriter(fileStream, encoding);
            standardOutput.AutoFlush = true;
            Console.SetOut(standardOutput);

	        //找关闭按钮
	        IntPtr CMD = GetConsoleWindow();
	        IntPtr CLOSE_MENU = GetSystemMenu(CMD, IntPtr.Zero);

	        int SC_CLOSE = 0xF060;
	        // //关闭按钮禁用
	        RemoveMenu(CLOSE_MENU, SC_CLOSE, 0x0);
        }
        catch (System.Exception e)
        {
            Debug.Log("Couldn't redirect output:" + e.Message);
        }

    }

	public void Shutdown()
	{
		Console.SetOut(oldOutput);
		FreeConsole();
	}

	public void SetTitle(string strName)
	{
		SetConsoleTitle(strName);
	}

	private const int STD_OUTPUT_HANDLE = -11;

	[DllImport("kernel32.dll",SetLastError = true)]
	static extern bool AttachConsole(uint dwProcessId);

	[DllImport("kernel32.dll",SetLastError = true)]
	static extern bool AllocConsole();

	[DllImport("kernel32.dll",SetLastError = true)]
	static extern bool FreeConsole();

	[DllImport("kernel32.dll",EntryPoint = "GetStdHandle",SetLastError = true,CharSet = CharSet.Auto,CallingConvention = CallingConvention.StdCall)]
	private static extern IntPtr GetStdHandle(int nStdHandle);

	[DllImport("kernel32.dll")]
	static extern bool SetConsoleTitle(string lpConsoleTitle);

	[DllImport("kernel32.dll",SetLastError = true)]
    extern static IntPtr GetSystemMenu(IntPtr hWnd, IntPtr bRevert);

	[DllImport("kernel32.dll",SetLastError = true)]
    extern static int RemoveMenu(IntPtr hMenu, int nPos, int flags);

	[DllImport("kernel32.dll",SetLastError = true)]
    extern static IntPtr GetConsoleWindow();




}

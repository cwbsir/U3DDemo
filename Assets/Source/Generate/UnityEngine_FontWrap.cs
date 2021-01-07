﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UnityEngine_FontWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UnityEngine.Font), typeof(UnityEngine.Object));
		L.RegFunction("CreateDynamicFontFromOSFont", CreateDynamicFontFromOSFont);
		L.RegFunction("GetMaxVertsForString", GetMaxVertsForString);
		L.RegFunction("HasCharacter", HasCharacter);
		L.RegFunction("GetOSInstalledFontNames", GetOSInstalledFontNames);
		L.RegFunction("GetCharacterInfo", GetCharacterInfo);
		L.RegFunction("RequestCharactersInTexture", RequestCharactersInTexture);
		L.RegFunction("New", _CreateUnityEngine_Font);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("material", get_material, set_material);
		L.RegVar("fontNames", get_fontNames, set_fontNames);
		L.RegVar("dynamic", get_dynamic, null);
		L.RegVar("ascent", get_ascent, null);
		L.RegVar("fontSize", get_fontSize, null);
		L.RegVar("characterInfo", get_characterInfo, set_characterInfo);
		L.RegVar("lineHeight", get_lineHeight, null);
		L.RegVar("textureRebuilt", get_textureRebuilt, set_textureRebuilt);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUnityEngine_Font(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				UnityEngine.Font obj = new UnityEngine.Font();
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else if (count == 1)
			{
				string arg0 = ToLua.CheckString(L, 1);
				UnityEngine.Font obj = new UnityEngine.Font(arg0);
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UnityEngine.Font.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateDynamicFontFromOSFont(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<string, int>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
				UnityEngine.Font o = UnityEngine.Font.CreateDynamicFontFromOSFont(arg0, arg1);
				ToLua.PushSealed(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string[], int>(L, 1))
			{
				string[] arg0 = ToLua.ToStringArray(L, 1);
				int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
				UnityEngine.Font o = UnityEngine.Font.CreateDynamicFontFromOSFont(arg0, arg1);
				ToLua.PushSealed(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: UnityEngine.Font.CreateDynamicFontFromOSFont");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetMaxVertsForString(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			int o = UnityEngine.Font.GetMaxVertsForString(arg0);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int HasCharacter(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
			char arg0 = (char)LuaDLL.luaL_checknumber(L, 2);
			bool o = obj.HasCharacter(arg0);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOSInstalledFontNames(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string[] o = UnityEngine.Font.GetOSInstalledFontNames();
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetCharacterInfo(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 3)
			{
				UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
				char arg0 = (char)LuaDLL.luaL_checknumber(L, 2);
				UnityEngine.CharacterInfo arg1;
				bool o = obj.GetCharacterInfo(arg0, out arg1);
				LuaDLL.lua_pushboolean(L, o);
				ToLua.PushValue(L, arg1);
				return 2;
			}
			else if (count == 4)
			{
				UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
				char arg0 = (char)LuaDLL.luaL_checknumber(L, 2);
				UnityEngine.CharacterInfo arg1;
				int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
				bool o = obj.GetCharacterInfo(arg0, out arg1, arg2);
				LuaDLL.lua_pushboolean(L, o);
				ToLua.PushValue(L, arg1);
				return 2;
			}
			else if (count == 5)
			{
				UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
				char arg0 = (char)LuaDLL.luaL_checknumber(L, 2);
				UnityEngine.CharacterInfo arg1;
				int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
				UnityEngine.FontStyle arg3 = (UnityEngine.FontStyle)ToLua.CheckObject(L, 5, typeof(UnityEngine.FontStyle));
				bool o = obj.GetCharacterInfo(arg0, out arg1, arg2, arg3);
				LuaDLL.lua_pushboolean(L, o);
				ToLua.PushValue(L, arg1);
				return 2;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: UnityEngine.Font.GetCharacterInfo");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RequestCharactersInTexture(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
				string arg0 = ToLua.CheckString(L, 2);
				obj.RequestCharactersInTexture(arg0);
				return 0;
			}
			else if (count == 3)
			{
				UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
				string arg0 = ToLua.CheckString(L, 2);
				int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
				obj.RequestCharactersInTexture(arg0, arg1);
				return 0;
			}
			else if (count == 4)
			{
				UnityEngine.Font obj = (UnityEngine.Font)ToLua.CheckObject(L, 1, typeof(UnityEngine.Font));
				string arg0 = ToLua.CheckString(L, 2);
				int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
				UnityEngine.FontStyle arg2 = (UnityEngine.FontStyle)ToLua.CheckObject(L, 4, typeof(UnityEngine.FontStyle));
				obj.RequestCharactersInTexture(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: UnityEngine.Font.RequestCharactersInTexture");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_material(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			UnityEngine.Material ret = obj.material;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index material on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fontNames(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			string[] ret = obj.fontNames;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fontNames on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_dynamic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			bool ret = obj.dynamic;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index dynamic on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ascent(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			int ret = obj.ascent;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ascent on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fontSize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			int ret = obj.fontSize;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fontSize on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_characterInfo(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			UnityEngine.CharacterInfo[] ret = obj.characterInfo;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index characterInfo on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lineHeight(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			int ret = obj.lineHeight;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index lineHeight on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_textureRebuilt(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action<UnityEngine.Font>)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_material(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			UnityEngine.Material arg0 = (UnityEngine.Material)ToLua.CheckObject<UnityEngine.Material>(L, 2);
			obj.material = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index material on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fontNames(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			string[] arg0 = ToLua.CheckStringArray(L, 2);
			obj.fontNames = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fontNames on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_characterInfo(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.Font obj = (UnityEngine.Font)o;
			UnityEngine.CharacterInfo[] arg0 = ToLua.CheckStructArray<UnityEngine.CharacterInfo>(L, 2);
			obj.characterInfo = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index characterInfo on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_textureRebuilt(IntPtr L)
	{
		try
		{
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'UnityEngine.Font.textureRebuilt' can only appear on the left hand side of += or -= when used outside of the type 'UnityEngine.Font'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action<UnityEngine.Font> ev = (System.Action<UnityEngine.Font>)arg0.func;
				UnityEngine.Font.textureRebuilt += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action<UnityEngine.Font> ev = (System.Action<UnityEngine.Font>)arg0.func;
				UnityEngine.Font.textureRebuilt -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}


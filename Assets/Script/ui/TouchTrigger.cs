using LuaInterface;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class TouchTrigger : MonoBehaviour, IPointerUpHandler,IPointerDownHandler,IPointerClickHandler
{
    private bool _isHasClick = false;
    private PointerEventData _lastEventData;

    protected LuaFunction _doubleClick = null;  
    protected LuaFunction _clickCB;
    protected LuaFunction _downCB;
    protected LuaFunction _upCB;
    protected bool _touchEnabled = true;
    protected System.Object _target;
    protected int _paramStyle = 0;//默认为0，不传参，1回调x,y，2否则回调eventData
    protected bool _isSwallow = true;//是否吞噬点击事件

    public void setLuaCallback(LuaFunction clickCB,System.Object args,LuaFunction downCB = null,LuaFunction upCB = null)
    {
        _clickCB = clickCB;
        _downCB = downCB;
        _upCB = upCB;
        _target = args;
    }

    public void setLuaDoubleClick(LuaFunction doubleClick, System.Object args)
    {
        _target = args;
        _doubleClick = doubleClick;
    }

    public void setParamStyle(int v)
    {
        _paramStyle = v;
    }

    public void setIsSwallow(bool v)
    {
        _isSwallow = v;
    }

    public void setTouchEnabled(bool v)
    {
        _touchEnabled = v;
    }

    private void clickHandler()
    {
        _isHasClick = false;
        singleClick(_lastEventData);
        _lastEventData = null;
    }

    private void singleClick(PointerEventData eventData)
    {
        if (_touchEnabled && _clickCB != null)
        {
            if (_paramStyle == 0)
                _clickCB.Call(1, _target);
            else if (_paramStyle == 1)
                _clickCB.Call(1, _target, eventData.position.x, eventData.position.y);
            else
                _clickCB.Call(1, _target, eventData);
        }

        if (!_isSwallow)
        {
            PassEvent(eventData, ExecuteEvents.pointerClickHandler);
        }
    }

    private void doubleClick(PointerEventData eventData)
    {
        if (_touchEnabled && _doubleClick != null)
        {
            if (_paramStyle == 0)
                _doubleClick.Call(1, _target);
            else if (_paramStyle == 1)
                _doubleClick.Call(1, _target, eventData.position.x, eventData.position.y);
            else
                _doubleClick.Call(1, _target, eventData);
        }

        if (!_isSwallow)
        {
            PassEvent(eventData, ExecuteEvents.pointerClickHandler);
        }
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if(_touchEnabled)
        {
            if (_doubleClick == null)
            {
                singleClick(eventData);
                return;
            }
            _lastEventData = eventData;
            if (_isHasClick)
            {
                
                CancelInvoke("clickHandler");
                _isHasClick = false;
                doubleClick(eventData);
            }
            else
            {
                _isHasClick = true;
                Invoke("clickHandler", 0.25F);
            }
        }

        //if (_touchEnabled && _clickCB != null)
        //{
        //    if(_paramStyle == 0)
        //        _clickCB.Call(1,_target);
        //    else if(_paramStyle == 1)
        //        _clickCB.Call(1,_target,eventData.position.x,eventData.position.y);
        //    else
        //        _clickCB.Call(1,_target,eventData);
        //}

        //if(!_isSwallow)
        //{
        //    PassEvent(eventData, ExecuteEvents.pointerClickHandler);
        //}
    }

    private void PassEvent<T>(PointerEventData data, ExecuteEvents.EventFunction<T> function) where T : IEventSystemHandler
    {
        var results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(data, results);
        var current = data.pointerCurrentRaycast.gameObject;
        for (int i = 0; i < results.Count; i++)
        {
            if (current != results[i].gameObject)
            {
                ExecuteEvents.Execute(results[i].gameObject, data, function);
                return;
            }
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (_touchEnabled && _downCB != null)
        {
            if(_paramStyle == 0)
                _downCB.Call(1,_target);
            else if(_paramStyle == 1)
                _downCB.Call(1,_target,eventData.position.x,eventData.position.y);
            else
                _downCB.Call(1,_target,eventData);

        }
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if(_touchEnabled && _upCB != null)
        {
            if(_paramStyle == 0)
                _upCB.Call(1,_target);
            else if(_paramStyle == 1)
                _upCB.Call(1,_target,eventData.position.x,eventData.position.y);
            else
                _upCB.Call(1,_target,eventData);
        }
    }

    public void OnDestory()
    {
        _clickCB = null;
        _downCB = null;
        _upCB = null;
        _target = null;
        _doubleClick = null;
        _isHasClick = false;
        _lastEventData = null;
        CancelInvoke("clickHandler");
    }
}

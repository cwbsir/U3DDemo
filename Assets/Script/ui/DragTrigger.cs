using LuaInterface;
using UnityEngine;
using UnityEngine.EventSystems;

public class DragTrigger : TouchTrigger,IBeginDragHandler,IDragHandler,IEndDragHandler
{
    protected LuaFunction _beginDragCB;
    protected LuaFunction _dragCB;
    protected LuaFunction _endDragCB;

    public void setLuaCallback(LuaFunction clickCB, System.Object args, LuaFunction downCB = null, LuaFunction upCB = null,LuaFunction beginDragCB = null,LuaFunction dragCB = null,LuaFunction endDragCB = null)
    {
        base.setLuaCallback(clickCB,args,downCB,upCB);
        _beginDragCB = beginDragCB;
        _dragCB = dragCB;
        _endDragCB = endDragCB;
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        if (_touchEnabled && _beginDragCB != null)
        {
            if (_paramStyle == 0)
                _beginDragCB.Call(1, _target);
            else if (_paramStyle == 1)
                _beginDragCB.Call(1, _target, eventData.position.x, eventData.position.y);
            else
                _beginDragCB.Call(1, _target, eventData);
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (_touchEnabled && _dragCB != null)
        {
            if (_paramStyle == 0)
                _dragCB.Call(1, _target);
            else if (_paramStyle == 1)
                _dragCB.Call(1, _target, eventData.position.x, eventData.position.y);
            else
                _dragCB.Call(1, _target, eventData);
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        if (_touchEnabled && _endDragCB != null)
        {
            if (_paramStyle == 0)
                _endDragCB.Call(1, _target);
            else if (_paramStyle == 1)
                _endDragCB.Call(1, _target, eventData.position.x, eventData.position.y);
            else
                _endDragCB.Call(1, _target, eventData);
        }
    }

    public new void OnDestory()
    {
        base.OnDestory();
        _beginDragCB = null;
        _dragCB = null;
        _endDragCB = null;
    }
}

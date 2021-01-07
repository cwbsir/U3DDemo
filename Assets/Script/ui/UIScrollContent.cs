using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;


public class UIScrollContent : MonoBehaviour
{
    public UnityEvent onSizeChange = new UnityEvent();
    public Action onPositionChange;

    private RectTransform _transform;
    private Rect _rect;
    private Vector3 _oldPosition;

    protected void Awake()
    {
        _transform = GetComponent<RectTransform>();
        _rect = _transform.rect;
        _oldPosition = _transform.localPosition;
    }

    protected void OnRectTransformDimensionsChange()
    {
        if (_transform.rect != _rect)
        {
            onSizeChange.Invoke();
        }
    }

    protected void Update()
    {
        if (onPositionChange != null && _transform.localPosition != _oldPosition)
        {
            Debug.Log("Update==============111111111111");
            onPositionChange.Invoke();
            _oldPosition = _transform.localPosition;
        }
    }
}
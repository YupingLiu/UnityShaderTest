using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class Item : MonoBehaviour {

    [SerializeField]
    private Text m_text;

    private int m_index;

	// Use this for initialization
	void Start () {
        m_index = transform.GetSiblingIndex();
        m_text.text = m_index.ToString();
	}
	
	public void OnEnter()
    {
        m_text.text = "Entered!";
    }

    public void OnClick()
    {
        m_text.text = "Clicked!";
    }

    public void OnExit()
    {
        m_text.text = m_index.ToString();
    }
}

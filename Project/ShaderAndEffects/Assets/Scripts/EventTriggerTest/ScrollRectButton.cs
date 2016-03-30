using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using UnityEngine.Serialization;
using System;

public class ScrollRectButton : Selectable, IPointerClickHandler, ISubmitHandler
    {
        [Serializable]
        public class ButtonClickedEvent : UnityEvent { }

        // Event delegates triggered on click.
        [FormerlySerializedAs("onClick")]
        [SerializeField]
        private ButtonClickedEvent m_OnClick = new ButtonClickedEvent();
        [FormerlySerializedAs("onEnter")]
        [SerializeField]
        private ButtonClickedEvent m_OnEnter = new ButtonClickedEvent();

        public ButtonClickedEvent OnEnter
        {
            get { return m_OnEnter; }
            set { m_OnEnter = value; }
        }
        [FormerlySerializedAs("onExit")]
        [SerializeField]
        private ButtonClickedEvent m_OnExit = new ButtonClickedEvent();

        public ButtonClickedEvent OnExit
        {
            get { return m_OnExit; }
            set { m_OnExit = value; }
        }

        protected ScrollRectButton()
        { }

        public ButtonClickedEvent onClick
        {
            get { return m_OnClick; }
            set { m_OnClick = value; }
        }

        private void Press()
        {
            if (!IsActive() || !IsInteractable())
                return;

            m_OnClick.Invoke();
        }

        public override void OnPointerEnter(PointerEventData eventData)
        {
            if (!IsActive() || !IsInteractable())
                return;

            m_OnEnter.Invoke();
        }

        public override void OnPointerExit(PointerEventData eventData)
        {
            if (!IsActive() || !IsInteractable())
                return;

            m_OnExit.Invoke();
        }

        // Trigger all registered callbacks.
        public virtual void OnPointerClick(PointerEventData eventData)
        {
            if (eventData.button != PointerEventData.InputButton.Left)
                return;

            Press();
        }

        public virtual void OnSubmit(BaseEventData eventData)
        {
            Press();

            // if we get set disabled during the press
            // don't run the coroutine.
            if (!IsActive() || !IsInteractable())
                return;

            DoStateTransition(SelectionState.Pressed, false);
            StartCoroutine(OnFinishSubmit());
        }

        private IEnumerator OnFinishSubmit()
        {
            var fadeTime = colors.fadeDuration;
            var elapsedTime = 0f;

            while (elapsedTime < fadeTime)
            {
                elapsedTime += Time.unscaledDeltaTime;
                yield return null;
            }

            DoStateTransition(currentSelectionState, false);
        }
    }

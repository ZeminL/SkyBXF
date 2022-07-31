Scriptname VR_quest_signs extends ObjectReference  

ObjectReference Property AS01 Auto
ObjectReference Property AS02 Auto

Event OnTriggerEnter(ObjectReference akActionRef)
If akActionRef == Game.GetPlayer()
AS01.Disable()
AS02.Enable()

Endif

Endevent

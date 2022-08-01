Scriptname finalsign extends ObjectReference  

ObjectReference Property AS01 Auto


Event OnTriggerEnter(ObjectReference akActionRef)
If akActionRef == Game.GetPlayer()
AS01.Disable()


Endif

Endevent


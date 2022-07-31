Scriptname VR_quest_start extends ObjectReference  

Quest Property myQuest Auto
ObjectReference Property AS01 Auto

Event OnTriggerEnter(ObjectReference akActionRef)
If akActionRef == Game.GetPlayer()
myQuest.SetStage(10)
AS01.Enable()

Endif

Endevent

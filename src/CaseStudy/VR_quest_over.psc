Scriptname VR_quest_over extends ObjectReference  
Quest Property myQuest Auto
ObjectReference Property AS01 Auto
ObjectReference Property AS02 Auto

Event OnTriggerEnter(ObjectReference akActionRef)
If akActionRef == Game.GetPlayer()
myQuest.SetStage(20)
AS01.Disable()
AS02.Enable()

Endif

Endevent
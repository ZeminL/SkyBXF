Scriptname VR_quest_backhome extends ObjectReference  
ObjectReference Property AS01 Auto
Quest Property myQuest Auto
ObjectReference Property TeleportLocation Auto


Event OnTriggerEnter(ObjectReference akActionRef)
If akActionRef == Game.GetPlayer()
AS01.Disable()
myQuest.CompleteQuest()
Utility.Wait(1.5)
Game.GetPlayer().MoveTo(TeleportLocation)

Endif

Endevent

Scriptname VR_startquest extends ObjectReference  
Quest Property myQuest Auto

Event OnContainerChanged(ObjectReference newContainer, ObjectReference oldContainer)
	if (newContainer == Game.GetPlayer())
		myQuest.Start()
		myQuest.SetStage(0)
	endif
EndEvent
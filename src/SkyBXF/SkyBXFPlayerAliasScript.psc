Scriptname SkyBXFPlayerAliasScript extends ReferenceAlias  

Quest Property SkyBXFMain  Auto  

Event OnPlayerLoadGame()
    (SkyBXFMain as SkyBXFQuestScript).DoInit()
EndEvent

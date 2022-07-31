Scriptname SkyBXFQuestScript extends Quest  

Furniture Property ULSUCampfire Auto

ObjectReference Property StartMarker Auto
ObjectReference Property EndMarker Auto

UIListMenu Property uilist Auto
Message Property ms_pre Auto
Message Property ms_post Auto
Message Property ms_sleep Auto
Message Property ms_blockend Auto


Int Property resultData Auto
Int Property result Auto

Int Property curBlock Auto
Int Property curTrial Auto
Int Property curDataNum Auto	
Int Property sleep Auto
Int Property config Auto


float Property id = 1.0 Auto
float Property age = 18.0 Auto
float Property session Auto

float Property fcurContent = 1.0 Auto

Int Property block Auto
Int Property trial Auto
Int Property count Auto

Int Property queData Auto
Int Property content Auto
Int Property contentPart Auto

Int Property a_flags = 0 Auto

Bool Property isPreTrial = true Auto
Bool Property isPostTrial =true Auto
Bool Property isBetweenTrialRest =true Auto
Bool Property isReach Auto


string Property queName Auto
Int Property queCount Auto

Function DoInit()
    uilist = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    config = JValue.readFromFile(JContainers.userDirectory() + "config.json")


	isPreTrial = JMap.getInt(config,"isPreTrial") as bool
	isPostTrial = JMap.getInt(config,"isPostTrial") as bool
	isBetweenTrialRest = JMap.getInt(config,"isBetweenTrialRest") as bool
	sleep = JMap.getInt(config,"RestDuration")
	trial = JMap.getInt(config,"trial")
	block = JMap.getInt(config,"block")
	session = JMap.getInt(config,"session") as float

EndFunction

Event OnInit()
    DoInit()
EndEvent

ObjectReference function SetMarker()
	ObjectReference marker
	float TrigAngleZ
	float GameAngleZ = Game.GetPlayer().GetAngleZ()
		if ( GameAngleZ < 90 )
		  TrigAngleZ = 90 - GameAngleZ
		else
		  TrigAngleZ = 450 - GameAngleZ
		endif
	Float posX = Game.GetPlayer().GetPositionX() + 110 * Math.Cos(TrigAngleZ)
	Float posY = Game.GetPlayer().GetPositionY() + 110 * Math.Sin(TrigAngleZ)
	Float posZ = Game.GetPlayer().GetPositionZ() + 1
	Float angX = Game.GetPlayer().GetAngleX()
	Float angY = Game.GetPlayer().GetAngleY()
	Float angZ = Game.GetPlayer().GetAngleZ()
	marker = Game.GetPlayer().PlaceAtMe(ULSUCampfire)
	marker.Disable()
	marker.SetPosition(posX, posY, posZ)
	marker.SetAngle(0, angY, angZ)
	return marker
endFunction

Function StartBlock(message ms_sleep)

	resultData = JDB.solveObj(".result.Data")
	id = JDB.solveInt(".result.id") as float
	session = JDB.solveInt(".result.Session") as float
	block = JDB.solveInt(".result.Block")
	trial = JDB.solveInt(".result.Trial")

	string output

	curBlock = 1
	

	while (curBlock <= block)
		curTrial = 1
		while (curTrial <= trial)
			string tmp = (id as int) as string+","+(session as int) as string+","+curBlock as string+","+ curTrial as string
			if (isPreTrial)
				output = ShowQuestionnaire(tmp+","+"pre", ms_pre)
				JArray.setStr(resultData,1,output)

			endif
			isReach = false
			while (!isReach)
				Utility.Wait(0.5)
				if (Game.GetPlayer().GetDistance(EndMarker)<500)
					isReach = true
				endif
			endwhile
		
			if (isPostTrial)
				output = ShowQuestionnaire(tmp+","+"post",ms_post)
				JArray.setStr(resultData,2,output)

			endif		
			Game.GetPlayer().MoveTo(StartMarker)
			if (isBetweenTrialRest)
				if (curTrial != trial)
					ms_sleep.show(sleep as float)
					Utility.Wait(sleep)
				endif
			endif	
			JValue.writeToFile(JDB.solveObj(".result"), JContainers.userDirectory()+"Result/"+"Participant_"+(id as int) as string+"/"+"Result"+"_"+(id as int) as string+"_"+(session as int) as string+"_"+curBlock as string+"_"+curTrial as string+".json")
			curTrial += 1
		endwhile
		if (curBlock != block)
			int r = ms_blockend.show()
			if (r == 1)
				curBlock = block
			endif
		endif
		curBlock += 1
	endwhile	
	
endFunction
	
string Function ShowQuestionnaire(string curTrialData, Message ms)
    content = JDB.solveObj(".queData.content")


	content = JMap.getObj(queData,"content")


	int contN = JArray.count(content)
	int i = 0
	ms.show()

	while (i < contN)		
		int data = JArray.getObj(content,i)
		i += 1
		uilist.ResetMenu()
    	While uilist.isResetting
        	Utility.Wait(0.1)
    	EndWhile
    	int dataN = JArray.count(data)
    	int j = 0
		If uilist
			while (j < dataN)				
				uilist.AddEntryItem(JArray.getStr(data,j))
				j += 1
			endwhile
		EndIf
		float ftimeStart = Utility.GetCurrentRealTime()
		uilist.OpenMenu()
		float ftimeEnd = Utility.GetCurrentRealTime()
		curTrialData += ","
		curTrialData += uilist.GetResultInt() as string
		curTrialData += ","
		curTrialData += (ftimeEnd - ftimeStart) as string
	endwhile

	return curTrialData
endFunction


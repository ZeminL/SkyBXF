Scriptname SkyBXFMCMScript extends SKI_ConfigBase  

SkyBXFQuestScript MainScript
Quest Property SkyBXFMain  Auto  
; Lists
string[]	_gender
string[]	_hand

; OIDs
int		_genderMenuOID
int 		_handOID_H
int 	_curContentOID

; OIDs
int _pretestOID
int _posttestOID
int _takebreakOID
; State

int		_curGender = 0
int 	_curHand = 0

int 	_curContent = 0

; OIDs
int		_IDinputOID
int 	_ageOID
int 	_sessionOID
int 	_blockOID
int 	_trialOID
int 	_sleepBTOID
int 	_quesOID

int 	_curQueNameOID
int 	_curQueCountOID
int 	_curQueTypeOID
int 	_curQuestionOID
int 	_curAOID
int 	_curBOID
int 	_curCOID
int 	_curDOID
int 	_startOID
int 	_setSMOID
int 	_setEMOID

int 	_endTimeOID
int 	_endPosOID
int 	_TimeLimitOID
; State

string 		_startMarker 	= "None"
string 		_EndMarker 	= "None"

; SCRIPT VERSION
int function GetVersion()
	return 1
endFunction

function Startfunc()
	MainScript.queData = JValue.readFromFile(JContainers.userDirectory() + "Questionnaire.json")
	JDB.SetObj("queData", MainScript.queData)
	MainScript.resultData = JArray.object()
	MainScript.result = JMap.object()
	JMap.setInt(MainScript.result,"ID",MainScript.id as int)
	JMap.setStr(MainScript.result,"Gender",_gender[_curGender])
	JMap.setStr(MainScript.result,"Handedness",_hand[_curHand])
	JMap.setInt(MainScript.result,"Session",MainScript.session as int)
	JMap.setInt(MainScript.result,"Block",MainScript.block)
	JMap.setInt(MainScript.result,"Trial",MainScript.trial)
	JMap.setInt(MainScript.result,"Duration of rest between trials",MainScript.sleep)
	JValue.writeToFile(MainScript.result, JContainers.userDirectory()+"Result/"+"Participant_"+(MainScript.id as int) as string+"/"+"ParticipantInfo.json")
	string Header = "ID,Session,Block,Trial,Design"
	int n = 1
	while (n <= MainScript.queCount)		
		Header += "," 
		Header += n as string
		Header += ",RT" 				
		n += 1
	endwhile
	JArray.addStr(MainScript.resultData,Header)
	if (MainScript.isPreTrial)
		JArray.addStr(MainScript.resultData,(MainScript.id as int) as string+","+(MainScript.session as int) as string+","+MainScript.block as string+","+ MainScript.trial as string +","+ "pre")	
	endif
	if (MainScript.isPostTrial)
		JArray.addStr(MainScript.resultData,(MainScript.id as int) as string+","+(MainScript.session as int) as string+","+MainScript.block as string+","+ MainScript.trial as string +","+ "post")
	endif
	JMap.setObj(MainScript.result,"Data",MainScript.resultData)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
	JDB.setObj("Result",MainScript.result)	
	MainScript.config = JValue.readFromFile(JContainers.userDirectory() + "config.json")
	JMap.setInt(MainScript.config,"isPreTrial",MainScript.isPreTrial as int)
	JMap.setInt(MainScript.config,"isPostTrial",MainScript.isPostTrial as int)
	JMap.setInt(MainScript.config,"isBetweenTrialRest",MainScript.isBetweenTrialRest as int)
	JMap.setInt(MainScript.config,"RestDuration",MainScript.sleep)
	JMap.setInt(MainScript.config,"trial",MainScript.trial)
	JMap.setInt(MainScript.config,"block",MainScript.block)
	JMap.setInt(MainScript.config,"session",MainScript.session as int)
	JValue.writeToFile(MainScript.config, JContainers.userDirectory() + "config.json")
	Game.GetPlayer().MoveTo(MainScript.StartMarker)
	Utility.Wait(1)
	MainScript.StartBlock(MainScript.ms_sleep)
endFunction
bool function GetFile()
	MainScript.queData = JValue.readFromFile(JContainers.userDirectory() + "Questionnaire.json")
	if (MainScript.queData == 0)
		ShowMessage("Questionnaire file is missing",false)
		return false
	else

		MainScript.queName = JMap.getStr(MainScript.queData,"name")
		MainScript.queCount = JMap.getInt(MainScript.queData,"count")

		MainScript.content = JMap.getObj(MainScript.queData,"content")
		MainScript.contentPart = JArray.getObj(MainScript.content,_curContent)
		return true
	endif

endFunction

function ReQuestions()
	MainScript.contentPart = JArray.getObj(MainScript.content,_curContent)

	SetTextOptionValue(_curQuestionOID,JArray.getStr(MainScript.contentPart,0))

endFunction

; INITIALIZATION ----------------------------------------------------------------------------------
event OnConfigOpen()
	MainScript.config = JValue.readFromFile(JContainers.userDirectory() + "config.json")

	GetFile()

endEvent
event OnConfigClose()

endEvent
; @overrides SKI_ConfigBase
event OnConfigInit()
	MainScript =SkyBXFMain as SkyBXFQuestScript


	Pages = new string[2]
	Pages[0] = "Setting Page"
	Pages[1] = "Questionnaire Page"

	_gender = new string[2]
	_gender[0] = "Male"
	_gender[1] = "Female"

	_hand = new string[2]
	_hand[0] = "Left"
	_hand[1] = "right"


endEvent

event OnPageReset(string a_page)

	if (a_page == "")
		; Image size 256x256
		; X offset = 376 - (height / 2) = 258
		; Y offset = 223 - (width / 2) = 95
		LoadCustomContent("skyui/res/mcm_logo.dds", 258, 95)
		return
	else
		UnloadCustomContent()
	endIf

	if (a_page == "Setting Page")
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("Participant Information")

		_IDinputOID = AddSliderOption("ID", MainScript.id,"NO. {0}")
        _ageOID = AddSliderOption("Age",MainScript.age," {0} years old")
		_genderMenuOID = AddMenuOption("Gender", _gender[_curGender])
		_handOID_H = AddMenuOption("handedness", _hand[_curHand])

		AddHeaderOption("End Conditions")

		_endTimeOID = AddToggleOption("Set the time limit",MainScript.isTimeLimit)
		_endPosOID = AddToggleOption("Set the end position",MainScript.isTimeLimit == false)
		_TimeLimitOID = AddSliderOption("Time limit duration", MainScript.TimeLimit as float," {0} seconds")
		SetCursorPosition(1)

		AddHeaderOption("Experiment Option")
		_sessionOID = AddSliderOption("Session Num", MainScript.session," {0} ")
		_blockOID = AddSliderOption("Block Num", MainScript.block as float," {0} ")
		_trialOID = AddSliderOption("There are", MainScript.trial as float," {0} trials")
		_sleepBTOID = AddSliderOption("Duration of rest between trials", MainScript.sleep as float," {0} seconds")
 
		_setSMOID = AddTextOption("Set Start Position",_StartMarker)
		_setEMOID = AddTextOption("Set End Position",_EndMarker)
		AddEmptyOption()
		_startOID = AddTextOption("Start","")

	elseIf (a_page == "Questionnaire Page")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Check Questionnaire")
		_quesOID = AddTextOption("Update Questionnaires", "")

		AddHeaderOption("Add Test")
		_pretestOID = AddToggleOption("Add PreTrial",MainScript.isPreTrial)
		_posttestOID = AddToggleOption("Add PostTrial",MainScript.isPostTrial)
		_takebreakOID = AddToggleOption("Add rest between trials",MainScript.isBetweenTrialRest)

		
		SetCursorPosition(1)
		AddHeaderOption("Questions")
		_curQueNameOID = AddTextOption("Name",MainScript.queName)
		_curQueCountOID = AddTextOption("Count",MainScript.queCount)
		_curContentOID = AddSliderOption("Question No",MainScript.fcurContent," {0} ")
		_curQuestionOID = AddTextOption("Question",JArray.getStr(MainScript.contentPart,0))

	endIf
endEvent

event OnOptionSelect(int a_option)
	if (a_option == _startOID)
		if (MainScript.StartMarker == None)
			Debug.MessageBox("Please set the start position!")
		else
			if (MainScript.isTimeLimit == false)
				if (MainScript.EndMarker == None)
					Debug.MessageBox("Please set the end position!")
				else
					Startfunc()
				endif
			else
				Startfunc()
			endif
		endif				
	elseIf (a_option ==_endTimeOID)
		MainScript.isTimeLimit = true
		SetToggleOptionValue(_endTimeOID, MainScript.isTimeLimit)
		SetToggleOptionValue(_endPosOID, MainScript.isTimeLimit == false)
	elseIf (a_option ==_endPosOID)
		MainScript.isTimeLimit = false
		SetToggleOptionValue(_endTimeOID, MainScript.isTimeLimit)
		SetToggleOptionValue(_endPosOID, MainScript.isTimeLimit == false)
	elseIf (a_option ==_pretestOID)
		MainScript.isPreTrial = !MainScript.isPreTrial
		SetToggleOptionValue(a_option, MainScript.isPreTrial)
	elseIf (a_option ==_posttestOID)
		MainScript.isPostTrial = !MainScript.isPostTrial
		SetToggleOptionValue(a_option, MainScript.isPostTrial)
	elseIf (a_option ==_takebreakOID)
		MainScript.isBetweenTrialRest = !MainScript.isBetweenTrialRest
		SetToggleOptionValue(a_option, MainScript.isBetweenTrialRest)
	elseIf (a_option ==_setSMOID)
		MainScript.StartMarker = MainScript.SetMarker()
		if (MainScript.StartMarker != None)
			_startMarker = "Done"
			SetTextOptionValue(a_option, "Done")
		endif
	elseIf (a_option ==_setEMOID)
		MainScript.EndMarker = MainScript.SetMarker()
		if (MainScript.EndMarker != None)
			_EndMarker = "Done"
			SetTextOptionValue(a_option, "Done")
		endif
	elseIf (a_option ==_quesOID)
		MainScript.config = JValue.readFromFile(JContainers.userDirectory() + "config.json")

		GetFile()

		SetTextOptionValue(_curQueNameOID,MainScript.queName)
		SetTextOptionValue(_curQueCountOID,MainScript.queCount)
		ReQuestions()

	endif	
endEvent

event OnOptionMenuOpen(int a_option)

	if (a_option == _genderMenuOID)
		SetMenuDialogStartIndex(_curGender)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_gender)
	elseIf (a_option == _handOID_H)
		SetMenuDialogStartIndex(_curHand)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(_hand)
	endif
endEvent

event OnOptionMenuAccept(int a_option, int a_index)

	if (a_option == _genderMenuOID)
		_curGender = a_index
		SetMenuOptionValue(a_option, _gender[_curGender])
	elseIf (a_option == _handOID_H)
		_curHand = a_index
		SetMenuOptionValue(a_option, _hand[_curHand])
	endif
endEvent

event OnOptionSliderOpen(int a_option)

	if (a_option == _IDinputOID)
		SetSliderDialogStartValue(MainScript.id)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)		
	elseif (a_option == _TimeLimitOID)
		SetSliderDialogStartValue(MainScript.TimeLimit as float)
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(10, 600)
		SetSliderDialogInterval(10)
	elseif (a_option == _ageOID)
		SetSliderDialogStartValue(MainScript.age)
		SetSliderDialogDefaultValue(18)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	elseif (a_option == _sessionOID)
		SetSliderDialogStartValue(MainScript.session)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 10)
		SetSliderDialogInterval(1)
	elseif (a_option == _blockOID)
		SetSliderDialogStartValue(MainScript.block as float)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 50)
		SetSliderDialogInterval(1)
	elseif (a_option == _trialOID)
		SetSliderDialogStartValue(MainScript.trial as float)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 50)
		SetSliderDialogInterval(1)
	elseif (a_option == _sleepBTOID)
		SetSliderDialogStartValue(MainScript.sleep as float)
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(0, 600)
		SetSliderDialogInterval(5)
	elseif (a_option == _curContentOID)
		SetSliderDialogStartValue(MainScript.fcurContent)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1,MainScript.queCount)
		SetSliderDialogInterval(1)
	endIf
endEvent

event OnOptionSliderAccept(int a_option, float a_value)
		
	if (a_option == _IDinputOID)
		MainScript.id = a_value
		SetSliderOptionValue(a_option, a_value, "NO. {0}")
	elseif (a_option == _TimeLimitOID)
		MainScript.TimeLimit = a_value as int
		SetSliderOptionValue(a_option, a_value, " {0} seconds")	
	elseif (a_option == _ageOID)
		MainScript.age = a_value
		SetSliderOptionValue(a_option, a_value, " {0} years old")
	elseif (a_option == _sessionOID)
		MainScript.session = a_value
		SetSliderOptionValue(a_option, a_value, " {0} ")
	elseif (a_option == _blockOID)
		MainScript.block = a_value as int
		SetSliderOptionValue(a_option, a_value, " {0} ")
	elseif (a_option == _trialOID)
		MainScript.trial = a_value as int
		SetSliderOptionValue(a_option, a_value, " {0} trials")
	elseif (a_option == _sleepBTOID)
		MainScript.sleep = a_value as int
		SetSliderOptionValue(a_option, a_value, " {0} seconds")
	elseif (a_option == _curContentOID)
		MainScript.fcurContent = a_value
		_curContent = MainScript.fcurContent as int - 1
		SetSliderOptionValue(a_option, a_value, " {0} ")
		ReQuestions()
	endIf
endEvent

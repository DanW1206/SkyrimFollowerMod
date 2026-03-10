Scriptname HappyCatRunScript extends ReferenceAlias

Armor Property SkinHappyCatDrive Auto      
Armor Property SkinHappyCatHuzzah Auto     
Armor Property SkinHappyCat Auto           
Armor Property SkinHappyCatNeutral Auto    
Armor Property SkinBananaCatCrying Auto    
Weapon Property MyWeapon Auto
Armor Property MyShield Auto

Int Property STATE_NEUTRAL = 0 AutoReadOnly
Int Property STATE_DRIVE = 1 AutoReadOnly
Int Property STATE_COMBAT = 2 AutoReadOnly
Int Property STATE_TALKING = 3 AutoReadOnly
Int Property STATE_DOWNED = 4 AutoReadOnly

Int _currentState = 0
Actor PlayerRef

Event OnInit()
    SetupScript()
EndEvent

Event OnPlayerLoadGame()
    SetupScript()
EndEvent

Function SetupScript()
    PlayerRef = Game.GetPlayer()
    RegisterForSingleUpdate(1.0)
EndFunction

Event OnEnterBleedout()
    SetState(STATE_DOWNED)
EndEvent

Event OnActivate(ObjectReference akActionRef)
    If akActionRef == PlayerRef
        SetState(STATE_TALKING)
    EndIf
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    If aeCombatState != 0
        SetState(STATE_COMBAT)
    Else
        SetState(STATE_NEUTRAL)
    EndIf
EndEvent

Event OnUpdate()
    Actor selfRef = GetActorReference()
    If !selfRef || selfRef.IsDead()
        Return
    EndIf
    If _currentState == STATE_TALKING
        If selfRef.GetDistance(PlayerRef) > 250.0
            SetState(STATE_NEUTRAL)
        EndIf
    ElseIf _currentState == STATE_NEUTRAL || _currentState == STATE_DRIVE
        Float distance = selfRef.GetDistance(PlayerRef)
        If distance > 500.0
            SetState(STATE_DRIVE)
        Else
            SetState(STATE_NEUTRAL)
        EndIf
    EndIf
    RegisterForSingleUpdate(2.0)
EndEvent

Function SetState(Int newState)
    If _currentState == newState
        Return
    EndIf
    _currentState = newState
    UpdateEquipment()
EndFunction

Function UpdateEquipment()
    Actor selfRef = GetActorReference()
    If !selfRef
        Return
    EndIf
    UnequipAllSkins(selfRef)
    If _currentState == STATE_DOWNED
        EquipSkin(selfRef, SkinBananaCatCrying)
    ElseIf _currentState == STATE_COMBAT
        EquipSkin(selfRef, SkinHappyCatHuzzah)
        selfRef.EquipItem(MyWeapon)
        selfRef.EquipItem(MyShield)
    ElseIf _currentState == STATE_TALKING
        EquipSkin(selfRef, SkinHappyCat)
    ElseIf _currentState == STATE_DRIVE
        EquipSkin(selfRef, SkinHappyCatDrive)
    Else
        EquipSkin(selfRef, SkinHappyCatNeutral)
    EndIf
EndFunction

Function UnequipAllSkins(Actor akActor)
    If SkinHappyCatDrive
        akActor.UnequipItem(SkinHappyCatDrive, False, True)
    EndIf
    If SkinHappyCatHuzzah
        akActor.UnequipItem(SkinHappyCatHuzzah, False, True)
    EndIf
    If SkinHappyCat
        akActor.UnequipItem(SkinHappyCat, False, True)
    EndIf
    If SkinHappyCatNeutral
        akActor.UnequipItem(SkinHappyCatNeutral, False, True)
    EndIf
    If SkinBananaCatCrying
        akActor.UnequipItem(SkinBananaCatCrying, False, True)
    EndIf
EndFunction

Function EquipSkin(Actor akActor, Armor akSkin)
    If akSkin
        If akActor.GetItemCount(akSkin) == 0
            akActor.AddItem(akSkin, 1, True)
        EndIf
        akActor.EquipItem(akSkin, False, True)
    EndIf
EndFunction
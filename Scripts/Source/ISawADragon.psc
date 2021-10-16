scriptName ISawADragon extends Quest  
{This is the main code for the "I Saw a Dragon..." quest}

int property STAGE_NOT_STARTED              = 0  autoReadonly
int property STAGE_MURDERING                = 10 autoReadonly
int property STAGE_COMPLETED                = 90 autoReadonly
int property STAGE_WRONG_DAMAGE_TYPE_FAILED = 95 autoReadonly
int property STAGE_FAILED                   = 99 autoReadonly

int property OBJECTIVE_MURDER_HILDE = 0 autoReadonly
int property OBJECTIVE_MURDER_SVEN  = 1 autoReadonly
int property OBJECTIVE_MURDER_HOD   = 2 autoReadonly

FormList Property ElectricitySpells  Auto  

ISawADragon function GetInstance() global
    return Game.GetFormFromFile(0xd62, "ISawADragon.esp") as ISawADragon
endFunction

function BeginQuest()
    SetStage(STAGE_MURDERING)
    SetObjectiveDisplayed(OBJECTIVE_MURDER_HILDE)
endFunction

event OnHildeMurder(Actor killer)
    if GetStage() == STAGE_MURDERING && killer == Game.GetPlayer()
        SetObjectiveCompleted(OBJECTIVE_MURDER_HILDE)
        SetObjectiveDisplayed(OBJECTIVE_MURDER_SVEN)
    endIf
endEvent

event OnSvenMurder(Actor killer)
    if GetStage() == STAGE_MURDERING && killer == Game.GetPlayer()
        if IsObjectiveCompleted(OBJECTIVE_MURDER_HILDE)
            SetObjectiveCompleted(OBJECTIVE_MURDER_SVEN)
            SetObjectiveDisplayed(OBJECTIVE_MURDER_HOD)
        else
            SetObjectiveFailed(OBJECTIVE_MURDER_HILDE)
            SetStage(STAGE_FAILED)
        endIf
    endIf
endEvent

event OnHodMurder(Actor killer)
    ; TODO test for electrocution
    if GetStage() == STAGE_MURDERING && killer == Game.GetPlayer()
        if IsObjectiveCompleted(OBJECTIVE_MURDER_HILDE) && IsObjectiveCompleted(OBJECTIVE_MURDER_SVEN)
            ISawADragonHodScript hodScript = GetAliasByName("HodRef") as ISawADragonHodScript
            if ElectricitySpells.HasForm(hodScript.LastFormThatHitHod)
                SetObjectiveCompleted(OBJECTIVE_MURDER_HOD)
                SetStage(STAGE_COMPLETED)
            else
                SetObjectiveFailed(OBJECTIVE_MURDER_HOD)
                SetStage(STAGE_WRONG_DAMAGE_TYPE_FAILED)
            endIf
        else
            if ! IsObjectiveCompleted(OBJECTIVE_MURDER_HILDE)
                SetObjectiveFailed(OBJECTIVE_MURDER_HILDE)
            elseIf ! IsObjectiveCompleted(OBJECTIVE_MURDER_SVEN)
                SetObjectiveFailed(OBJECTIVE_MURDER_SVEN)
            endIf
            SetStage(STAGE_FAILED)
        endIf
    endIf
endEvent

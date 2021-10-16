scriptName ISawADragonTests extends SkyUnitTest
{The main tests for the "I Saw a Dragon..." quest}

ISawADragon MurderQuest

Spell property Sparks auto
Spell property Flames auto

import QuestAssertions

function Tests()
    Test("Quest start OK").Fn(QuestStartsOkTest())
    Test("Asks player to kill Sven after Hilde is murdered").Fn(KillSvenObjectiveShownAfterKillingHilde())
    Test("Asks player to kill Hod after Sven is murdered").Fn(KillHodObjectiveShownAfterKillingSven())
    Test("Quest is completed when Hod is murdered").Fn(QuestCompleteWhenHodIsMurdered())
    Test("Quest is failed if Sven killed before Hilde").Fn(QuestFailedIfKillSvenBeforeHilde())
    Test("Quest is failed if Hod killed before Sven").Fn(QuestFailedIfHodKilledBeforeSven())
endFunction

function BeforeAll()
    MurderQuest = ISawADragon.GetInstance()
endFunction

function BeforeEach()
    MurderQuest.Stop()
    MurderQuest.Reset()
endFunction

function AfterAll()
    MurderQuest.Stop()
    MurderQuest.Reset()
endFunction

ISawADragonHildeScript function GetHildeScript()
    return MurderQuest.GetAliasByName("HildeRef") as ISawADragonHildeScript
endFunction

ISawADragonSvenScript function GetSvenScript()
    return MurderQuest.GetAliasByName("SvenRef") as ISawADragonSvenScript
endFunction

ISawADragonHodScript function GetHodScript()
    return MurderQuest.GetAliasByName("HodRef") as ISawADragonHodScript
endFunction

function QuestStartsOkTest()
    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_NOT_STARTED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).Not().To(BeDisplayed())

    MurderQuest.BeginQuest()

    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).To(BeDisplayed())
endFunction

function KillSvenObjectiveShownAfterKillingHilde()
    MurderQuest.BeginQuest()
    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).To(BeDisplayed())
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).Not().To(BeComplete())
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_SVEN).Not().To(BeDisplayed())

    GetHildeScript().OnDeath(Game.GetPlayer()) ; Kill Hilde

    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).To(BeComplete())
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_SVEN).Not().To(BeComplete())
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_SVEN).To(BeDisplayed())
endFunction

function KillHodObjectiveShownAfterKillingSven()
    MurderQuest.BeginQuest()
    GetHildeScript().OnDeath(Game.GetPlayer()) ; Kill Hilde
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HOD).Not().To(BeDisplayed())
    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))

    GetSvenScript().OnDeath(Game.GetPlayer()) ; Kill Sven

    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HOD).To(BeDisplayed())
    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))
endFunction

function QuestCompleteWhenHodIsMurdered()
    MurderQuest.BeginQuest()
    GetHildeScript().OnDeath(Game.GetPlayer()) ; Kill Hilde
    GetSvenScript().OnDeath(Game.GetPlayer())  ; Kill Sven
    ExpectQuest(murderQuest).Not().To(BeAtStage(murderQuest.STAGE_COMPLETED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HOD).Not().To(BeComplete())

    ; Use Sparks
    GetHodScript().OnHit(Game.GetPlayer(), Sparks, None, false, false, false, false)
    GetHodScript().OnDeath(Game.GetPlayer()) ; Kill Hod

    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_COMPLETED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HOD).To(BeComplete())
endFunction

function HodObjectiveFailedUnlessYouElectrocuteHimWithSparks()
    MurderQuest.BeginQuest()
    GetHildeScript().OnDeath(Game.GetPlayer()) ; Kill Hilde
    GetSvenScript().OnDeath(Game.GetPlayer())  ; Kill Sven
    ExpectQuest(murderQuest).Not().To(BeAtStage(murderQuest.STAGE_COMPLETED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HOD).Not().To(BeComplete())

    ; Use Flames instead of an electricity / shock damage spell
    GetHodScript().OnHit(Game.GetPlayer(), Flames, None, false, false, false, false)
    GetHodScript().OnDeath(Game.GetPlayer()) ; Kill Hod

    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_COMPLETED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HOD).To(BeComplete())
endFunction

function QuestFailedIfKillSvenBeforeHilde()
    MurderQuest.BeginQuest()
    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).Not().To(BeFailed())

    ; Use Flames instead of an electricity / shock damage spell
    GetHodScript().OnHit(Game.GetPlayer(), Flames, None, false, false, false, false)
    GetSvenScript().OnDeath(Game.GetPlayer()) ; Kill Sven

    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_FAILED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_HILDE).To(BeFailed())
endFunction

function QuestFailedIfHodKilledBeforeSven()
    MurderQuest.BeginQuest()
    GetHildeScript().OnDeath(Game.GetPlayer()) ; Kill Hilde
    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_MURDERING))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_SVEN).Not().To(BeFailed())

    GetHodScript().OnDeath(Game.GetPlayer()) ; Kill Hod

    ExpectQuest(murderQuest).To(BeAtStage(murderQuest.STAGE_FAILED))
    ExpectQuestObjective(murderQuest, murderQuest.OBJECTIVE_MURDER_SVEN).To(BeFailed())
endFunction

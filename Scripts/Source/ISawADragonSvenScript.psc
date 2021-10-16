Scriptname ISawADragonSvenScript extends ReferenceAlias  

event OnDeath(Actor killer)
    ISawADragon.GetInstance().OnSvenMurder(killer)
endEvent

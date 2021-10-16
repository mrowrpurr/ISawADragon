Scriptname ISawADragonHildeScript extends ReferenceAlias  

event OnDeath(Actor killer)
    ISawADragon.GetInstance().OnHildeMurder(killer)
endEvent

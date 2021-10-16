Scriptname ISawADragonHodScript extends ReferenceAlias  

Form property LastFormThatHitHod auto

event OnDeath(Actor killer)
    ISawADragon.GetInstance().OnHodMurder(killer)
endEvent

event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    LastFormThatHitHod = akSource
endEvent
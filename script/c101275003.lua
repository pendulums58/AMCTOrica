--수렵자 개
local s,id=GetID()
function s.initial_effect(c)
   --밸로키랍토르
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
   e1:SetOperation(s.atkop)
   c:RegisterEffect(e1)
   --공통효과
   local e2=Effect.CreateEffect(c)
   e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e2:SetType(EFFECT_TYPE_QUICK_O)
   e2:SetCode(EVENT_ATTACK_ANNOUNCE)
   e2:SetCondition(s.spcon)
   e2:SetCountLimit(1,id)
   e2:SetRange(LOCATION_SZONE)
   e2:SetOperation(s.op)
   c:RegisterEffect(e2)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetCode(EFFECT_SET_ATTACK_FINAL)
   e1:SetValue(c:GetAttack()*2)
   e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
   c:RegisterEffect(e1,true)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
   return YiPi.HunterSpChk(e:GetHandler()) and Duel.IsExistingMatchingCard(YiPi.HunterCheck,tp,0,LOCATION_MZONE,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
   if e:GetHandler():IsRelateToEffect(e) and Duel.NegateAttack() then
      YiPi.HunterEffect(e)
   end   
end
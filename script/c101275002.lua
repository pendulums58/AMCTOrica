--수렵자 코양이
local s,id=GetID()
function s.initial_effect(c)
   --2회 공격
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
   e1:SetRange(LOCATION_MZONE)
   e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
   e1:SetValue(1)
   c:RegisterEffect(e1)   
   --공통 효과
   local e2=Effect.CreateEffect(c)
   e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e2:SetRange(LOCATION_SZONE)
   e2:SetType(EFFECT_TYPE_IGNITION)
   e2:SetCountLimit(1,id)
   e2:SetCondition(s.ngcon)
   e2:SetCost(cyan.dhcost(1))
   e2:SetTarget(s.ngtg)
   e2:SetOperation(s.ngop)
   c:RegisterEffect(e2)
end
function s.ngcon(e,tp,eg,ep,ev,re,r,rp)
   return YiPi.HunterSpChk(e:GetHandler()) and Duel.IsExistingMatchingCard(YiPi.HunterCheck,tp,0,LOCATION_MZONE,1,nil)
end
function s.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(s.negfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.negfilter(c)
   return c:IsFaceup() and not c:IsDisabled()
end
function s.ngop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if c:IsRelateToEffect(e) then
      local tc=Duel.SelectMatchingCard(tp,s.negfilter,tp,0,LOCATION_MZONE,1,1,nil)
      if tc:GetCount()>0 then
         tc=tc:GetFirst()
         if tc:IsNegatable() then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
            if tc:IsType(TYPE_TRAPMONSTER) then
               local e3=Effect.CreateEffect(c)
               e3:SetType(EFFECT_TYPE_SINGLE)
               e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
               e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
               e3:SetReset(RESET_EVENT+RESETS_STANDARD)
               tc:RegisterEffect(e3)
            end
         end         
      end
      YiPi.HunterEffect(e)
   end
end
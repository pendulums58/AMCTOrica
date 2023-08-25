--수렵자 말딸
local s,id=GetID()
function s.initial_effect(c)
   --세팅
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(id,1))
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
   e1:SetTarget(s.target)
   e1:SetCountLimit(1,id)
   e1:SetOperation(s.operation)
   c:RegisterEffect(e1)
   local e2=e1:Clone()
   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e2)
   --파괴
   local e3=Effect.CreateEffect(c)
   e3:SetCategory(CATEGORY_DESTROY)
   e3:SetType(EFFECT_TYPE_QUICK_O)
   e3:SetCode(EVENT_FREE_CHAIN)
   e3:SetRange(LOCATION_SZONE)
   e3:SetCountLimit(1,{id,1})
   e3:SetCondition(s.ngcon)
   e3:SetTarget(s.ngtg)
   e3:SetOperation(s.ngop)   
   c:RegisterEffect(e3)
end
function s.filter(c)
   return c:IsSetCard(SETCARD_HUNTER) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
      and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK,0,1,1,nil)
   local tc=g:GetFirst()
   if tc then
      Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetCode(EFFECT_CHANGE_TYPE)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
      e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
      tc:RegisterEffect(e1)
   end
end
function s.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and YiPi.SpellHunterCheck(c) and YiPi.IsHuntingTargetExists(tp,0,1)
end
function s.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)   
   local cg=e:GetHandler():GetColumnGroup()
   if chk==0 then return cg:GetCount()>0 end
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,cg:GetCount(),tp,LOCATION_ONFIELD)
end
function s.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
		local cg=e:GetHandler():GetColumnGroup()
		Duel.Destroy(cg,REASON_EFFECT)
		if YiPi.IsAbleToTag(c,e,tp) and Duel.SelectYesNo(tp,1152) then
			YiPi.Tag(c,e,tp)
		else
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
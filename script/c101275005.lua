--수렵구 - 영웅의 비약
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.chk(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(s.chk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	e:SetLabel(0)
	local tc=Duel.SelectTarget(tp,s.chk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if not (tc:IsLevelAbove(1) or tc:IsRankAbove(1)) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0) end
	if Duel.IsExistingMatchingCard(YiPi.HunterCheck,tp,0,LOCATION_MZONE,1,nil) then e:SetLabel(1) end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)			
	elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_RANK)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0))
      and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
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
end
function s.filter(c)
   return c:IsSetCard(SETCARD_HUNTER) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.chk(c)
	return c:IsFaceup()
end
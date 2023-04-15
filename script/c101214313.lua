--스카이워커 서모스피어
function c101214313.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c101214313.synfilter1),2)
	c:EnableReviveLimit()
	--싱크로 소환시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cyan.SynSSCon)
	e1:SetTarget(c101214313.destg)
	e1:SetOperation(c101214313.desop)
	c:RegisterEffect(e1)
	--레벨 상승
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101214313.lvtg)
	e2:SetOperation(c101214313.lvop)
	c:RegisterEffect(e2)
end
function c101214313.synfilter1(c)
	return c:IsRace(RACE_THUNDER)
end
function c101214313.desfilter(c,tc)
	return not c:IsLevelAbove(tc:GetLevel()+1)
end
function c101214313.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101214313.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c101214313.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.SelectMatchingCard(tp,c101214313.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c)
		if g1:GetCount()>0 then
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
function c101214313.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214313.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsLevelAbove(1) then
			local op=Duel.SelectOption(tp,aux.Stringid(101214313,0),aux.Stringid(101214313,1),aux.Stringid(101214313,2))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(op+1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			tc:RegisterEffect(e1)
		end
		if (tc:IsLevelBelow(12) or tc:IsStatus(STATUS_NO_LEVEL))
			and Duel.SelectYesNo(tp,aux.Stringid(101214313,3)) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
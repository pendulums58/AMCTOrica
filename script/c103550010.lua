--스토리텔러-해피엔드의 길
function c103550010.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x64a),3,2)
	c:EnableReviveLimit()
	--마함 제외
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(103550010,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c103550010.rmcon)
	e1:SetTarget(c103550010.rmtg)
	e1:SetOperation(c103550010.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c103550010.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--추가 공격 획득
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103550010,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cyan.ovcost(1))
	e3:SetTarget(c103550010.target)
	e3:SetOperation(c103550010.operation)
	c:RegisterEffect(e3)	
end
function c103550010.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c103550010.vfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c103550010.vfilter(c)
	return c:GetOriginalType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c103550010.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function c103550010.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c103550010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c103550010.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103550010.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c103550010.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c103550010.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c103550010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsAbleToEnterBP() 
		and Duel.IsExistingMatchingCard(c103550010.filter,tp,LOCATION_SZONE,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c103550010.filter,tp,LOCATION_SZONE,0,nil)
	e:SetLabel(ct)
end
function c103550010.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end	
end
function c103550010.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
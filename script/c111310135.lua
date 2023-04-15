--SQL 스컬프터
function c111310135.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()	
	--효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c111310135.rmtg)
	e1:SetOperation(c111310135.rmop)
	c:RegisterEffect(e1)
end
function c111310135.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ad=e:GetHandler():GetAdmin()
	if chkc then return ad and chkc:IsLocation(LOCATION_MZONE) and c111310135.filter(chkc,ad) end
	if chk==0 then return Duel.IsExistingTarget(c111310135.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ad) end
	local tc=Duel.SelectTarget(tp,c111310135.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ad)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_MZONE)
end
function c111310135.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(c111310135.spop)
		tc:RegisterEffect(e1)
	end
end
function c111310135.filter(c,ad)
	return c:IsFaceup() and c:GetAttack()>ad:GetAttack() and ad:IsType(TYPE_MONSTER)
end
function c111310135.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,p,p,false,false,POS_FACEUP)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end
--E(에너미).컨티뉴엄-레티
function c101235016.initial_effect(c)
	c:SetSPSummonOnce(101235016)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c101235016.lcheck)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101235016,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101235016)
	e1:SetTarget(c101235016.rmtg)
	e1:SetOperation(c101235016.rmop)
	c:RegisterEffect(e1)
end
function c101235016.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x653)
end
function c101235016.cfilter2(c,type)
	return c:IsType(type) and c:IsFaceup()
end
function c101235016.cfilter(c,tp)
	return (c:IsFaceup() and c:IsLocation(LOCATION_REMOVED)) and Duel.IsExistingMatchingCard(c101235016.spfilter,tp,0,LOCATION_ONFIELD,1,nil,c:GetType())
end
function c101235016.spfilter(c,type)
	return c:IsAbleToRemove() and c:IsFaceup() and c:IsType(type)
end
function c101235016.tgfilter1(c,tp)
	return c:IsAbleToRemove() and c:IsFaceup() and Duel.IsExistingMatchingCard(c101235016.tgfilter2,tp,LOCATION_REMOVED,0,1,nil,c:GetType())
end
function c101235016.tgfilter2(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function c101235016.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(c101235016.cfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101235016.tgfilter1,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101235016.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local type=tc:GetType()
	if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c101235016.cfilter2,tp,LOCATION_REMOVED,0,1,nil,type) then
		local g=Duel.SelectMatchingCard(tp,c101235016.cfilter2,tp,LOCATION_REMOVED,0,1,1,nil,type)
		local ttc=g:GetFirst()
		local tcode=ttc:GetCode()
		Duel.Exile(ttc,REASON_EFFECT)
		local token=Duel.CreateToken(tp,tcode)
		Duel.Remove(token,POS_FACEDOWN,REASON_EFFECT)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

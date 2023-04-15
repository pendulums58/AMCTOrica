--환계 - 용천
function c101263005.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101263005,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101263005.cost)
	e2:SetTarget(c101263005.tg)
	e2:SetOperation(c101263005.op)
	c:RegisterEffect(e2)	
	--대체 릴리스
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DRACO_ADD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(3)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function c101263005.cfilter(c,e,tp)
    return c:IsRace(RACE_WYRM) and c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c101263005.sfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalLevel())
end
function c101263005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101263005.sfilter(c,lv)
	return c:IsSetCard(0x62f) and c:GetOriginalLevel()==lv and c:IsAbleToHand()
end
function c101263005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c101263005.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c101263005.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101263005.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
	local gc=e:GetLabelObject()	
	local g=Duel.SelectMatchingCard(tp,c101263005.sfilter,tp,LOCATION_DECK,0,1,1,nil,gc:GetOriginalLevel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
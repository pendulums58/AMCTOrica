--컨티뉴엄 옵저브
function c101235009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101235009)
	e1:SetOperation(c101235009.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTarget(c101235009.reptg)
	e2:SetCountLimit(1,101235909)
	e2:SetValue(c101235009.repval)
	e2:SetOperation(c101235009.repop)
	c:RegisterEffect(e2)
end
function c101235009.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x653) and c:IsAbleToHand()
end
function c101235009.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101235009.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101235009,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101235009.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x653) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp)
end
function c101235009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and eg:IsExists(c101235009.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101235009.repval(e,c)
	return c101235009.repfilter(c,e:GetHandlerPlayer())
end
function c101235009.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Exile(e:GetHandler(),REASON_EFFECT)
	local token=Duel.CreateToken(tp,101235009)
	Duel.Hint(HINT_CARD,0,101235009)
	Duel.Remove(token,POS_FACEDOWN,REASON_EFFECT)
end

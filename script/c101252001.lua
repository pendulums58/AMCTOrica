--한정해제식『가석방』
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Ritual.CreateProc({handler=c,location=LOCATION_GRAVE,lvtype=RITPROC_EQUAL,filter=aux.FilterBoolFunction(Card.IsSetCard,SETCARD_FOREGONE),extrafil=s.extragroup,forcedselection=s.ritcheck})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--묘지 회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.con)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.tg)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.matfilter1(c)
	return c:IsAbleToGrave() and c:IsLevelAbove(1)
end
function s.extragroup(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_EXTRA,0,nil)
end
function s.ritcheck(e,tp,g,sc)
	local extrac=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	return extrac==0 or (bit.band(sc:GetReason(),0x41)==0x41)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chk,1,nil,tp) and aux.exccon(e,tp,eg,ep,ev,re,r,rp)
end
function s.chk(c,tp)
	return c:IsControler(tp) and c:IsCode(CARD_FOREGONE)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
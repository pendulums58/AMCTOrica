--별바라기 부적
local s,id=GetID()
function s.initial_effect(c)
	--패에서 발동 가능
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.handcon)
	c:RegisterEffect(e1)
	--기프트 회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	cyan.JustSearch(e3,LOCATION_GRAVE,Card.IsNormalSpell,true)
	c:RegisterEffect(e3)
	--덤핑
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	cyan.JustDump(e4,1,1,Card.IsType,TYPE_SPELL)
	c:RegisterEffect(e4)	
end
function s.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	local tc=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.tgfilter(c)
	return c:IsType(TYPE_GIFT)
end
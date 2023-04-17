--기프트 테스트 카드(pre)
local s,id=GetID()
function s.initial_effect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetAttribute)>=6
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.eqchk,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.eqchk,tp,LOCATION_SZONE,0,1,1,nil)
	e:SetLabel(g:GetCount())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.CheckGiftEffect(tp,s.gfilter) end
	local ct=e:GetLabel()
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,tc:GetCount(),tp,LOCATION_ONFIELD)
end
function s.gfilter(c)
	return c:IsSetCard(SETCARD_ILLUSIONARMS)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)	
	Duel.AddGiftEffect(e,s.gfilter,s.geffect,2500,2500)
end
function s.geffect(e,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler()GetEquipGroupCount()
	if chk==0 then #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_SZONE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	if g:GetCount()>0 then
		local tc=g:Select(tp,1,1,nil)
		if tc:GetCount()>0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
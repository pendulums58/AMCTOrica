--패러리얼 트레이스마스터
function c101244000.initial_effect(c)
	--넘겨서 패에 더한다
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101244000,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101244000.thtg)
	e1:SetOperation(c101244000.thop)
	c:RegisterEffect(e1)
	--묘지에서 회수한다
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101244000,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101244000)
	e2:SetCost(c101244000.cost)
	e2:SetTarget(c101244000.tg)
	e2:SetOperation(c101244000.op)
	c:RegisterEffect(e2)
end
function c101244000.thfilter(c)
	return c:IsSetCard(0x61e) and c:IsAbleToHand()
end
function c101244000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c101244000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c101244000.thfilter,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c101244000.costfilter(c,tp)
	return c:GetOwner()==1-tp and c:IsAbleToGraveAsCost()
end
function c101244000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101244000.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c101244000.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
end
function c101244000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local ctype=0
	local lb=e:GetLabelObject()
	for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if lb:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
	end
	Duel.SetChainLimit(c101244000.chlimit(ctype))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101244000.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c101244000.chlimit(ctype)
	return function(e,ep,tp)
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end
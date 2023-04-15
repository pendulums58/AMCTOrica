--컨티뉴엄 인베이드
function c101235012.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101235012,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101235012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c101235012.cost)
	e2:SetTarget(c101235012.target)
	e2:SetOperation(c101235012.activate)
	c:RegisterEffect(e2)
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c101235012.actcon)
	c:RegisterEffect(e3)
	if not c101235012.global_check then
		c101235012.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c101235012.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101235012.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x653) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(101235012,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c101235012.actcon(e)
	return e:GetHandler():GetFlagEffect(101235012)>0
end
function c101235012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,2,nil)
	local ct=g:GetCount()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c101235012.mfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c101235012.filter(c,e,tp)
	return (c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,true,true)) or (c:IsFaceup() and c:IsSSetable())
end
function c101235012.sfilter(c,e,tp)
	return c:IsFaceup() and c:IsSSetable()
end
function c101235012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101235012.filter(chkc,e,tp) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101235012.mfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp)) or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101235012.sfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp)) end
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101235012.mfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp)) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c101235012.sfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c101235012.filter,tp,0,LOCATION_REMOVED,1,1,nil,e,tp)
	elseif (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101235012.mfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c101235012.mfilter,tp,0,LOCATION_REMOVED,1,1,nil,e,tp)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c101235012.sfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectTarget(tp,c101235012.sfilter,tp,0,LOCATION_REMOVED,1,1,nil,e,tp)
	end
end
function c101235012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local typ=tc:GetType()
	if (typ & TYPE_MONSTER)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	if (typ & TYPE_SPELL+TYPE_TRAP)>0 and tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
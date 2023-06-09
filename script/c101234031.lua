--여환무장【프로스트리프】
function c101234031.initial_effect(c)
	--링크 소환
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c101234031.lcheck)
	--묘지 제외/장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101234031.cost)
	e1:SetTarget(c101234031.target)
	e1:SetOperation(c101234031.operation)
	c:RegisterEffect(e1)
	--패특소
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101234031)
	e2:SetCondition(c101234031.spcon)
	e2:SetTarget(c101234031.sptg)
	e2:SetOperation(c101234031.spop)
	c:RegisterEffect(e2)
	--덱바운스
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101234931)
	e3:SetCost(c101234031.recost)
	e3:SetTarget(c101234031.retg)
	e3:SetOperation(c101234031.reop)
	c:RegisterEffect(e3)
end
function c101234031.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c101234031.filter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101234031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101234031.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101234031.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101234031.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101234031.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101234031.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c101234031.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c101234031.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c101234031.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or g:GetCount()==0 then return end
	local tc=g:GetFirst()
	if tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,c101234031.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local eqc=eq:GetFirst()
	if eqc and Duel.Equip(tp,eqc,tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101234031.eqlimit)
		e1:SetLabelObject(tc)
		eqc:RegisterEffect(e1)
	end
end
function c101234031.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101234031.drfilter(c)
	return c:GetEquipTarget():IsSetCard(0x611) and c:GetEquipTarget():GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c101234031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101234031.drfilter,1,nil)
end
function c101234031.spfilter(c,e,tp)
	return c:IsSetCard(0x611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101234031.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101234031.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101234031.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101234031.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101234031.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	e:SetLabelObject(tc)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101234031.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101234031.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
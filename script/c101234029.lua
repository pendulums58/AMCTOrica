--성여환무장【콜브랜드】
function c101234029.initial_effect(c)
	--자체특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101234029)
	e1:SetCost(c101234029.cost)
	e1:SetTarget(c101234029.target)
	e1:SetOperation(c101234029.operation)
	c:RegisterEffect(e1)
	--장착
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101234929)
	e2:SetCondition(c101234029.drcon)
	e2:SetTarget(c101234029.drtg)
	e2:SetOperation(c101234029.drop)
	c:RegisterEffect(e2)
end
function c101234029.cfilter(c)
	return c:IsSetCard(0x611) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c101234029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101234029.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101234029.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101234029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101234029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101234029.drfilter(c)
	return c:GetEquipTarget():IsSetCard(0x611) and c:GetEquipTarget():GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c101234029.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101234029.drfilter,1,nil)
end
function c101234029.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,e:GetHandler(),TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c101234029.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),TYPE_MONSTER)
	local eqc=eq:GetFirst()
	if eqc and Duel.Equip(tp,eqc,c) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101234029.eqlimit)
		e1:SetLabelObject(c)
		eqc:RegisterEffect(e1)
	end
end
function c101234029.eqlimit(e,c)
   return c==e:GetLabelObject()
end
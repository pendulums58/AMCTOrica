--유환성궁 브리즈리버
function c103551004.initial_effect(c)
	--패특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103551004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,103551004)
	e1:SetCost(c103551004.spcost)
	e1:SetTarget(c103551004.sptg)
	e1:SetOperation(c103551004.spop)
	c:RegisterEffect(e1)	
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c103551004.eqcheck)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,103551904)
	e3:SetCondition(c103551004.thcon)
	e3:SetTarget(c103551004.thtg)
	e3:SetOperation(c103551004.thop)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
end
function c103551004.costfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and not c:IsPublic() and c:CheckEquipTarget(ec)
end
function c103551004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103551004.costfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c103551004.costfilter,tp,LOCATION_HAND,0,1,1,nil,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
end
function c103551004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c103551004.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 
		and e:GetLabelObject():IsLocation(LOCATION_HAND) then
		Duel.Equip(tp,e:GetLabelObject(),e:GetHandler())
	end
end
function c103551004.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c103551004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_PAIRING
		and e:GetHandler():GetReasonCard():IsSetCard(0x64b)
end
function c103551004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject():GetLabelObject()
	if chk==0 then return g:IsExists(c103551004.thfilter,1,nil,e) end
	local sg=g:Filter(c103551004.thfilter,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,LOCATION_GRAVE)
end
function c103551004.thfilter(c,e)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()
end
function c103551004.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabelObject()
	local sg=g:Filter(aux.NecroValleyFilter(c103551004.thfilter),nil,e)
	local spg=sg:Select(tp,1,1,nil)
	if spg:GetCount()>0 then
		local tc=spg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--환영검사 그리게일
function c101255003.initial_effect(c)
	--패특소
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101255003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101255003)
	e1:SetCost(c101255003.spcost)
	e1:SetTarget(c101255003.sptg)
	e1:SetOperation(c101255003.spop)
	c:RegisterEffect(e1)	
	--생성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101255103)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101255003.mktg)
	e2:SetOperation(c101255003.mkop)
	c:RegisterEffect(e2)
end
function c101255003.costfilter(c,ec)
	return c:IsSetCard(0x627) and c:IsType(TYPE_EQUIP) and not c:IsPublic() and c:CheckEquipTarget(ec)
end
function c101255003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101255003.costfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101255003.costfilter,tp,LOCATION_HAND,0,1,1,nil,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
end
function c101255003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c101255003.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 
		and e:GetLabelObject():IsLocation(LOCATION_HAND) then
		Duel.Equip(tp,e:GetLabelObject(),e:GetHandler())
	end
end
function c101255003.desfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x627)
end
function c101255003.mktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c101255003.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101255003.desfilter,tp,LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c101255003.desfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
end
function c101255003.mkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local token=Duel.CreateToken(tp,tc:GetCode())
		Duel.SendtoHand(token,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
	end
end
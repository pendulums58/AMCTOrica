--진원기록『묵시록』
function c101246010.initial_effect(c)
	--자신을 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101246010,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101246010)
	e1:SetCost(c101246010.spcost)
	e1:SetTarget(c101246010.sptg)
	e1:SetOperation(c101246010.spop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--특수 소환시 제외
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101246003,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,101246110)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c101246010.rmtg)
	e3:SetOperation(c101246010.rmop)
	c:RegisterEffect(e3)
	--전투내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101246010.desreptg)
	e4:SetOperation(c101246010.desrepop)
	c:RegisterEffect(e4)	
end
function c101246010.sprfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c101246010.fselect(g,tp)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function c101246010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c101246010.sprfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return rg:GetClassCount(Card.GetAttribute)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c101246010.fselect,true,3,3,tp)
	if sg then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	else return false end
end
function c101246010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101246010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c101246010.tgfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x621,0x620) or c:IsType(TYPE_SPSUMMON))
end
function c101246010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101246010.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c101246010.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101246010.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetOperation(c101246010.thop)
			tc:RegisterEffect(e1)
	end
end
function c101246010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c101246010.desfilter(c,e)
	return c:IsSetCard(0x621,0x620) and c:IsAbleToRemove()
end
function c101246010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c101246010.desfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c101246010.desfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c101246010.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101246010)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
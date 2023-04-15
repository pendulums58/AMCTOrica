--승격의 때
function c101269000.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--덤핑
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101269000,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,101269000)
	e1:SetTarget(c101269000.tgtg)
	e1:SetOperation(c101269000.tgop)
	c:RegisterEffect(e1)
	--메인
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c101269000.condition)
	e2:SetTarget(c101269000.target)
	e2:SetCountLimit(2)
	e2:SetOperation(c101269000.activate2)
	c:RegisterEffect(e2)
	--파괴 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c101269000.desreptg)
	c:RegisterEffect(e3)
end
function c101269000.filter(c,e,tp)
	return c:IsControler(tp) and c:IsSetCard(0x641) 
		and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToHand())
end
function c101269000.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101269000.filter,1,nil,e,tp)
end
function c101269000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg and eg:GetCount()==1 and eg:IsExists(c101269000.filter,1,nil,e,tp) end
	eg:GetFirst():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c101269000.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local op=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			op=op+1
		end
		if tc:IsAbleToHand() then op=op+2 end
		if op==3 then op=Duel.SelectOption(tp,aux.Stringid(101269000,1),aux.Stringid(101269000,2))+1 end
		if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif op==2 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
		end 
	end
end
function c101269000.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x641) and c:IsAbleToGrave()
end
function c101269000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101269000.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101269000.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101269000.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101269000.cfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c101269000.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c101269000.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c101269000.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end

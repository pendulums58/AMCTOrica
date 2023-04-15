--방황의 신살마녀
function c101226017.initial_effect(c)
	--소생
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101226017)
	e1:SetTarget(c101226017.target)
	e1:SetOperation(c101226017.activate)
	c:RegisterEffect(e1)
	--제외하고 발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c101226017.atkop)
	c:RegisterEffect(e2)
end
function c101226017.filter(c,e,tp)
	return c:IsSetCard(0x612) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101226017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101226017.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101226017.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101226017.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101226017.spfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x612) and cyan.IsCanBeAdmin(c,tc)
end
function c101226017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_ACCESS) then
			if Duel.IsExistingMatchingCard(c101226017.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tc)
				and Duel.SelectYesNo(tp,aux.Stringid(101218016,0)) then
					local g=Duel.SelectMatchingCard(tp,c101226017.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc)
					if g:GetCount()>0 then
						Duel.Overlay(tc,g)
					end
			end
		end
	end
end
function c101226017.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
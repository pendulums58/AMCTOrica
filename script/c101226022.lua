--신살마녀의 기원
function c101226022.initial_effect(c)
	--발동시 효과 처리
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101226022+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101226022.target)
	c:RegisterEffect(e1)
	--영속효과로 수비표시 강제
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101226022.poscon)
	e2:SetOperation(c101226022.posop)
	c:RegisterEffect(e2)
end
function c101226022.tgfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(c101226022.spfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetAttack(),e,tp)
end
function c101226022.spfilter(c,atk,e,tp)
	return c:GetAttack()<atk and c:IsSetCard(0x612) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101226022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101226022.tgfilter(chkc,e,tp) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c101226022.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101226022,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c101226022.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c101226022.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c101226022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c101226022.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc:GetAttack(),e,tp):GetFirst()
		if g and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and not g:IsHasEffect(EFFECT_NECRO_VALLEY) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101226022.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsAttackAbove,1,nil,2500)
end
function c101226022.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsAttackAbove,nil,2500)
	local posg=g:Filter(c101226022.posfilter,nil)
	g:Sub(posg)
	if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
	if posg:GetCount()>0 then Duel.ChangePosition(posg,POS_FACEUP_DEFENSE) end
end
function c101226022.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
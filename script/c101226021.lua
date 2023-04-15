--신살마녀 세리코시스
c101226021.AccessMonsterAttribute=true
function c101226021.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101226021.afil1,c101226021.afil2)
	c:EnableReviveLimit()
	--몬스터 효과 면역
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101226021.econ)
	e1:SetValue(c101226021.efilter)
	c:RegisterEffect(e1)	
	--공격 대상 선택 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--묘지 제외
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101226021.condition)
	e3:SetTarget(c101226021.target)
	e3:SetOperation(c101226021.activate)
	c:RegisterEffect(e3)
end
function c101226021.afil1(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_ACCESS)
end
function c101226021.afil2(c)
	return c:GetLevel()>=5 and c:IsRace(RACE_SPELLCASTER)
end
function c101226021.econ(e)
	return cyan.adcon(e)
end
function c101226021.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c101226021.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and tc:GetControler()==1-tp
end
function c101226021.rmcheck(c,atk)
	return c:GetAttack()<atk
end
function c101226021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101226021.rmcheck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc:GetAttack()) 
		and Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)>0 end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
end
function c101226021.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroupCount(c101226021.rmcheck,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetAttack())
		if g>0 then
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,g,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end

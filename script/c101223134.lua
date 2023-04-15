--점적천석의 저항자
function c101223134.initial_effect(c)
	--전투 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101223134)
	e2:SetCondition(c101223134.spcon)
	e2:SetTarget(c101223134.sptg)
	e2:SetOperation(c101223134.spop)
	c:RegisterEffect(e2)
end
function c101223134.spcon(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetAttacker()
	return atk:IsControler(1-tp) and atk:GetAttack()>=3000
end
function c101223134.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetChainLimit(c101223134.climit)
end
function c101223134.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c101223134.climit(e,rp,tp)
	return not (rp==1-tp and e:GetHandler():GetAttack()>=3500)
end
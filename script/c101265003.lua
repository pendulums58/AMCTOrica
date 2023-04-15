--브레×플래그마타
function c101265003.initial_effect(c)
	--일 / 특소시 공통효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101265003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101265003)
	e1:SetTarget(c101265003.target)
	e1:SetOperation(c101265003.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)		
	--공통효과 추가
	cyan.AddFragmataEffect(c)	
end
function c101265003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101265003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,101265006,0x633,TYPES_TOKEN_MONSTER,0,0,1,RACE_PLANT,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,101265006)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	if Duel.GetCurrentPhase()==PHASE_END and Duel.SelectYesNo(tp,aux.Stringid(101265000,0)) then
		Duel.DecreaseMaxHandSize(e:GetHandler(),tp,1)
	end
end

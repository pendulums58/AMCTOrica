--어드민즈 브로큰피스
function c101223142.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101223142)
	e1:SetCost(c101223142.spcost)
	e1:SetTarget(c101223142.sptg)
	e1:SetOperation(c101223142.spop)
	c:RegisterEffect(e1)
	--증식의 G 부여
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101223143)
	e2:SetOperation(c101223142.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101223142.rfilter(c)
	return c:IsLevelAbove(1) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGraveAsCost()
end
function c101223142.fselect(g,tp)
	return g:GetSum(Card.GetLevel)==11 and aux.mzctcheck(g,tp)
end
function c101223142.gcheck(g)
	return g:GetSum(Card.GetLevel)<=11
end
function c101223142.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101223142.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	if chk==0 then
		return g:CheckWithSumEqual(Card.GetLevel,11,1,99)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectWithSumEqual(tp,Card.GetLevel,11,1,99)
	aux.GCheckAdditional=nil
	Duel.SendtoGrave(rg,REASON_COST)
end
function c101223142.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101223142.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c101223142.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101223142.drcon1)
	e1:SetOperation(c101223142.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101223142.regcon)
	e2:SetOperation(c101223142.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c101223142.drcon2)
	e3:SetOperation(c101223142.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101223142.drcon11)
	e4:SetOperation(c101223142.drop11)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c101223142.regcon1)
	e5:SetOperation(c101223142.regop1)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetCondition(c101223142.drcon21)
	e6:SetOperation(c101223142.drop21)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function c101223142.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101223142.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223142.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c101223142.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c101223142.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223142.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c101223142.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,101223142,RESET_CHAIN,0,1)
end
function c101223142.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101223142)>0
end
function c101223142.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,101223142)
	Duel.ResetFlagEffect(tp,101223142)
	Duel.Draw(1-tp,n,REASON_EFFECT)
end

function c101223142.drcon11(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223142.filter,1,nil,tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c101223142.drop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c101223142.regcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223142.filter,1,nil,tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c101223142.regop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1-tp,101223142,RESET_CHAIN,0,1)
end
function c101223142.drcon21(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,101223142)>0
end
function c101223142.drop21(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(1-tp,101223142)
	Duel.ResetFlagEffect(1-tp,101223142)
	Duel.Draw(tp,n,REASON_EFFECT)
end

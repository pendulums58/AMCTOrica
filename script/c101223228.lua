--신위에 앉은 거북이
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--의식 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.rcon)
	e1:SetCost(s.rcost)
	e1:SetTarget(s.rtg)
	e1:SetOperation(s.rop)
	c:RegisterEffect(e1)
	--소환 성공시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cyan.RitSSCon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()>=1800 and rp==1-tp
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local lv=tc:GetLevel()
	local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return tc:IsOnField() and g:CheckWithSumGreater(Card.GetLevel,c:GetLevel()-lv,1,99) 
		and tc:IsReleasable() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local lv=tc:GetLevel()
	local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND,0,nil)
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsReleasable() and g:CheckWithSumGreater(Card.GetLevel,c:GetLevel()-lv,1,99)
		and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		local rg=g:SelectWithSumGreater(tp,Card.GetLevel,c:GetLevel()-lv,1,99)
		rg:AddCard(tc)
		Duel.ReleaseRitualMaterial(rg)
		Duel.BreakEffect()
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true)
		c:CompleteProcedure()
	end
end
function s.rfilter(c)
	return c:IsLevelAbove(1) and c:IsReleasable()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local dp=Duel.GetTurnPlayer()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,dp,900)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local dp=Duel.GetTurnPlayer()
	Duel.Damage(dp,900,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
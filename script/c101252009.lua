--한정해제자 체이시아
local s,id=GetID()
function s.initial_effect(c)
	--의식 몬스터 취급
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	-- e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con)
	e1:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e1)	
	-- local e0=e1:Clone()
	-- e0:SetRange(LOCATION_DECK)
	-- c:RegisterEffect(e0)
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.spcon1)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(s.spcon)
	c:RegisterEffect(e3)
	--회복
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,{id,1})
	e4:SetCost(cyan.selfrelcost)
	e4:SetTarget(s.rctg)
	e4:SetOperation(s.rcop)
	c:RegisterEffect(e4)
end
function s.con(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chk,1,nil,tp)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chk,1,nil,tp) and r==REASON_EFFECT
end
function s.chk(c,tp)
	local ty=c:GetPreviousTypeOnField()
	return c:IsControler(tp) and bit.band(ty,TYPE_RITUAL)==TYPE_RITUAL and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,c:GetLocation())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function s.tgfilter(c)
	return c:IsAbleToGrave() and c:IsStarBelow(4) and c:GetAttack()>0
end
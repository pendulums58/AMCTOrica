--스카이워커 엑소스피어
function c101214314.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,c101214314.synfilter,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--레벨 상승
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.SynSSCon)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c101214314.lvtg)
	e1:SetOperation(c101214314.lvop)
	c:RegisterEffect(e1)
	--퍼미션
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101214314.discon)
	e2:SetTarget(c101214314.distg)
	e2:SetOperation(c101214314.disop)
	c:RegisterEffect(e2)
	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c101214314.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101214314,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101214314)
	e4:SetCondition(c101214314.thcon)
	cyan.JustSearch(e4,LOCATION_GRAVE,c101214314.thfilter,1)
	c:RegisterEffect(e4)	
end
function c101214314.synfilter(c)
	return c:IsRace(RACE_THUNDER)
end
function c101214314.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214314.chk,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c101214314.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c101214314.chk,tp,LOCATION_MZONE,0,e:GetHandler())
		if g:GetCount()>0 then
			local ct=g:GetSum(Card.GetLevel)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(ct)
			c:RegisterEffect(e1)
		end
	end
end
function c101214314.chk(c)
	return c:IsSetCard(0xef5) and c:IsLevelAbove(1) and c:IsFaceup()
end
function c101214314.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and e:GetHandler():IsLevelAbove(12)
end
function c101214314.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101214314.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=re:GetHandler():GetLevel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-lv)
	c:RegisterEffect(e1)	
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101214314.regop(e,tp,eg,ep,ev,re,r,rp)
	if not rp==1-tp then return end
	local c=e:GetHandler()
	c:RegisterFlagEffect(101214314,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c101214314.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101214314)>0
end
function c101214314.thfilter(c,lv)
	local tp=c:GetControler()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xef5)
		and not Duel.IsExistingMatchingCard(Card.IsLevelBelow,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel()-1)
end
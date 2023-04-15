--잔불씨를 틔우는 다리
function c111330011.initial_effect(c)
	--발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--토큰 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111330011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c111330011.sptg)
	e1:SetOperation(c111330011.spop)
	c:RegisterEffect(e1)
	--특수 소환 성공시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c111330011.descon)
	e2:SetTarget(c111330011.destg)
	e2:SetOperation(c111330011.desop)
	c:RegisterEffect(e2)
	--세트
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c111330011.setcost)
	e3:SetTarget(c111330011.settg)
	e3:SetOperation(c111330011.setop)
	c:RegisterEffect(e3)
end
function c111330011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,111330999,0,TYPES_TOKEN_MONSTER,200,200,1,RACE_PYRO,ATTRIBUTE_FIRE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c111330011.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,111330999,0,TYPES_TOKEN_MONSTER,200,200,1,RACE_PYRO,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,111330992+math.random(1,7))
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c111330011.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c111330011.filter,1,nil)
end
function c111330011.filter(c)
	return c:IsSetCard(0x638) and c:IsType(TYPE_MONSTER)
end
function c111330011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c111330011.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c111330011.rfilter(c,tp)
	return c:IsCode(111330999)
end
function c111330011.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(c111330011.rfilter,nil,tp)
	if chk==0 then return rg:GetCount()>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:Select(tp,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c111330011.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c111330011.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SSet(tp,c)
	end
end
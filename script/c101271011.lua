--버려진 차원의 월하미인
c101271011.AccessMonsterAttribute=true
function c101271011.initial_effect(c)
	cyan.AddAccessProcedure(c,c101271011.afil1,c101271011.afil2)
	c:EnableReviveLimit()
	--어드민 없으면 무효
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101271011,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101271011.discon)
	e1:SetTarget(c101271011.distg)
	e1:SetOperation(c101271011.disop)
	c:RegisterEffect(e1)
	--상대몹 3곳까지 선택해서 발동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c101271011.grop)
	c:RegisterEffect(e2)
	--어드민 떼기
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101271011.adcon)
	e3:SetOperation(c101271011.adop)
	c:RegisterEffect(e3)
end
function c101271011.afil1(c)
	return c:IsSetCard(0x642)
end
function c101271011.afil2(c)
	return c:IsType(TYPE_LINK) and c:GetSequence()<5
end
function c101271011.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==1-tp and c:GetAdmin()==nil and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c101271011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101271011.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101271011.grop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)	
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(101271011,0)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(101271011,0)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis2)		
			dis1=bit.bor(dis1,dis3)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if tp==1 then
		dis1=((dis1&0xffff)<<16)|((dis1>>16)&0xffff)
		e1:SetValue(dis1)	
	else
		e1:SetValue(dis1)
	end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c101271011.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:GetAdmin()~=nil
end
function c101271011.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end
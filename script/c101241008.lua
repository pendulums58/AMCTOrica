--선악과의 관리자
c101241008.AccessMonsterAttribute=true
function c101241008.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241008.afil1,c101241008.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101241008.con)
	e1:SetOperation(c101241008.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c101241008.rcon)
	c:RegisterEffect(e2)
	--선악체크
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101241008,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101241008+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c101241008.target)
	e3:SetOperation(c101241008.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCondition(c101241008.rcon)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101241008,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101241008.rmcon)
	e5:SetCost(c101241008.cost)
	e5:SetOperation(c101241008.rmop)
	c:RegisterEffect(e5)
end
function c101241008.afil1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttack(c:GetBaseAttack())
end
function c101241008.afil2(c)
	return c:IsType(TYPE_EFFECT)
end
function c101241008.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241008.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 그늘진 선악의 관리자가 암약했습니다.")
end
function c101241008.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetChainLimit(c101241008.chainlm)
end
function c101241008.chainlm(e,rp,tp)
	return tp==rp
end
function c101241008.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	sel=Duel.SelectOption(1-tp,aux.Stringid(101241008,0),aux.Stringid(101241008,1))
	if sel==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c101241008.actcon)
		e1:SetOperation(c101241008.regop)
		e1:SetLabel(ac)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(c101241008.damcon)
		e2:SetOperation(c101241008.damop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
	if sel==1 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0,0x7f)
		e3:SetTarget(c101241008.bantg)
		e3:SetLabel(ac)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetTargetRange(0,0x7f)
		e4:SetTarget(c101241008.bantg)
		e4:SetCode(EFFECT_CANNOT_TRIGGER)
		e4:SetLabel(ac)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c101241008.actcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	return rp==1-tp
end
function c101241008.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local tc=eg:GetFirst()
	if tc:IsCode(e:GetLabel()) then
		e:SetLabel(0)
	end
end
function c101241008.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0
end
function c101241008.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,3000,REASON_EFFECT)
end
function c101241008.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function c101241008.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad
end
function c101241008.cfilter2(c)
	return c:IsType(TYPE_ACCESS) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x605)
end
function c101241008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101241008.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101241008.cfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101241008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end
--블루벨의 관리자
c101241007.AccessMonsterAttribute=true
function c101241007.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241007.afil,aux.TRUE,c101241007.accheck)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101241007.con)
	e1:SetOperation(c101241007.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c101241007.rcon)
	c:RegisterEffect(e2)
	--효과 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c101241007.efilter)
	c:RegisterEffect(e3)
	--내성 부여 및 소재 제약 부여
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101241007,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,101241007)
	e4:SetCondition(c101241007.rcon)
	e4:SetTarget(c101241007.tg)
	e4:SetOperation(c101241007.op)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101241007,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101241007.rmcon)
	e5:SetOperation(c101241007.rmop)
	c:RegisterEffect(e5)
end
function c101241007.afil(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241007.accheck(c,tc,ac)
	local rc=tc:GetRace()
	if c:GetRace()==rc then return true end
	return false
end
function c101241007.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241007.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 영원불변의 관리자가 눈을 떴습니다.")
end
function c101241007.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241007.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c101241007.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101241007.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c101241007.efilter2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e6)
		local e7=e2:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e7)
		local e8=e2:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_ACCESS_MATERIAL)
		tc:RegisterEffect(e8)
		local e9=e2:Clone()
		e9:SetCode(EFFECT_CANNOT_BE_PAIRING_MATERIAL)
		tc:RegisterEffect(e9)
	end
end
function c101241007.efilter2(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c101241007.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and ad
end
function c101241007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end
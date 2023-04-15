--홍매화의 관리자
c101241011.AccessMonsterAttribute=true
function c101241011.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241011.afil1,c101241011.afil2)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101241011.con)
	e1:SetOperation(c101241011.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_CREATORGOD)
	e2:SetCondition(c101241011.rcon)
	c:RegisterEffect(e2)
	--장착
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101241011,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c101241011.eqtg)
	e3:SetOperation(c101241011.eqop)
	c:RegisterEffect(e3)
	--효과 내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(c101241011.rcon)
	e4:SetTarget(c101241011.indtg)
	e4:SetValue(c101241011.val)
	c:RegisterEffect(e4)
	--어드민 제거
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101241011,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101241011.rmcon)
	e5:SetOperation(c101241011.rmop)
	c:RegisterEffect(e5)
end
function c101241011.afil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c101241011.afil2(c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipCount()>0
end
function c101241011.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c101241011.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 거센 결사의 관리자가 참전했습니다.")
end
function c101241011.rcon(e)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101241011.eqmfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c101241011.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,c,tp)
end
function c101241011.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp)
end
function c101241011.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101241011.eqmfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101241011.eqmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101241011.eqmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c101241011.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c101241011.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
function c101241011.val(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c101241011.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101241011.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(c101241011.cfilter2,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_SZONE+LOCATION_GRAVE,2,c,c:GetCode())
end
function c101241011.cfilter2(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101241011.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return Duel.IsExistingMatchingCard(c101241011.cfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_SZONE+LOCATION_GRAVE,1,nil,tp) and ad
end
function c101241011.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end
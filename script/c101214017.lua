--스카이워커 엑소스피어
function c101214017.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,c101214017.synfilter,aux.NonTuner(c101214017.synfilter1),2)
	c:EnableReviveLimit()
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101214017.descon)
	e1:SetTarget(c101214017.destg)
	e1:SetOperation(c101214017.desop)
	c:RegisterEffect(e1)
	--소재 불가 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(c101214017.bfilter))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYHCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e5)
	--레벨상승
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(112400516,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,0x1e0)
	e6:SetTarget(c101214017.thtg)
	e6:SetOperation(c101214017.thop)
	c:RegisterEffect(e6)		
end
function c101214017.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c101214017.synfilter1(c)
	return c:IsRace(RACE_THUNDER)
end
function c101214017.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101214017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214017.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c101214017.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101214017.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101214017.filter1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xef5)
end
function c101214017.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101214017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	if re and re:GetHandler():IsSetCard(0x9ec7) then
		local g1=Duel.GetMatchingGroup(c101214017.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101214017.bfilter(c,e,tp)
	return c:GetLevel()>5
end
function c101214017.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c101214017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101214017.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101214017.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101214017.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101214017.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetLevel())
		tc:RegisterEffect(e1)
	end
end
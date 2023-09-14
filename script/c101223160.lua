--파르테리스의 지배력
function c101223160.initial_effect(c)
	c:SetUniqueOnField(1,0,101223160)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223160.actcon)
	c:RegisterEffect(e1)
	--공격력 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_ACCESS))
	e2:SetValue(c101223160.val)
	c:RegisterEffect(e2)
	--액세스 프로시저 특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c101223160.sptg)
	e3:SetOperation(c101223160.spop)
	c:RegisterEffect(e3)
	--데미지
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223160.rmcon)
	e5:SetTarget(c101223160.rmtg)
	e5:SetOperation(c101223160.rmop)	
	c:RegisterEffect(e5)	
end
function c101223160.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223160.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223160.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c101223160.val(e,c)
	local ad=c:GetAdmin()
	if ad==nil then return 0 end
	return ad:GetAttack()
end
function c101223160.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223160.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101223160.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,c101223160.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c101223160.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101223160.spfilter(c,e,tp)
	return (c:IsCode(111310014) or (c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(c101223160.spchk,tp,LOCATION_MZONE,0,1,nil,c)))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223160.spchk(c,tc)
	return c:IsSetCardList(tc) and c:IsType(TYPE_ACCESS) and c:IsFaceup()	
end
function c101223160.cfilter2(c,tp)
	return c:IsType(TYPE_ACCESS) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223160.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223160.cfilter2,1,nil,tp)
end
function c101223160.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c101223160.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
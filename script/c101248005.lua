--창성유물『구세성건』
c101248005.AccessMonsterAttribute=true
function c101248005.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101248005.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101248005.descon)
	e1:SetTarget(c101248005.destg)
	e1:SetOperation(c101248005.desop)
	c:RegisterEffect(e1)
	--진원기록 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetOperation(c101248005.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101248005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(c101248005.spcon)
	e3:SetTarget(c101248005.sptg)
	e3:SetOperation(c101248005.spop)
	c:RegisterEffect(e3)	
end
function c101248005.afil1(c)
	return c:GetLevel()==11
end
function c101248005.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c101248005.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad==nil then return false end
	if chkc then return chkc:IsOnField() and c101248005.desfilter(chkc,ad:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c101248005.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ad:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101248005.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ad:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101248005.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101248005.desfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk
end
function c101248005.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(101248005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c101248005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101248005)>0
end
function c101248005.filter(c,e,tp)
	return c:IsSetCard(0x620) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101248005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101248005.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101248005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101248005.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
--연환의 관리자
c111310078.AccessMonsterAttribute=true
function c111310078.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310078.afil1,aux.TRUE,c111310078.accheck)
	c:EnableReviveLimit()
	--관리자 메세지
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310078.con)
	e1:SetOperation(c111310078.thop)
	c:RegisterEffect(e1)
	--창조신족
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(RACE_CREATORGOD)
	e5:SetCondition(cyan.nacon)
	c:RegisterEffect(e5)
	--페어를 끊는다
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c111310078.prtg)
	e3:SetOperation(c111310078.prop)
	c:RegisterEffect(e3)
	--특수 소환
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(cyan.nacon)
	e4:SetTarget(c111310078.sptg)
	e4:SetOperation(c111310078.spop)
	c:RegisterEffect(e4)	
	--어드민 떼기
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c111310078.desreptg)
	e5:SetValue(c111310078.desrepval)
	e5:SetOperation(c111310078.desrepop)
	c:RegisterEffect(e5)
end
function c111310078.afil1(c)
	return c:IsType(TYPE_PAIRING)
end
function c111310078.accheck(c,tc,ac)
	local pr=tc:GetPair()
	if pr:IsExists(Card.IsRace,1,nil,c:GetRace) or pr:IsExists(Card.IsAttribute,1,nil,c:GetAttribute()) then return true end
	return false
end
function c111310078.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ACCESS and c:GetSummonLocation()==LOCATION_EXTRA
end
function c111310078.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("경고 : 맞잡은 납빛의 관리자가 참조되었습니다.")
end
function c111310078.pcfilter(c)
	return c:IsType(TYPE_PAIRING) and c:GetPairCount()>0
end
function c111310078.prtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsType(TYPE_PAIRING) and chkc:GetPairCount()>0 end
	if chk==0 then Duel.IsExistingTarget(c111310078.pcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c111310078.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c111310078.prop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:GetPairCount()>0 and tc:IsRelateToEffect(e) then
		Duel.CancelPair(tc)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
		if g:GetCount()>0 then c:SetPair(g) end
	end
end
function c111310078.spfilter(c,e,tp)
	return c:IsType(TYPE_PAIRING) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c111310078.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c111310078.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111310078.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c111310078.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c111310078.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:SetPair(e:GetHandler())
	end
end
function c111310078.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c111310078.repfilter,1,nil,tp)
		and c:GetAdmin()~=nil end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c111310078.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_PAIR) and not c:IsReason(REASON_REPLACE)
end
function c111310078.desrepval(e,c)
	return c111310078.repfilter(c,e:GetHandlerPlayer())
end
function c111310078.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	Duel.Hint(HINT_CARD,0,111310078)
	Duel.SendtoGrave(ad,REASON_EFFECT)
end
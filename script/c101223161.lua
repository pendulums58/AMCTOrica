--아이테르의 지배력
function c101223161.initial_effect(c)
	c:SetUniqueOnField(1,0,101223161)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223161.actcon)
	c:RegisterEffect(e1)
	--대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTarget(c101223161.tg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)	
	--소생
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101223161.sptg)
	e3:SetOperation(c101223161.spop)
	c:RegisterEffect(e3)
	--묘지로 되돌린다
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c101223161.rmcon)
	e5:SetTarget(c101223161.rmtg)
	e5:SetOperation(c101223161.rmop)	
	c:RegisterEffect(e5)
end
function c101223161.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223161.chk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223161.chk(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101223161.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101223161.tg(e,c)
	local tp=e:GetHandler():GetControler()
	local tg=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(c101223161.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		tg:Merge(tc:GetLinkedGroup())
	end	
	return tg:IsContains(c)
end
function c101223161.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223161.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101223161.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,c101223161.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c101223161.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tcc=Duel.ReadCard(tc,CARDDATA_SETCODE)
		local zone=0
		local g=Duel.GetMatchingGroup(c36492575.linkchk,tp,LOCATION_MZONE,0,nil,tcc)
		for tc1 in aux.Next(g) do
			zone=bit.bor(zone,tc1:GetLinkedZone(tp))
		end
		zone=bit.band(zone,0x1f)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)		
	end
end
function c101223161.linkchk(c,tcc)
	return c:IsSetCardList(tcc) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101223161.spfilter(c,e,tp)
	local tcc=Duel.ReadCard(c,CARDDATA_SETCODE)
	local zone=0
	local g=Duel.GetMatchingGroup(c36492575.linkchk,tp,LOCATION_MZONE,0,nil,tcc)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	zone=bit.band(zone,0x1f)
	return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101223161.cfilter2(c,tp)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c101223161.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101223161.cfilter2,1,nil,tp)
end
function c101223161.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223161.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c101223161.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101223161.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
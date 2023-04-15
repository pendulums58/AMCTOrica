--UX 컬렉터
c101241016.AccessMonsterAttribute=true
function c101241016.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241016.afil1,c101241016.afil2)
	c:EnableReviveLimit()
	--하이잭
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_HIIJACK_ACCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c101241016.hijack)
	c:RegisterEffect(e1)
	--카운터
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101241016.ccon)
	e2:SetOperation(c101241016.cop)
	c:RegisterEffect(e2)
	--턴최초 체크
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(0xff)
	e3:SetCondition(c101241016.bcon)
	c:RegisterEffect(e3)
	--카운터 제거 후 특소
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101241016)
	e4:SetCost(c101241016.spcost)
	e4:SetTarget(c101241016.sptg)
	e4:SetOperation(c101241016.spop)
	c:RegisterEffect(e4)
end
function c101241016.afil1(c)
	return c:IsRace(RACE_CYBERSE)
end
function c101241016.afil2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and bit.band(c:GetSummonLocation(),LOCATION_GRAVE)~=0
end
function c101241016.hijack(e,acc,hj)
	return acc:IsCode(101241015) and hj:IsLevelBelow(3)
end
function c101241016.tdfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_DECK)
end
function c101241016.thfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_HAND)
end
function c101241016.tefilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c101241016.trfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_REMOVED)
end
function c101241016.tgfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_GRAVE)
end
function c101241016.tmfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c101241016.tsfilter(c,tp)
	return c:GetControler()==tp and c:IsPreviousLocation(LOCATION_SZONE)
end
function c101241016.ccon(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if eg:IsExists(c101241016.tdfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241016)~=1 then
		ct=1
	end
	if eg:IsExists(c101241016.thfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241116)~=1 then
		ct=1
	end
	if eg:IsExists(c101241016.tefilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241216)~=1 then
		ct=1
	end
	if eg:IsExists(c101241016.trfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241316)~=1 then
		ct=1
	end
	if eg:IsExists(c101241016.tgfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241416)~=1 then
		ct=1
	end
	if eg:IsExists(c101241016.tmfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241516)~=1 then
		ct=1
	end
	if eg:IsExists(c101241016.tsfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241616)~=1 then
		ct=1
	end
	return ct==1
end
function c101241016.cop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1321,1)
end
function c101241016.bcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101241016.tdfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241016)~=1 then
		e:GetHandler():RegisterFlagEffect(101241016,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c101241016.thfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241116)~=1 then
		e:GetHandler():RegisterFlagEffect(101241116,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c101241016.tefilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241216)~=1 then
		e:GetHandler():RegisterFlagEffect(101241216,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c101241016.trfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241316)~=1 then
		e:GetHandler():RegisterFlagEffect(101241316,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c101241016.tgfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241416)~=1 then
		e:GetHandler():RegisterFlagEffect(101241416,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c101241016.tmfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241516)~=1 then
		e:GetHandler():RegisterFlagEffect(101241516,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c101241016.tsfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(101241616)~=1 then
		e:GetHandler():RegisterFlagEffect(101241616,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c101241016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1321)>0 end
	local ct=e:GetHandler():GetCounter(0x1321)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x1321,ct,REASON_COST)
end
function c101241016.spfilter(c,lvc,e,tp)
	return c:IsLevel(lvc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101241016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local lv=e:GetHandler():GetAdmin():GetLevel()
	if lv==nil then lv=0 end
	local lvc=ct+lv
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101241016.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,lvc,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101241016.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,lvc,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101241016.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
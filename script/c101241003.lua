--PM(프로토콜 마스터).34 링크 커넥터
c101241003.AccessMonsterAttribute=true
function c101241003.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101241003.afil1,c101241003.afil2)
	c:EnableReviveLimit()
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101241003.thcon)
	e1:SetTarget(c101241003.thtg)
	e1:SetOperation(c101241003.thop)
	c:RegisterEffect(e1)
	--토큰
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101241003)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101241003.spcost)
	e2:SetTarget(c101241003.sptg)
	e2:SetOperation(c101241003.spop)
	c:RegisterEffect(e2)
end
function c101241003.afil1(c)
	return c:IsType(TYPE_LINK)
end
function c101241003.afil2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsType(TYPE_TOKEN)
end
function c101241003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c101241003.filter(c,ad)
	return c:GetAttack()<ad:GetAttack() and c:IsType(TYPE_MONSTER)
end
function c101241003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c101241003.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler():GetAdmin()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101241003.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e:GetHandler():GetAdmin())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101241003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101241003.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsAbleToGraveAsCost()
end
function c101241003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101241003.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101241003.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then 
		e:SetLabel(g:GetFirst():GetLink())
		Duel.SendtoGrave(g,REASON_COST)
	end
end

function c101241003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101241020,0,0,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101241003.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,101241020,0,0,0,0,1,RACE_PSYCHO,ATTRIBUTE_LIGHT) then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101241020,0))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,101241020)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count==0
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,101241020))
	e1:SetValue(c101241003.lklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	Duel.RegisterEffect(e2,tp)
end
function c101241003.lklimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end

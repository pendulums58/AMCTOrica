--기적의 하늘
function c101214309.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101214309.op)
	c:RegisterEffect(e1)
	--메인 기동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetDescription(aux.Stringid(101214309,0))
	e2:SetCountLimit(1)
	e2:SetTarget(c101214309.atktg)
	e2:SetOperation(c101214309.atkop)
	c:RegisterEffect(e2)
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101214309,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,101214309)
	e3:SetCost(c101214309.spcost)
	e3:SetTarget(c101214309.sptg)
	e3:SetOperation(c101214309.spop)
	c:RegisterEffect(e3)
	--파괴 대체
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c101214309.reptg)
	e4:SetOperation(c101214309.repop)
	c:RegisterEffect(e4)
end
function c101214309.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x1324,1)
end
function c101214309.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214309.ck,tp,LOCATION_MZONE,0,1,nil) end
end
function c101214309.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=0
	local atk=0
	local g=Duel.GetMatchingGroup(c101214309.ck,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		atk=tc:GetLevel()*100
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)	
		if tc:GetLevel()>tc:GetOriginalLevel() then ct=ct+1 end
		tc=g:GetNext()
	end
	if ct>0 then
		c:AddCounter(0x1324,ct)
	end
end
function c101214309.ck(c)
	return c:IsSetCard(0xef5) and c:IsFaceup()
end
function c101214309.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mct=e:GetHandler():GetCounter(0x1324)
	if chk==0 then return Duel.IsExistingMatchingCard(c101214309.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mct) end
	local g=Duel.GetMatchingGroup(c101214309.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,mct)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	e:GetHandler():RemoveCounter(tp,0x1324,lv,REASON_COST)
	e:SetLabel(lv)	
end
function c101214309.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c101214309.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0xef5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101214309.spfilter1(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsSetCard(0xef5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101214309.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c101214309.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101214309.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x1324,3,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101214309.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1324,3,REASON_EFFECT)
end

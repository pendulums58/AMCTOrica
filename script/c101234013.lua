--결여환무장【아이기스】
function c101234013.initial_effect(c)
	--장착특소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101234013)
	e1:SetCost(c101234013.cost)
	e1:SetTarget(c101234013.target)
	e1:SetOperation(c101234013.operation)
	c:RegisterEffect(e1)
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101234913)
	e2:SetCondition(c101234013.drcon)
	e2:SetTarget(c101234013.drtg)
	e2:SetOperation(c101234013.drop)
	c:RegisterEffect(e2)
end
function c101234013.cfilter(c)
	return c:IsSetCard(0x611) and c:IsAbleToGraveAsCost()
end
function c101234013.eqfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234013.spfilter(c,e,tp)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101234013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101234013.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101234013.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101234013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101234013.eqfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c101234013.filter,tp,LOCATION_MZONE,0,1,nil) then ct=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101234013.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then ct=2
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c101234013.eqfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingTarget(c101234013.filter,tp,LOCATION_MZONE,0,1,nil) then ct=3
		end
	end
	if chk==0 then return ct>0 end
	if ct==3 then
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,1,tp,LOCATION_HAND)
	end
	if ct==2 then
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,1,tp,LOCATION_HAND)
	end
	if ct==1 then
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
	end
end
function c101234013.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct,sel=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101234013.eqfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c101234013.filter,tp,LOCATION_MZONE,0,2,nil) then ct=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0

		and Duel.IsExistingMatchingCard(c101234013.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then ct=2 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101234013.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then ct=2
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c101234013.eqfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingTarget(c101234013.filter,tp,LOCATION_MZONE,0,1,nil) then ct=3
		end
	end
	if ct==0 then return end
	if ct==3 then sel=Duel.SelectOption(tp,aux.Stringid(101234013,0),aux.Stringid(101234013,1)) end
	if ct==1 or sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c101234013.filter,tp,LOCATION_MZONE,0,1,1,nil,0x611)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or g:GetCount()==0 then return end
		local tc=g:GetFirst()
		if tc:IsFacedown() then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=Duel.SelectMatchingCard(tp,c101234013.eqfilter,tp,LOCATION_HAND,0,1,1,nil)
		local eqc=eq:GetFirst()
		if eqc and Duel.Equip(tp,eqc,tc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c101234013.eqlimit)
			e1:SetLabelObject(tc)
			eqc:RegisterEffect(e1)
		end
	end
	if ct==2 or sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local eq=Duel.SelectMatchingCard(tp,c101234013.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local eqc=eq:GetFirst()
		Duel.SpecialSummon(eqc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101234013.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101234013.drfilter(c)
	return c:GetEquipTarget():IsSetCard(0x611) and c:GetEquipTarget():GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c101234013.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101234013.drfilter,1,nil)
end
function c101234013.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101234013.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--컨티뉴엄 다이브
function c101235017.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--1번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c101235017.target1)
	e2:SetCountLimit(1,101235017)
	e2:SetOperation(c101235017.activate1)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
end
function c101235017.filter1(c)
	return c:IsSetCard(0x653) and c:IsAbleToRemove() and c:IsFaceup()
end
function c101235017.filter2(c,tp)
	return c:IsSetCard(0x653) and c:IsSSetable() and Duel.IsExistingMatchingCard(c101235017.filter4,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c101235017.filter3(c,e,tp)
	return c:IsSetCard(0x653) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c101235017.filter4,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c101235017.filter4(c,code)
	return c:IsSetCard(0x653) and c:IsCode(code)
end
function c101235017.tgfilter1(c,e,tp)
	return c:IsAbleToRemove() and c:IsFaceup() and Duel.IsExistingMatchingCard(c101235017.tgfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c101235017.tgfilter2(c,e,tp,code)
	return c:IsCode(code) and ((c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()) or (c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c101235017.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c101235017.tgfilter1(chkc) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c101235017.filter2,tp,LOCATION_DECK,0,1,nil,tp))
		or Duel.IsExistingMatchingCard(c101235017.filter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c101235017.tgfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c101235017.mfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101235017.sfilter(c,code)
	return c:IsCode(code) and c:IsSSetable()
end
function c101235017.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tcode=tc:GetCode()
	Duel.Exile(tc,REASON_EFFECT)
	local token=Duel.CreateToken(tp,tcode)
	Duel.Remove(token,POS_FACEDOWN,REASON_EFFECT)
	if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101235017.mfilter,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetCode()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101235017.mfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		local sc=g:GetFirst()
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local fid=e:GetHandler():GetFieldID()
			sc:RegisterFlagEffect(101235017,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_TURN_END)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabel(fid)
			e1:SetCondition(c101235017.ddcon)
			e1:SetLabelObject(sc)
			e1:SetCountLimit(1)
			e1:SetOperation(c101235017.ddop)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_REMOVED)
			sc:RegisterEffect(e2)
		end
	end
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c101235017.sfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c101235017.sfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		local sc=g:GetFirst()
		if sc and Duel.SSet(tp,sc)~=0 then
			local fid=e:GetHandler():GetFieldID()
			sc:RegisterFlagEffect(101235017,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EVENT_TURN_END)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetLabel(fid)
			e2:SetCondition(c101235017.ddcon)
			e2:SetLabelObject(sc)
			e2:SetCountLimit(1)
			e2:SetOperation(c101235017.ddop)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e3:SetValue(LOCATION_REMOVED)
			sc:RegisterEffect(e3)
		end
	end
end
function c101235017.ddcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(101235017)==e:GetLabel()
end
function c101235017.ddop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	Duel.Destroy(sc,REASON_EFFECT)
end
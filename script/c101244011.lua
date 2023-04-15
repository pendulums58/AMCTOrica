--패러리얼 디멘션포트
function c101244011.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c101244011.mfilter1,aux.TRUE,2,2,true)
	--내성 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c101244011.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101244011.regcon)
	e2:SetOperation(c101244011.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--도적질
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c101244011.cost)
	e3:SetOperation(c101244011.activate)
	c:RegisterEffect(e3)	
end
function c101244011.mfilter1(c)
	return c:IsFusionSetCard(0x61e) and c:IsFusionType(TYPE_MONSTER)
end
function c101244011.mfilter2(c)
	return not (c:IsSetCard(0x61e) and c:IsType(TYPE_MONSTER))
end
function c101244011.valcheck(e,c)
	local g=c:GetMaterial()
	g=g:Filter(c101244011.mfilter2,nil)
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c101244011.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101244011.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c101244011.efilter)
	e1:SetLabel(typ)
	c:RegisterEffect(e1)
	if bit.band(typ,TYPE_MONSTER)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101244011,0))
	end
	if bit.band(typ,TYPE_SPELL)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101244011,1))
	end
	if bit.band(typ,TYPE_TRAP)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101244011,2))
	end
end
function c101244011.efilter(e,te)
	return te:GetHandler():GetOriginalType()&e:GetLabel()~=0 and te:GetOwner()~=e:GetOwner()
end
function c101244011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101244011.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c101244011.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101244011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(1-tp,2)
	local g=Duel.GetDecktopGroup(1-tp,2)
	if g:GetCount()>0 then
		local sg=g:FilterSelect(tp,c101244011.thfilter,1,1,nil)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			local ctype=0
			for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
					if tc:GetOriginalType()&type~=0 then
						ctype=ctype|type
					end
			end		
			local th=Duel.SelectMatchingCard(tp,c101244011.thfilter1,tp,0,LOCATION_GRAVE,1,1,nil,ctype)
			if th:GetCount()>0 then
				Duel.SendtoHand(th,tp,REASON_EFFECT)
			end
		end
		
		
		Duel.ShuffleDeck(p)
	end
end
function c101244011.thfilter(c)
	local ctype=0
	for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if c:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
	end	
	return Duel.IsExistingMatchingCard(c101244011.thfilter1,tp,0,LOCATION_GRAVE,1,nil,ctype)
end
function c101244011.thfilter1(c,ty)
	return c:IsType(ty) and c:IsAbleToHand()
end
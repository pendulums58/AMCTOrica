--몰?루 아카이버
function c101223073.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,c101223073.mfilter,1,99)
	c:EnableReviveLimit()	
	--페어링 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetTarget(c101223073.tg)
	e1:SetOperation(c101223073.op)
	c:RegisterEffect(e1)
	--대상 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c101223073.indtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)	
end
function c101223073.mfilter(c,pair)
	local psc=Duel.ReadCard(pair,CARDDATA_SETCODE)
	return not c:IsSetCardList(psc)
end
function c101223073.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=e:GetHandler():GetMaterialCount()
	if chk==0 then return mc>0 end
end
function c101223073.op(e,tp,eg,ep,ev,re,r,rp)
	local mc=e:GetHandler():GetMaterialCount()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	g=g:Filter(c101223073.filter,nil)
	while mc>0 do
		local m=math.random(0,#g-1)
		local tc=g:GetFirst()
		while m>0 do
			tc=g:GetNext()
			m=m-1
		end
		c101223073.makemolru(tc)
		mc=mc-1
		g:RemoveCard(tc)
	end
end
function c101223073.filter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	local ct=0
	while mt.eff_ct[c][ct] do
		local e=mt.eff_ct[c][ct]
		local ty=e:GetType()
		if bit.band(ty,EFFECT_TYPE_TRIGGER_O)==EFFECT_TYPE_TRIGGER_O then return true end
		if bit.band(ty,EFFECT_TYPE_TRIGGER_F)==EFFECT_TYPE_TRIGGER_F then return true end
		if bit.band(ty,EFFECT_TYPE_QUICK_O)==EFFECT_TYPE_QUICK_O then return true end
		if bit.band(ty,EFFECT_TYPE_IGNITION)==EFFECT_TYPE_IGNITION then return true end
		ct=ct+1
	end
	return false
end
function c101223073.makemolru(c)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	local ct=0
	local effs={}
	local efct=1
	while mt.eff_ct[c][ct] do
		local e=mt.eff_ct[c][ct]
		local ty=e:GetType()
		if bit.band(ty,EFFECT_TYPE_TRIGGER_O)==EFFECT_TYPE_TRIGGER_O then
			effs[efct]=e
			efct=efct+1
		end
		if bit.band(ty,EFFECT_TYPE_TRIGGER_F)==EFFECT_TYPE_TRIGGER_F then
			effs[efct]=e
			efct=efct+1
		end
		if bit.band(ty,EFFECT_TYPE_QUICK_O)==EFFECT_TYPE_QUICK_O then
			effs[efct]=e
			efct=efct+1
		end
		if bit.band(ty,EFFECT_TYPE_IGNITION)==EFFECT_TYPE_IGNITION then
			effs[efct]=e
			efct=efct+1
		end
		ct=ct+1
	end	
	local t=math.random(1,#effs)
	local mole=effs[t]
	mole:SetOperation(c101223073.molru)
end
function c101223073.molru(e,tp,eg,ep,ev,re,r,rp)
	local zz=Duel.SelectOption(tp,aux.Stringid(101223073,0))
	local zz1=Duel.SelectOption(1-tp,aux.Stringid(101223073,0))
end
function c101223073.indtg(e,c)
	local tc=e:GetHandler()
	return c:IsFaceup() and tc:GetPair():IsContains(c) or c==tc
end
--발할라즈 메모리얼
function c101236011.initial_effect(c)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101236011)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101236011.blendtg)
	e1:SetOperation(c101236011.blendop)
	c:RegisterEffect(e1)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_CHEMICAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101236911)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101236011.cmtg)
	e2:SetOperation(c101236011.cmop)
	c:RegisterEffect(e2)
end
function c101236011.blendop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local dam=e:GetLabel()
	local tg=Duel.GetFirstTarget()
	if dam>0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		local op=te:GetOperation()
		if op~=nil then op(te,tp,eg,ep,ev,re,r,rp) end
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c101236011.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	local chk=0
	local ct=0
	while mt.eff_ct[c][ct] do
		local e1=mt.eff_ct[c][ct]
		if e1:GetCode()==EVENT_BLEND then
			local tg=e1:GetTarget()
			if tg==nil or (tg and tg(e1,tp,eg,ep,ev,re,r,rp,0)~=0) then chk=1 end
		end
		ct=ct+1
	end
	return c:IsSetCard(0x660) and chk==1
end
function c101236011.blendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101236011.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local g=Duel.SelectTarget(tp,c101236011.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		local c=g:GetFirst()
		local code=c:GetOriginalCode()
		local mt=_G["c"..code]
		local ct=0
		while mt.eff_ct[c][ct] do
			local e1=mt.eff_ct[c][ct]
			if e1:GetCode()==EVENT_BLEND then e:SetLabelObject(e1) end
			ct=ct+1
		end
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		if tg then
			tg(e1,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c101236011.blendop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tg=Duel.GetFirstTarget()
	local op=te:GetOperation()
	if op~=nil then op(te,tp,eg,ep,ev,re,r,rp) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c101236011.indtg)
	e1:SetValue(aux.indoval)
	Duel.RegisterEffect(e1,tp)
end
function c101236011.indtg(e,c)
	return (c:IsSetCard(0x658) or c:IsSetCard(0x660))
end
function c101236011.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236011.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236011.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236011.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236011.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236011.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x658) and c:IsType(TYPE_MONSTER)
end
function c101236011.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c101236011.cfilter1,tp,LOCATION_MZONE,0,nil)
	yipi.SelectChemical(tp,tc)
	while ct>1 do
		if Duel.SelectYesNo(tp,aux.Stringid(101236011,0)) then
		yipi.SelectChemical(tp,tc)
		ct=ct-1
		else break end
	end
	if Duel.SelectYesNo(tp,aux.Stringid(101236011,1)) then
		yipi.Blend(tc,tp)
	end
end
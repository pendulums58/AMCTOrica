--발할라즈 쓰로우
function c101236008.initial_effect(c)
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101236008)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101236008.blendtg)
	e1:SetOperation(c101236008.blendop)
	c:RegisterEffect(e1)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CHEMICAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101236908)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101236008.cmtg)
	e2:SetOperation(c101236008.cmop)
	c:RegisterEffect(e2)
end
function c101236008.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
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
	return c:IsSetCard(0x660) and c:GetAttack()>0 and chk==1
end

function c101236008.blendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101236008.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local g=Duel.SelectTarget(tp,c101236008.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
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
		e:SetLabel(c:GetAttack())
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
		local tg=te:GetTarget()
		if tg then
			tg(e1,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c101236008.blendop(e,tp,eg,ep,ev,re,r,rp)
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
function c101236008.cmfilter(c)
	return c:IsFaceup() and c:IsCode(101236009)
end
function c101236008.cmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101236008.cmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101236008.cmfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101236008.cmfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101236008.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x658) and c:IsType(TYPE_MONSTER)
end
function c101236008.cmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c101236008.cfilter,tp,LOCATION_MZONE,0,nil)
	yipi.SelectChemical(tp,tc)
	while ct>1 do
		if Duel.SelectYesNo(tp,aux.Stringid(101236008,0)) then
		yipi.SelectChemical(tp,tc)
		ct=ct-1
		else break end
	end
	if Duel.SelectYesNo(tp,aux.Stringid(101236008,1)) then
		yipi.Blend(tc,tp)
	end
end
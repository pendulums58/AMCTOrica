--잊혀진 신의 헌상품
function c103553008.initial_effect(c)
	aux.AddCodeList(c,103553000)
	--미즈키 획득
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c103553008.rctg)
	e1:SetOperation(c103553008.rcop)
	c:RegisterEffect(e1)
	--직접 공격 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c103553008.tdcost)
	e2:SetTarget(c103553008.tg)
	e2:SetOperation(c103553008.op)
	c:RegisterEffect(e2)
end
function c103553008.Inarichk(c)
	return c:IsCode(103553000) and c:IsFaceup()
end
function c103553008.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cyan.IsUnlockState(e,tp) end
	if Duel.IsExistingMatchingCard(c103553008.Inarichk,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
		Duel.SetChainLimit(c103553008.chainlm)
	end
end
function c103553008.chainlm(e,rp,tp)
	return tp==rp
end
function c103553008.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCondition(c103553008.drcon)
	e0:SetOperation(c103553008.drop)
	e0:SetCountLimit(1)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabel(0)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c103553008.lpcon1)
	e1:SetOperation(c103553008.lpop1)
	e1:SetLabelObject(e0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c103553008.regcon)
	e2:SetOperation(c103553008.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c103553008.lpcon2)
	e3:SetOperation(c103553008.lpop2)
	e3:SetLabelObject(e0)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	if Duel.IsExistingMatchingCard(c103553008.Inarichk,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c103553008.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>=5000
end
function c103553008.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c103553008.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsFaceup()
end
function c103553008.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c103553008.cfilter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c103553008.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c103553008.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	local val=Duel.Recover(tp,rnum,REASON_EFFECT)
	if val>0 then
		local lb=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(lb+val)
	end
end
function c103553008.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c103553008.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c103553008.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c103553008.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	Duel.RegisterFlagEffect(tp,103553008,RESET_CHAIN,0,1)
end
function c103553008.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,103553008)>0
end
function c103553008.lpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,103553008)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	local val=Duel.Recover(tp,rnum,REASON_EFFECT)
	if val>0 then
		local lb=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(lb+val)
	end
end
function c103553008.tdfilter(c)
	return aux.IsCodeListed(c,103553000) and c:IsAbleToDeckAsCost() and not c:IsCode(103553008)
end
function c103553008.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c103553008.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and e:GetHandler():IsAbleToDeckAsCost() end
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
	sg1:AddCard(e:GetHandler())
	Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c103553008.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c103553008.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103553008.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c103553008.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c103553008.tgfilter(c)
	return c:IsCode(103553000) and c:IsFaceup()
end
function c103553008.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
	cyan.AddFuriosoStack(tp,1)
end
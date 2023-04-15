--페네트레이트 로드
local s,id=GetID()
function s.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if not  Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
		Duel.SetChainLimit(s.chlimit)
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		if op==0 then
			local g=tc:GetColumnGroup()
			Duel.Destroy(g,REASON_EFFECT)
		else
			local dg=Group.CreateGroup()
			dg:AddCard(tc)
			if tc:IsLocation(LOCATION_MZONE) then
				if tc:GetSequence()<5 then
					--Own zone and horizontally adjancent | Vertical adjancent zone
					local g1=Duel.GetMatchingGroup(s.seqchkm,tc:GetControler(),LOCATION_MZONE,0,nil,tc:GetSequence())
					dg:Merge(g1)
				end
			elseif tc:IsLocation(LOCATION_FZONE) then
				local gg=Duel.GetMatchingGroup(s.seqchkf,tc:GetControler(),LOCATION_MZONE,0,nil)
				dg:Merge(gg)
			else
				local g2=Duel.GetMatchingGroup(s.seqchkm,tc:GetControler(),LOCATION_SZONE,0,nil,tc:GetSequence())
				dg:Merge(g2)				
			end
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function s.seqchkm(c,seq)
	return c:GetSequence()==(7<<(seq-1))&0x1F
end
function s.seqchks(c,seq)
	return c:GetSequence()==(7<<(seq+7))&0x1F00
end
function s.seqchkf(c,seq)
	return c:GetSequence()==0
end

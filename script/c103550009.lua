--스토리텔러-성광의 각수
function c103550009.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,c103550009.matfilter,3,2,nil,nil,99)
	c:EnableReviveLimit()	
	--효과 발동 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetDescription(aux.Stringid(103550009,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c103550009.con)
	e1:SetTarget(c103550009.tg)
	e1:SetOperation(c103550009.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c103550009.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(103550009,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cyan.ovcost(1))
	e3:SetTarget(c103550009.destg)
	e3:SetOperation(c103550009.desop)
	c:RegisterEffect(e3)
end
function c103550009.matfilter(c)
	return c:IsSetCard(0x64a)
end
function c103550009.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function c103550009.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local x=0 
	while tc do
		if tc:IsType(TYPE_CONTINUOUS) and tc:IsType(TYPE_SPELL) then
		else
			x=1
		end
		tc=g:GetNext()
	end
	if x==0 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)	
	end
end
function c103550009.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c103550009.chainlm)	
end
function c103550009.chainlm(e,rp,tp)
	return tp==rp
end
function c103550009.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c103550009.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)	
end
function c103550009.aclimit(e,re,tp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c103550009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayGroup():IsExists(c103550009.fchk,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end
function c103550009.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local ct=e:GetHandler():GetOverlayGroup():FilterCount(c103550009.chk,nil)
		if ct>0 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
function c103550009.fchk(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
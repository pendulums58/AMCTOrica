--전소의 잔불여우
function c111330004.initial_effect(c)
	--엑시즈 소환
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x638),3,2)
	c:EnableReviveLimit()
	--카드 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cyan.ovcost(2))
	e1:SetTarget(c111330004.destg)
	e1:SetOperation(c111330004.desop)
	c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c111330004.thcon)
	e2:SetTarget(c111330004.destg1)
	e2:SetOperation(c111330004.desop1)
	c:RegisterEffect(e2)	
	--파괴된 매수 카운트
	aux.GlobalCheck(c111330004,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c111330004.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c111330004.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),111330004,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c111330004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,111330004)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,Duel.GetFlagEffect(tp,111330004),2,LOCATION_ONFIELD)
end
function c111330004.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,111330004)
	if ct>0 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c111330004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111330004.deschk,1,nil,tp)
end
function c111330004.deschk(c,tp)
	return c:IsPreviousControler(tp) and c:GetPreviousLocation(LOCATION_MZONE)
end
function c111330004.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tc:GetControler(),LOCATION_ONFIELD)
end
function c111330004.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
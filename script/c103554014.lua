--플라워힐의 릴리나이트
function c103554014.initial_effect(c)
	c:EnableReviveLimit()
	--필드 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,103554014)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.RitSSCon)
	e1:SetTarget(c103554014.attg)
	e1:SetOperation(c103554014.atop)
	c:RegisterEffect(e1)
	--덤핑 / 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,103554015)
	e2:SetCondition(c103554014.reccon)
	e2:SetTarget(c103554014.rectg)
	e2:SetOperation(c103554014.recop)
	c:RegisterEffect(e2)
end
function c103554014.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsSetCard(0x657)
end
function c103554014.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554014.filter,tp,LOCATION_HAND,0,1,nil,tp) end
	if Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0 then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
	else
		e:SetLabel(0)
	end
end
function c103554014.atop(e,tp,eg,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103554014.filter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	local te=tc:GetActivateEffect()
	if te:IsActivatable(tp,true,true) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		if e:GetLabel()==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c103554014.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c103554014.tgfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToGrave()
end
function c103554014.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103554014.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_FIELD)
	if g:GetClassCount(Card.GetCode)>=4 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c103554014.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103554014.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_FIELD)
		if g1:GetClassCount(Card.GetCode)>=4 
			and Duel.IsExistingMatchingCard(c103554014.thfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(103554014,0)) then
			local g2=Duel.SelectMatchingCard(tp,c103554014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
			end
			
		end		
	end
end
function c103554014.thfilter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_PLANT)
end
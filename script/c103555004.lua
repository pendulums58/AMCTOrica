--벚꽃 다리
function c103555004.initial_effect(c)
	--함정 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c103555004.op)
	c:RegisterEffect(e1)
	--엑스트라 덱 복제
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c103555004.regop)
	c:RegisterEffect(e2)
	cyan.AddSakuraEffect(c)	
end
function c103555004.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x65a))
	e1:SetValue(c103555004.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c103555004.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c103555004.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1,103555004)
		e1:SetCondition(c103555004.thcon)
		e1:SetTarget(c103555004.extg)
		e1:SetOperation(c103555004.exop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c103555004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0	
end
function c103555004.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA,0,1,nil,0x65a) end
end
function c103555004.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleExtra(1-tp)
	Duel.ConfirmExtratop(1-tp,1)
	local tc=Duel.GetExtraTopGroup(1-tp,1):GetFirst()
	local ty=tc:GetExtraType()
	if Duel.IsExistingMatchingCard(c103555004.rmfilter,tp,LOCATION_EXTRA,0,1,nil,ty) then
		local g=Duel.SelectMatchingCard(tp,c103555004.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil,ty)
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
			local token=Duel.CreateToken(tp,tc:GetCode())
			Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
			Duel.ConfirmCards(token,1-tp)
			if token:IsType(TYPE_FUSION) then
				aux.AddFusionProcFunRep(token,aux.FilterBoolFunction(Card.IsFusionSetCard,0x65a),3,false)
			end
			if token:IsType(TYPE_SYNCHRO) then
				aux.AddSynchroProcedure(token,nil,aux.NonTuner(nil),1)
			end
			if token:IsType(TYPE_XYZ) then
				aux.AddXyzProcedure(token,aux.FilterBoolFunction(Card.IsSetCard,0x65a),3,2)
			end			
			if token:IsType(TYPE_ACCESS) then
				cyan.AddAccessProcedure(token,aux.TRUE,aux.TRUE)
			end	
			if token:IsType(TYPE_LINK) then
				aux.AddLinkProcedure(token,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
			end					
			if token:IsType(TYPE_PAIRING) then
				cyan.AddPairingProcedure(token,c103555004.pfilter,c103555004.mfilter,2,2)
			end				
		end
	end
end
function c103555004.rmfilter(c,ty)
	return c:IsAbleToRemove() and c:IsSetCard(0x65a) and c:IsType(ty)
end
function c103555004.pfilter(c)
	return c:IsSetCard(0x65a)
end
function c103555004.mfilter(c,pair)
	return c:GetLevel()>pair:GetLevel()
end
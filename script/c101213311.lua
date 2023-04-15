--시계탑을 되감다
function c101213311.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101213311.target)
	e1:SetOperation(c101213311.activate)
	c:RegisterEffect(e1)	
end
function c101213311.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0x60a)
end
function c101213311.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x60a)
end
function c101213311.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213311.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c101213311.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101213311.etarget)
	e1:SetValue(c101213311.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(c101213311.ssfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(101213311,0)) and Duel.IsExistingMatchingCard(c101213311.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		local g=Duel.SelectMatchingCard(tp,c101213311.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end		
	end
	if Duel.IsExistingMatchingCard(c101213311.ssfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		 and Duel.IsExistingMatchingCard(c101213311.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(101213311,1)) then
		local g1=Duel.SelectMatchingCard(tp,c101213311.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc1=g1:GetFirst()
		if tc1 then
			Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
		end		
	end
	if Duel.IsExistingMatchingCard(c101213311.ssfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101213311,2)) then
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
			  Duel.HintSelection(g2)
			  Duel.Destroy(g2,REASON_EFFECT)
			end		
	end
	if Duel.IsExistingMatchingCard(c101213311.ssfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_ACCESS) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(101213311,3)) and Duel.IsExistingMatchingCard(c101213311.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		local g3=Duel.SelectMatchingCard(tp,c101213311.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc3=g3:GetFirst()
		if tc3 then
			Duel.SpecialSummon(tc3,0,tp,tp,false,false,POS_FACEUP)
		end		
	end
	if Duel.IsExistingMatchingCard(c101213311.ssfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(101213311,4)) then
		Duel.Draw(tp,1,REASON_EFFECT)	
	end
end
function c101213311.ssfilter(c,ty)
	return c:IsType(ty) and c:IsSetCard(0x60a)
end
function c101213311.spfilter1(c,e,tp)
	return c:IsType(TYPE_ACCESS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213311.spfilter2(c,e,tp)
	return c:IsSetCard(0x60a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213311.spfilter3(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101213311.etarget(e,c)
	return c:IsSetCard(0x60a)
end
function c101213311.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
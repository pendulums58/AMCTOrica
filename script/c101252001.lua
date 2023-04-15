--한정해제식『가석방』
function c101252001.initial_effect(c)
	--의식 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101252001)
	e1:SetTarget(c101252001.target)
	e1:SetOperation(c101252001.activate)
	c:RegisterEffect(e1)
	--묘지 회수
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101252001,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101252001.setcon)
	e2:SetTarget(c101252001.thtg)
	e2:SetOperation(c101252001.thop)
	c:RegisterEffect(e2)	
end
function c101252001.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101252001.mtfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGrave() and c:IsCanBeRitualMaterial(c)
end
function c101252001.rfilter(c,e,tp,m1,m2,level_function)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x625) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if bit.band(c:GetReason(),0x41)==0x41 and c:IsLocation(LOCATION_GRAVE) then
		local mg1=Duel.GetMatchingGroup(c101252001.mtfilter,tp,LOCATION_EXTRA,0,nil)
		mg:Merge(mg1)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,"Equal")
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,"Equal")
	Auxiliary.GCheckAdditional=nil
	return res
end
function c101252001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c101252001.rfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,nil,Card.GetLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101252001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local g1=Duel.GetMatchingGroup(c101252001.rfilter,tp,LOCATION_GRAVE,0,nil,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local g=g1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then	
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if bit.band(tc:GetReason(),0x41)==0x41 then
			local mg1=Duel.GetMatchingGroup(c101252001.mtfilter,tp,LOCATION_EXTRA,0,nil)
			mg:Merge(mg1)			
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if g1:IsContains(tc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			if mat1:GetCount()>0 then
			mat:Sub(mat1)
			end
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)			
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c101252001.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsCode(65450690)
end
function c101252001.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101252001.tgfilter,1,nil,tp)
end
function c101252001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101252001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_GRAVE))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
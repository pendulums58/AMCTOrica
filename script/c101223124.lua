--알메리아의 명령
function c101223124.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101223124.condition)
	e1:SetCost(cyan.dhcost(1))
	e1:SetTarget(c101223124.tg)
	e1:SetOperation(c101223124.op)
	c:RegisterEffect(e1)	
end
function c101223124.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101223124.conchk,tp,LOCATION_MZONE,0,1,nil)
end
function c101223124.conchk(c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c101223124.tgfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101223124.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c101223124.thfilter(c,code)
	return c:IsAbleToHand() and aux.IsCodeListed(c,code)
end
function c101223124.thfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c101223124.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101223124.tgfilter(chkc,tp))
		or (chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasable()) end
	if chk==0 then
		local ct=0
		if Duel.IsExistingTarget(c101223124.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) then ct=ct+1 end
		if Duel.IsExistingTarget(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then ct=ct+1 end
		local mg=Duel.GetRitualMaterial(tp)
		if Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"equal") then
			ct=ct+1
		end
		if Duel.IsExistingMatchingCard(c101223124.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then ct=ct+1 end
		return ct>=2
	end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingTarget(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(101223124,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingTarget(c101223124.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) then
		ops[off]=aux.Stringid(101223124,2)
		opval[off-1]=2
		off=off+1
	end
	local mg=Duel.GetRitualMaterial(tp)
	if Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"equal") then
		ops[off]=aux.Stringid(101223124,3)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c101223124.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		ops[off]=aux.Stringid(101223124,4)
		opval[off-1]=4
		off=off+1
	end
	e:SetLabel(0)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		e:SetLabelObject(g)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223124.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif opval[op]==4 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	end	
	table.remove(ops,op+1)
	local op1=Duel.SelectOption(tp,table.unpack(ops))
	if op1>=op then op1=op1+1 end
	if opval[op1]==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		e:SetLabelObject(g)
	elseif opval[op1]==2 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g1=Duel.SelectTarget(tp,c101223124.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	elseif opval[op1]==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(e:GetLabel()+1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif opval[op1]==4 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetLabel(e:GetLabel()+2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	end	
end
function c101223124.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)	
	if g and g:GetCount()>0 then
		local g1=Duel.GetLabelObject()
		if g1 and g1:GetCount()>0 then g:Sub(g1)
			if g1:GetFirst():IsRelateToEffect(e) then
				Duel.Release(g1,REASON_EFFECT)
			end
		end	
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if tc:IsRelateToEffect(e) then
				local gg=Duel.SelectMatchingCard(tp,c101223124.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
				if gg:GetCount()>0 then
					Duel.SendtoHand(gg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,gg)
				end
			end
		end
	end
	
	
	local val=e:GetLabel()
	if bit.band(val,1)==1 then
		local mg=Duel.GetRitualMaterial(tp)
		local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"Equal")
		local rc=tg:GetFirst()
		if rc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,rc,rc)
			if rc.mat_filter then
				mg=mg:Filter(rc.mat_filter,rc,tp)
			else
				mg:RemoveCard(rc)
			end
			aux.GCheckAdditional=aux.RitualCheckAdditional(rc,rc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,rc:GetLevel(),tp,rc,rc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then
				aux.RCheckAdditional=nil
				return
			end
			rc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			rc:CompleteProcedure()
		end
	end
	if bit.band(val,2)==2 then
		locall thg=Duel.SelectMatchingCard(tp,c101223124.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
		end
	end
end
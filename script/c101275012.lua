--수렵 길드
local s,id=GetID()
function s.initial_effect(c)
    --발동
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--표적 특소시 카운터 / 서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.accon)
	e2:SetTarget(s.actg)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	--레벨 / 랭크 8 이상 필드 벗어날때 카운터
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.accon2)
	e3:SetOperation(s.acop2)
	c:RegisterEffect(e3)
	--카운터 소모
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetRange(LOCATION_FZONE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(s.huntcost)
	e4:SetTarget(s.hunttg)
	e4:SetOperation(s.huntop)
	c:RegisterEffect(e4)
end
function s.acfilter(c,tp)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return c:IsControler(1-tp) and lv>=8
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.acfilter,1,nil,tp)
end
function s.thfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false) and c:IsSetCard(SETCARD_HUNTER) and c:IsType(TYPE_MONSTER)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(COUNTER_HUNT,1,true)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and c:IsControler()==1-tp and lv>=8
end
function s.accon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.acop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(COUNTER_HUNT,1,true)
	end
end
function s.huntcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(COUNTER_HUNT)>0 end
	local mct=c:GetCounter(COUNTER_HUNT)
	if mct>3 then mct=3 end
	local ct=Duel.AnnounceLevel(tp,1,mct)
	if ct>0 then
		e:SetLabel(ct)
		c:RemoveCounter(tp,COUNTER_HUNT,ct,REASON_COST)
	else
		e:SetLabel(0)
	end
end
function s.hunttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	if ct>=1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end
	if ct>=2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	end
	if ct==3 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function s.huntthfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(SETCARD_HUNTTOOL) and c:IsType(TYPE_SPELL)
end
function s.huntspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false) and c:IsSetCard(SETCARD_HUNTTARGET) and c:IsType(TYPE_MONSTER)
end
function s.huntsp2filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false) and c:IsSetCard(SETCARD_HUNTER) and c:IsType(TYPE_MONSTER)
end
function s.huntop(e,tp,eg,ep,er,re,r,rp)
	local ct=e:GetLabel()
	if e:GetHandler():IsRelateToEffect(e) then
		if ct>=1 and Duel.IsExistingMatchingCard(s.huntthfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
			local thg=Duel.SelectMatchingCard(tp,s.huntthfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #thg>0 then
				Duel.SendtoHand(thg,nil,REASON_EFFECT)
				Duel.ConfirmCards(thg,1-tp)
			end
		end
		if ct>=2 and Duel.IsExistingMatchingCard(huntsp2filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local dg=Duel.SelectMatchingCard(tp,huntsp2filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #dg>0 and Duel.GetLoactionCount(tp,LOCATION_MZONE)>0 and Duel.GetLoactionCount(tp,LOCATION_SZONE)==0 then
				Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
			elseif #dg>0 and Duel.GetLoactionCount(tp,LOCATION_SZONE)>0 and Duel.GetLoactionCount(tp,LOCATION_MZONE)==0 then
				Duel.MoveToField(dg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				dg:RegisterEffect(e1)
			elseif #dg>0 and Duel.GetLoactionCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
			elseif #dg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.MoveToField(dg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				dg:RegisterEffect(e1)
			end
		end
		if ct==3 and Duel.IsExistingMatchingCard(s.huntspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=Duel.SelectMatchingCard(tp,huntspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if #spg>0 then
				Duel.SpecialSummon(spg,0,tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
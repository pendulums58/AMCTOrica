--밤하늘을 담은 물결
function c101269004.initial_effect(c)
	--호수 속에 담긴 밤하늘, 승격을 다루는 날개는 곧 펼쳐지리라
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101269004+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101269004.activate)
	c:RegisterEffect(e1)
	--은은히 빛나는 달 아래, 영웅은 쉽게 사그라들지 않으리
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c101269004.indcon)
	e2:SetTarget(c101269004.indtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--영웅의 검무는 전장에서 화려하게 꽃피고
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101269004,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101269004)
	e2:SetCost(c101269004.thcost)
	e3:SetCondition(c101269004.drcon)
	e3:SetTarget(c101269004.drtg)
	e3:SetOperation(c101269004.drop)
	c:RegisterEffect(e3)
	
end
function c101269004.filter(c)
	return c:IsCode(101269000) and c:IsAbleToHand()
end
function c101269004.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101269004.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101269004,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101269004.indcon(e)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c101269004.indtg(e,c)
	return c:IsType(TYPE_ACCESS) and c:IsSetCard(0x641)
end
function c101269004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101269004.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then return end
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsType(TYPE_ACCESS) and rc:IsSetCard(0x641) and rc:IsControler(tp)
end
function c101269004.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x641) and c:IsType(TYPE_ACCESS)
		and Duel.IsExistingMatchingCard(c101269004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c101269004.filter2(c,e,tp,mc)
	return c:IsSetCard(0x641) and mc:IsCanBeAccessMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_ACCESS,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c101269004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101269004.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101269004.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101269004.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101269004.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101269004.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,SUMMON_TYPE_ACCESS,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
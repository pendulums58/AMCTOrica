--신비로 벼린 위광
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)		
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)
		and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp)
		and Duel.CheckGiftEffect(tp,s.gfilter) end
	local tc=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
end
function s.gfilter(c)
	return c:IsSetCard(SETCARD_MYSTERY)
end
function s.tgfilter(c,e,tp)
	local g=c:GetColumnGroup()
	return g:IsExists(s.tgchk1,1,nil,tp) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp))
end
function s.tgchk1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SETCARD_MYSTERY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetColumnGroup()
		if g:IsExists(s.tgchk1,1,nil,tp) then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) then
				local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
				if g1:GetCount()>0 then
					Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
	Duel.AddGiftEffect(e,s.gfilter,s.geffect,2300,0)	
end
function s.geffect(e,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)	
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,SETCARD_MYSTERY)>0 end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,SETCARD_MYSTERY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*300)
		c:RegisterEffect(e1)
		if Duel.IsPlayerCanSpecialSummonMonster(tp,101226013,0xf,0x4011,2500,2500,10,RACE_DIVINE,ATTRIBUTE_DIVINE,POS_FACEUP,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local token=Duel.CreateToken(tp,101226013)
			Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end
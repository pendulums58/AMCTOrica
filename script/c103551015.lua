--에스카론식 환성구원
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLocation(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.tgfilter(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,103551016,SETCARD_SAINTMIRAGE,0x4011,0,0,1,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP,tp) and Duel.CheckGiftEffect(tp,s.gfilter) end
	local tc=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN,nil,1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local token=Duel.CreateToken(103551016,tp)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,token,tc)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(g,1-tp)
			end
		end
		if Duel.IsExistingMatchingCard(s.chk,tp,LOCATION_MZONE,0,1,nil) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e1:SetTarget(s.etarget)
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_STANDBY,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
	Duel.AddGiftEffect(e,s.gfilter,s.geffect,1800,1200)
end
function s.etarget(e,c)
	return c:IsType(TYPE_EQUIP)
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.tgfilter(c,tp)
	return c:IsSetCard(SETCARD_SAINTMIRAGE) and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function s.eqfilter(c,tc)
	return c:CheckEquipTarget(tc) and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thfilter(c,token,tc)
	return c:CheckEquipTarget(tc) and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
		 and not c:CheckEquipTarget(token)
end
function s.chk(c)
	return c:IsFaceup() and c:IsSetCard(SETCARD_SAINTMIRAGE) and c:IsType(TYPE_PAIRING)
end
function s.gfilter(c)
	return c:GetEquipCount()>0
end
function s.geffect(e,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetDescription(aux.Stringid(id,1))	
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,c,c,tp)end
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c,c,tp)
	if tc:GetCount()>0 then
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
		e:SetLabelObject(tc)
	end
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabelObject():GetFirst()
	if c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,rc,c,tp)
		if g:GetCount()>0 then
			if not g:GetFirst():IsAbleToHand() then
				Duel.Equip(tp,g:GetFirst(),c)
			else
				if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
					if Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0 then
						Duel.SendtoHand(g,nil,REASON_EFFECT)
						Duel.ConfirmCardS(g,1-tp)
					else
						Duel.Equip(tp,g:GetFirst(),c)
					end
				else
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCardS(g,1-tp)
				end
			end
		end
	end
end
function s.cfilter(c,tc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil,c,tc,tp)
end
function s.thfilter1(c,rmc,eqc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:CheckEquipTarget(eqc)
		and not c:CheckEquipTarget(rmc) and (c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
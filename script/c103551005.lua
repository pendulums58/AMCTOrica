--편환성검 하프크레센트
local s,id=GetID()
function c103551005.initial_effect(c)
	--장착
	local e0=aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),nil,nil,s.tg,s.op)
	e0:SetCountLimit(1,id)
	--추가 일반 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103551005,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(c103551005.nsfilter)
	c:RegisterEffect(e2)
	--묘지로 보낸다
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_TOGRAVE)
	e5:SetCondition(c103551005.sdcon)
	c:RegisterEffect(e5)	
end
function c103551005.sdcon(e)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,ATTRIBUTE_DARK)
end
function c103551005.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c103551005.eqfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c103551005.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103551005.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c103551005.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
		local g=Duel.GetMatchingGroup(c103551005.thfilter,tp,LOCATION_DECK,0,nil,tc:GetAttribute())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(103551005,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c103551005.thfilter(c,att)
	return c:IsAbleToHand() and c:IsSetCard(0x64b) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(att)
end
function c103551005.nsfilter(e,c)
	local tc=e:GetHandler()
	local ttc=tc:GetEquipTarget()
	if not ttc then return end
	return c:IsAttribute(ttc:GetAttribute())
end
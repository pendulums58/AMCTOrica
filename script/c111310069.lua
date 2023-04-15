--여환의 계승자
c111310069.AccessMonsterAttribute=true
function c111310069.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310069.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310069,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310069.eqcon)
	e1:SetTarget(c111310069.eqtg)
	e1:SetOperation(c111310069.eqop)
	c:RegisterEffect(e1)
	--어드민 장착
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCondition(c111310069.eqcon1)
	e2:SetTarget(c111310069.eqtg1)
	e2:SetOperation(c111310069.eqop1)	
	c:RegisterEffect(e2)
end
function c111310069.afil1(c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipCount()>0
end
function c111310069.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310069.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c111310069.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c111310069.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c111310069.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c111310069.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c111310069.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if not Duel.Equip(tp,tc,c,false) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c111310069.eqlimit)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(800)
	tc:RegisterEffect(e2)
end
function c111310069.eqlimit(e,c)
	return e:GetOwner()==c
end
function c111310069.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c111310069.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:GetAdmin()~=nil end
end
function c111310069.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad==nil then return end
	if not Duel.Equip(tp,ad,c,false) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c111310069.eqlimit)
	ad:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(800)
	ad:RegisterEffect(e2)
	local g=c:GetEquipGroup()
	if Duel.SelectYesNo(tp,aux.Stringid(111310069,0)) then
		local tc=g:Select(tp,cyan.IsCanBeAdmin,1,nil,c)
		tc=tc:GetFirst()
		Duel.SetAdmin(c,tc,e)
	end
end
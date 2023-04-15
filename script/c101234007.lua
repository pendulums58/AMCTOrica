--진 여환무장【미카즈키 쌍익】
c101234007.AccessMonsterAttribute=true
function c101234007.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101234007.afil1,c101234007.afil2)
	c:EnableReviveLimit()
	--1번 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101234007.con)
	e1:SetTarget(c101234007.thtg)
	e1:SetOperation(c101234007.thop)
	c:RegisterEffect(e1)
	--2번 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101234007,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCost(c101234007.cost)
	e2:SetTarget(c101234007.target)
	e2:SetOperation(c101234007.operation)
	c:RegisterEffect(e2)
	--3번 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101234007,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(2)
	e3:SetCondition(c101234007.recon)
	e3:SetCost(c101234007.cost2)
	e3:SetTarget(c101234007.retg)
	e3:SetOperation(c101234007.reop)
	c:RegisterEffect(e3)
end
function c101234007.afil1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x611)
end
function c101234007.afil2(c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipCount()>0
end
function c101234007.con(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c101234007.eqfilter(c)
   return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x611)
end
function c101234007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
      return Duel.IsExistingMatchingCard(c101234007.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
   end
   Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c101234007.thop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    local c=e:GetHandler()
    local eq=Duel.GetMatchingGroup(c101234007.eqfilter,tp,LOCATION_GRAVE,0,nil)
    if ft>eq:GetCount() then ft=eq:GetCount() end
    if ft==0 then return end
    local ec=eq:Select(tp,ft,ft,nil)
    local tc=ec:GetFirst()
    while tc do
      if c and Duel.Equip(tp,tc,c) then
         local e1=Effect.CreateEffect(e:GetHandler())
         e1:SetType(EFFECT_TYPE_SINGLE)
         e1:SetCode(EFFECT_EQUIP_LIMIT)
         e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
         e1:SetReset(RESET_EVENT+RESETS_STANDARD)
         e1:SetValue(c101234007.eqlimit)
         e1:SetLabelObject(c)
         tc:RegisterEffect(e1)
      end   
      tc=ec:GetNext()
    end
   Duel.EquipComplete()
end
function c101234007.eqlimit(e,c)
   return c==e:GetLabelObject()
end
function c101234007.filter(c,ec)
	return c:GetEquipTarget()==ec and c:IsAbleToRemoveAsCost()
end
function c101234007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101234007.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101234007.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101234007.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER)
end
function c101234007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101234007.filter1(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101234007.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101234007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,c101234007.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local eqc=eq:GetFirst()
	if eqc and Duel.Equip(tp,eqc,c) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101234007.eqlimit)
		e1:SetLabelObject(c)
		eqc:RegisterEffect(e1)
	end
end
function c101234007.recon(e,tp,eg,ep,ev,re,r,rp)
   local ad=e:GetHandler():GetAdmin()
   if not ad then return false end
   return ad:IsSetCard(0x611) and ad:IsType(TYPE_FUSION)
end
function c101234007.filter2(c,ec)
	return c:GetEquipTarget()==ec and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x611)
end
function c101234007.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101234007.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101234007.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101234007.filter3(c)
	return c:IsAbleToChangeControler()
end
function c101234007.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c101234007.filter3(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101234007.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c101234007.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,c101234007.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	local eqc=eq:GetFirst()
	if eqc and Duel.Equip(tp,eqc,c) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101234007.eqlimit)
		e1:SetLabelObject(c)
		eqc:RegisterEffect(e1)
	end
end
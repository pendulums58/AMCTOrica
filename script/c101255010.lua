--환영검 듀라달
function c101255010.initial_effect(c)
	--특정 상황에서 소멸
	cyan.SemiTokenAttribute(c)	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c101255010.target)
	e1:SetOperation(c101255010.operation)
	c:RegisterEffect(e1)
	--장착 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c101255010.eqlimit)
	c:RegisterEffect(e2)
	--공뻥
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	--파괴
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c101255010.destg)
	e4:SetOperation(c101255010.desop)
	c:RegisterEffect(e4)
end
function c101255010.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c101255010.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c101255010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101255010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101255010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101255010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c101255010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c101255010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler():GetEquipTarget()
	if ec==nil then return false end
	if chkc then return chkc:IsOnField() and c101255010.desfilter1(chkc,ec:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c101255010.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ec:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101255010.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ec:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101255010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)==0 and Duel.SelectYesNo(tp,aux.Stringid(101255010,1)) then
			local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
			if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
		end
	end
end
function c101255010.desfilter1(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end

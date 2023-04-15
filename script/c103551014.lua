--명환성검 어나더크레센트
function c103551014.initial_effect(c)
	--개방 영속 효과
	cyan.SetUnlockedEffect(c,c103551014.unlockeff)	
	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103551014,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c103551014.target)
	e1:SetOperation(c103551014.operation)
	c:RegisterEffect(e1)
	--장착 조건 무시
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_EQUIP_IGNORE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(1)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)	
end
function c103551014.unlockeff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c103551014.thcon)
	cyan.JustSearch(e1,LOCATION_GRAVE,Card.IsType,TYPE_EQUIP)
	Duel.RegisterEffect(e1,tp)	
end
function c103551014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c103551014.filter(c,e,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c103551014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c103551014.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c103551014.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	local tc=Duel.SelectTarget(tp,c103551014.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c103551014.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tc=Duel.GetFirstTarget()
	if ft<1 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Equip(tp,tc,c)
end
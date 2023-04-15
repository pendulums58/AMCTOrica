--메리 고 라운드
function c101223103.initial_effect(c)
	--컨트롤 변경
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_CONTROL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCountLimit(1)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(c101223103.cont)
	e0:SetOperation(c101223103.rol)
	c:RegisterEffect(e0)
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function c101223103.swapfilter(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c101223103.cont(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.IsExistingTarget(c101223103.swapfilter,tp,0,LOCATION_MZONE,1,nil) end
	if Duel.GetMZoneCount(tp,e:GetHandler(),tp,LOCATION_REASON_CONTROL)>0
		and Duel.IsExistingTarget(c101223103.swapfilter,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local mon=Duel.SelectTarget(tp,c101223103.swapfilter,tp,0,LOCATION_MZONE,1,1,nil)
		mon:AddCard(e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,mon,2,0,0)
	end
end
function c101223103.rol(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		Duel.SwapControl(c,tc)
	end
end

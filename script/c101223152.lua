--프라임 패스『엑시즈』
function c101223152.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FALSE,12,2,c101223152.ovfilter,aux.Stringid(101223152,0),2,c101223152.xyzop)
	c:EnableReviveLimit()
	--대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cyan.XyzSSCon)
	e2:SetOperation(c101223152.sdop)
	c:RegisterEffect(e2)	
	--마법 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c101223152.efilter)
	c:RegisterEffect(e3)
	--강제 바운스
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c101223152.cost)
	e4:SetTarget(c101223152.target)
	e4:SetOperation(c101223152.operation)
	c:RegisterEffect(e4)
	if not c101223152.global_check then
		c101223152.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c101223152.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c101223152.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c101223152.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101223152)>2 and Duel.GetFlagEffect(tp,101223952)==0 end
	Duel.RegisterFlagEffect(tp,101223952,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101223152.check(c)
	return c and c:IsType(TYPE_XYZ)
end
function c101223152.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc and c101223152.check(tc) and ep==tp then
		Duel.RegisterFlagEffect(tp,101223152,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,101223152,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101223152.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101223152.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101223152.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c101223152.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,nil,0)
end
function c101223152.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_RULE)
	end
end
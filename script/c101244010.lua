--패러리얼 월드워커
function c101244010.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c101244010.twfilter,c101244010.twfilter1,1,true,true)
	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101244010,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c101244010.atkcon)
	e1:SetCost(c101244010.atkcost)
	e1:SetOperation(c101244010.atkop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101244010,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetCost(c101244010.cost)
	e2:SetTarget(c101244010.target1)
	e2:SetOperation(c101244010.operation1)
	c:RegisterEffect(e2)	
end
function c101244010.twfilter(c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_MONSTER)
end
function c101244010.twfilter1(c)
	return c:IsSetCard(0x61e) and c:IsType(TYPE_MONSTER)
end
function c101244010.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil 
end
function c101244010.cfilter(c,tp)
	return c:GetOwner()==1-tp and not c:IsPublic()
end
function c101244010.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101244010.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101244010.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101244010.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(2000)
		c:RegisterEffect(e1)
	end
end
function c101244010.costfilter(c,tp)
	local ctype=0
	for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if c:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
	end
	return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c101244010.thfilter,tp,0,LOCATION_GRAVE,1,nil,ctype)
end
function c101244010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101244010.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c101244010.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	local ctype=0
	for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if tc:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
	end
	e:SetLabel(ctype)
end
function c101244010.thfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToHand()
end
function c101244010.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c101244010.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101244010.thfilter,tp,0,LOCATION_GRAVE,1,1,nil,ty)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
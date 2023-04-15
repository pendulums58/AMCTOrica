--패러리얼 어드미니스트레이터
function c101244013.initial_effect(c)
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c101244013.ffilter1,c101244013.ffilter,3,true,true)
	--융합 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101244013,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101244013.atkcon1)
	e1:SetTarget(c101244013.target)
	e1:SetOperation(c101244013.activate1)
	c:RegisterEffect(e1)
	--전투 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--발동 불가능 제약
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101244013,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c101244013.retcon)
	e3:SetCost(c101244013.cost)
	e3:SetTarget(c101244013.rettg)
	e3:SetOperation(c101244013.retop)
	c:RegisterEffect(e3)
end
function c101244013.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x61e) and c:IsType(TYPE_MONSTER) and c:IsFusionType(TYPE_FUSION)
end
function c101244013.ffilter(c,fc,sub,mg,sg)
	local ctype=0
	local g=Group.CreateGroup()
	for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if c:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
	end
	if sg then
		if sg:IsExists(Card.IsType,1,c,TYPE_SPELL) then
			return c:IsType(TYPE_SPELL)
		end
		if sg:IsExists(Card.IsType,1,c,TYPE_TRAP) then
			return c:IsType(TYPE_TRAP)
		end	
		if sg:IsExists(Card.IsType,2,c,TYPE_MONSTER) then
			return c:IsType(TYPE_MONSTER)
		end	
	end

	return true
end
function c101244013.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101244013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(1-tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101244013.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,p,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	end
end
function c101244013.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101244013.costfilter(c,tp)
	return c:GetOwner()==1-tp and c:IsAbleToGraveAsCost()
end
function c101244013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101244013.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c101244013.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
end
function c101244013.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c101244013.retop(e,tp,eg,ep,ev,re,r,rp)
	local ctype=0
	local lb=e:GetLabelObject()
	for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if lb:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if ctype==TYPE_MONSTER then
		e1:SetDescription(aux.Stringid(101244013,0))
		e1:SetValue(c101244013.aclimit1)
	elseif ctype==TYPE_SPELL then
		e1:SetDescription(aux.Stringid(101244013,1))
		e1:SetValue(c101244013.aclimit2)
	else
		e1:SetDescription(aux.Stringid(101244013,2))
		e1:SetValue(c101244013.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101244013.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c101244013.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function c101244013.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end
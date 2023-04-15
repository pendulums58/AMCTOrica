--미스트레이퍼 스트래터스
function c111332003.initial_effect(c)
--어드밴스 소환
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
    e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENCE)	
	e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x643))
    c:RegisterEffect(e1)
--공격력
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c111332003.value)
	c:RegisterEffect(e2)
--무효
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111332003,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,111332003)
	e3:SetCondition(c111332003.discon)
	e3:SetTarget(c111332003.distg)
	e3:SetOperation(c111332003.disop)
	c:RegisterEffect(e3)	
end
--공격력
function c111332003.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x643)
end
function c111332003.value(e,c)
	return Duel.GetMatchingGroupCount(c111332003.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil,nil)*700
end
--무효

function c111332003.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and re:GetHandler():IsSetCard(0x643)
		and Duel.IsChainDisablable(ev)
end
function c111332003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,111332103,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)	
end
function c111332003.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,111332103,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,111332103)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,111332103))
	e1:SetValue(c111332003.lklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)		
end
function c111332003.lklimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
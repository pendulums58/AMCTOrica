--벤투스 할로우패스
c111310068.AccessMonsterAttribute=true
function c111310068.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310068.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--공격 대상이 되지 않음
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c111310068.cond)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--직접 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCondition(c111310068.cond2)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--회복
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310068,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_TYPE_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c111310068.reccon)
	e3:SetTarget(c111310068.rectg)
	e3:SetOperation(c111310068.recop)
	c:RegisterEffect(e3)
end
function c111310068.afil1(c)
	local lv=c:GetAttack()
	return not Duel.IsExistingMatchingCard(c111310068.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv)
end
function c111310068.cfilter(c,ml)
	return c:IsFaceup() and c:GetAttack()<ml
end
function c111310068.cond(e)
	return e:GetHandler():GetAdmin()~=nil
end
function c111310068.cond2(e)
	local ad=e:GetHandler():GetAdmin()
	return ad and ad:IsAttribute(ATTRIBUTE_WIND)
end
function c111310068.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c111310068.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c111310068.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

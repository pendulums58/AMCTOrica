--신살마녀 델피그리
c101226016.AccessMonsterAttribute=true
function c101226016.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101226016.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101226016.atkcon)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c101226016.atkval)
	c:RegisterEffect(e1)
	--최고 공격력 죽이기
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101226016.tgcost)
	e2:SetOperation(c101226016.tgop)
	c:RegisterEffect(e2)
	--공격 불가 효과
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c101226016.atlimit)
	c:RegisterEffect(e3)	
end
function c101226016.afil1(c)
	return c:IsSetCard(0x612)
end
function c101226016.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c101226016.atkval(e,c)
	local ad=e:GetHandler():GetAdmin()
	if ad==nil then return 0 end
	return ad:GetAttack()
end
function c101226016.costfilter(c)
	return c:IsSetCard(0x612) and c:IsAbleToRemoveAsCost()
end
function c101226016.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101226016.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101226016.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101226016.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101226016.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if g:GetCount()>1 then g=g:Select(tp,1,1,nil) end
	Duel.SendtoGrave(g,REASON_EFECT)
end
function c101226016.tgfilter(c,tp)
	return not Duel.IsExistingMatchingCard(c101226016.atkcheck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c101226016.atkcheck(c,atk)
	return c:GetAttack()>atk
end
function c101226016.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x612)
end
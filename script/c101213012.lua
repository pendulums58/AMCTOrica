--결연희-유즈키-
function c101213012.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,3,c101213012.lcheck)
	c:EnableReviveLimit()
	
	--평온의 결연희
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c101213012.con1)
	e1:SetTarget(c101213012.indestg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	--순수의 결연희
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetCondition(c101213012.con2)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101213012.reptg)
	e2:SetValue(c101213012.repval)
	c:RegisterEffect(e2)
	
	--냉혹의 결연희
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCondition(c101213012.con3)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xef3))
	e3:SetValue(700)
	c:RegisterEffect(e3)
end
function c101213012.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xef3)
end
function c101213012.indesfil(c)
	return c:IsFaceup() and c:IsCode(101213011)
end
function c101213012.con1(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c101213012.indesfil,1,nil)
end
function c101213012.indestg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xef3) and c:IsType(TYPE_MONSTER)
end
function c101213012.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xef3) 
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c101213012.rmfilter(c)
	return c:IsSetCard(0xef3) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c101213012.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101213012.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c101213012.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c101213012.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end
function c101213012.repval(e,c)
	return c101213012.repfilter(c,e:GetHandlerPlayer())
end
function c101213012.indesfil2(c)
	return c:IsFaceup() and c:IsCode(101213009)
end
function c101213012.con2(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c101213012.indesfil2,1,nil)
end
function c101213012.indesfil3(c)
	return c:IsFaceup() and c:IsCode(101213010)
end
function c101213012.con3(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c101213012.indesfil3,1,nil)
end
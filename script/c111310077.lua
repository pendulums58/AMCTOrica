--결원합일창【궁니르】
c111310077.AccessMonsterAttribute=true
function c111310077.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310077.afil1,aux.TRUE,c111310077.accheck)
	c:EnableReviveLimit()
	--액세스 소환 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310077,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c111310077.con)
	e1:SetTarget(c111310077.tg)
	e1:SetOperation(c111310077.op)
	c:RegisterEffect(e1)
	--전투 / 효과 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c111310077.indcon)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end
function c111310077.afil1(c)
	return c:IsType(TYPE_PAIRING)
end
function c111310077.accheck(c,tc,ac)
	local pr=tc:GetPair()
	if pr:IsContains(c) then return true end
	return false
end
function c111310077.prcheck(c)
	return c:GetPair():GetCount()>0
end
function c111310077.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310077.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local mc=Duel.GetMatchingGroupCount(c111310077.prcheck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return mc>1 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mc,nil)
	local rmg=g:Filter(Card.IsFacedown,nil)
	if rmg:GetCount()>0 then 
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rmg,rmg:GetCount(),0,0)
	end
	local pog=g:Filter(Card.IsFaceup,nil)
	if pog:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,pog,pog:GetCount(),0,0)
	end
end
function c111310077.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local rmg=sg:Filter(Card.IsFacedown,nil)
	if rmg:GetCount()>0 then
		Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
	end
	local pog=sg:Filter(Card.IsFaceup,nil)
	if pog:GetCount()>0 then
		local m=pog:Filter(Card.IsType,nil,TYPE_MONSTER)
		pog:Sub(m)
		Duel.ChangePosition(m,POS_FACEDOWN_DEFENSE)
		Duel.ChangePosition(pog,POS_FACEDOWN)
	end	
end
function c111310077.indcon(e)
	local ad=e:GetHandler():GetAdmin()
	return ad and ad:IsType(TYPE_PAIRING)
end
--풍류 벚꽃
function c103555010.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c103555010.afil1,aux.TRUE)
	c:EnableReviveLimit()
	--직접 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c103555010.con)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c103555010.thcon)
	e2:SetCountLimit(1,103555010)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,0x65a)
	c:RegisterEffect(e2)
	cyan.AddSakuraEffect(c)
end
function c103555010.afil1(c)
	return c:IsSetCard(0x65a)
end
function c103555010.con(e)
	local c=e:GetHandler()
	return c:GetAdmin():IsSetCard(0x65a) and c:GetAdmin():IsType(TYPE_MONSTER)
end
function c103555010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

